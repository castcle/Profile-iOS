//  Copyright (c) 2021, Castcle and/or its affiliates. All rights reserved.
//  DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
//
//  This code is free software; you can redistribute it and/or modify it
//  under the terms of the GNU General Public License version 3 only, as
//  published by the Free Software Foundation.
//
//  This code is distributed in the hope that it will be useful, but WITHOUT
//  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
//  FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
//  version 3 for more details (a copy is included in the LICENSE file that
//  accompanied this code).
//
//  You should have received a copy of the GNU General Public License version
//  3 along with this work; if not, write to the Free Software Foundation,
//  Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
//
//  Please contact Castcle, 22 Phet Kasem 47/2 Alley, Bang Khae, Bangkok,
//  Thailand 10160, or visit www.castcle.com if you need additional information
//  or have any questions.
//
//  SelectPhotoMethodViewController.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 5/8/2564 BE.
//

import UIKit
import Photos
import MobileCoreServices
import Core
import TLPhotoPicker
import TOCropViewController
import Defaults
import JGProgressHUD

class SelectPhotoMethodViewController: UIViewController {

    @IBOutlet var introImage: UIImageView!
    @IBOutlet var headlineLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var cameraRollButton: UIButton!
    @IBOutlet var takePhotoButton: UIButton!
    
    var viewModel = SelectPhotoMethodViewModel(avatarType: .user)
    let hud = JGProgressHUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.setupNavBar()
        self.headlineLabel.font = UIFont.asset(.regular, fontSize: .title)
        self.headlineLabel.textColor = UIColor.Asset.white
        self.subTitleLabel.font = UIFont.asset(.regular, fontSize: .h4)
        self.subTitleLabel.textColor = UIColor.Asset.white
        
        self.cameraRollButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .h4)
        self.cameraRollButton.setTitleColor(UIColor.Asset.lightBlue, for: .normal)
        self.cameraRollButton.setBackgroundImage(UIColor.Asset.darkGraphiteBlue.toImage(), for: .normal)
        self.cameraRollButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.Asset.lightBlue)
        self.takePhotoButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .h4)
        self.takePhotoButton.setTitleColor(UIColor.Asset.white, for: .normal)
        self.takePhotoButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
        self.takePhotoButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.clear)
        
        self.viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Defaults[.screenId] = ""
        self.hud.textLabel.text = "Saving"
    }
    
    func setupNavBar() {
        if self.viewModel.avatarType == .page {
            self.customNavigationBar(.primary, title: "", textColor: UIColor.Asset.white)
            
            let leftIcon = NavBarButtonType.back.barButton
            leftIcon.addTarget(self, action: #selector(leftButtonAction), for: .touchUpInside)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftIcon)
            
            var rightButton: [UIBarButtonItem] = []
            
            let icon = UIButton()
            icon.setTitle("Skip", for: .normal)
            icon.titleLabel?.font = UIFont.asset(.bold, fontSize: .h4)
            icon.setTitleColor(UIColor.Asset.lightBlue, for: .normal)
            icon.addTarget(self, action: #selector(skipAction), for: .touchUpInside)
            rightButton.append(UIBarButtonItem(customView: icon))

            self.navigationItem.rightBarButtonItems = rightButton
        } else {
            self.customNavigationBar(.primary, title: "", textColor: UIColor.Asset.white)
            let leftIcon = NavBarButtonType.back.barButton
            leftIcon.addTarget(self, action: #selector(leftButtonAction), for: .touchUpInside)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftIcon)
        }
    }
    
    @objc private func leftButtonAction() {
        if self.viewModel.avatarType == .user {
            Utility.currentViewController().navigationController?.popViewController(animated: true)
        } else {
            let viewControllers: [UIViewController] = Utility.currentViewController().navigationController!.viewControllers as [UIViewController]
            Utility.currentViewController().navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
        }
    }
    
    @objc private func skipAction() {
        Utility.currentViewController().navigationController?.pushViewController(ProfileOpener.open(.about(AboutInfoViewModel(avatarType: self.viewModel.avatarType, castcleId: self.viewModel.castcleId, pageRequest: self.viewModel.pageRequest))), animated: true)
    }
    
    @IBAction func cameraRollAction(_ sender: Any) {
        let photosPickerViewController = TLPhotosPickerViewController()
        photosPickerViewController.delegate = self
        photosPickerViewController.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        photosPickerViewController.collectionView.backgroundColor = UIColor.clear
        photosPickerViewController.navigationBar.barTintColor = UIColor.Asset.darkGraphiteBlue
        photosPickerViewController.navigationBar.isTranslucent = false
        photosPickerViewController.titleLabel.font = UIFont.asset(.regular, fontSize: .overline)
        photosPickerViewController.subTitleLabel.font = UIFont.asset(.regular, fontSize: .small)
        
        photosPickerViewController.doneButton.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.asset(.bold, fontSize: .h4),
            NSAttributedString.Key.foregroundColor : UIColor.Asset.lightBlue
        ], for: .normal)
        photosPickerViewController.cancelButton.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.asset(.regular, fontSize: .body),
            NSAttributedString.Key.foregroundColor : UIColor.Asset.lightBlue
        ], for: .normal)

        var configure = TLPhotosPickerConfigure()
        configure.numberOfColumn = 3
        configure.singleSelectedMode = true
        configure.mediaType = .image
        configure.usedCameraButton = false
        configure.allowedLivePhotos = false
        configure.allowedPhotograph = true
        configure.allowedVideo = false
        configure.allowedVideoRecording = false
        configure.selectedColor = UIColor.Asset.lightBlue
        photosPickerViewController.configure = configure

        Utility.currentViewController().present(photosPickerViewController, animated: true, completion: nil)
    }
    
    @IBAction func takePhotoAction(_ sender: Any) {
        self.showCameraIfAuthorized()
    }
    
    private func showCameraIfAuthorized() {
        let cameraAuthorization = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraAuthorization {
        case .authorized:
            self.showCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { [weak self] (authorized) in
                DispatchQueue.main.async { [weak self] in
                    if authorized {
                        self?.showCamera()
                    } else {
                        self?.handleDeniedCameraAuthorization()
                    }
                }
            })
        case .restricted, .denied:
            self.handleDeniedCameraAuthorization()
        @unknown default:
            break
        }
    }
    
    private func showCamera() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        var mediaTypes: [String] = []
        mediaTypes.append(kUTTypeImage as String)
        
        guard mediaTypes.count > 0 else {
            return
        }
        picker.cameraDevice = .rear
        picker.mediaTypes = mediaTypes
        picker.allowsEditing = false
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    private func handleDeniedCameraAuthorization() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "", message: "Denied camera permissions granted", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            Utility.currentViewController().present(alert, animated: true, completion: nil)
        }
    }
    
    private func presentCropViewController(image: UIImage) {
        let cropController = TOCropViewController(croppingStyle: .circular, image: image)
        cropController.delegate = self
        self.present(cropController, animated: true, completion: nil)
    }
}

extension SelectPhotoMethodViewController: TLPhotosPickerViewControllerDelegate {
    func shouldDismissPhotoPicker(withTLPHAssets: [TLPHAsset]) -> Bool {
        if let asset = withTLPHAssets.first {
            if let image = asset.fullResolutionImage {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.presentCropViewController(image: image)
                }
            }
        }
        return true
    }
}

extension SelectPhotoMethodViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    open func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
        
        picker.dismiss(animated: true, completion: {
            self.presentCropViewController(image: image)
        })
    }
}

extension SelectPhotoMethodViewController: TOCropViewControllerDelegate {
    func cropViewController(_ cropViewController: TOCropViewController, didCropToCircularImage image: UIImage, with cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true, completion: {
            self.viewModel.avatar = image.resizeImage(targetSize: CGSize.init(width: 500, height: 500))
            self.hud.show(in: self.view)
            if self.viewModel.avatarType == .page {
                self.viewModel.updatePageAvatar()
            } else {
                self.viewModel.updateUserAvatar()
            }
        })
    }
}

extension SelectPhotoMethodViewController: SelectPhotoMethodViewModelDelegate {
    func didUpdateUserFinish(success: Bool) {
        self.hud.dismiss()
        if success {
            Utility.currentViewController().navigationController?.pushViewController(ProfileOpener.open(.about(AboutInfoViewModel(avatarType: self.viewModel.avatarType))), animated: true)
        }
    }
    
    func didUpdatePageFinish(success: Bool) {
        if success {
            self.viewModel.getMyPage()
        } else {
            self.hud.dismiss()
        }
    }
    
    func didGetPageFinish() {
        self.hud.dismiss()
        print(self.viewModel.pageRequest)
        Utility.currentViewController().navigationController?.pushViewController(ProfileOpener.open(.about(AboutInfoViewModel(avatarType: self.viewModel.avatarType, castcleId: self.viewModel.castcleId, pageRequest: self.viewModel.pageRequest))), animated: true)
    }
}
