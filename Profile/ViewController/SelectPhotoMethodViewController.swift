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

    var viewModel = SelectPhotoMethodViewModel(authorType: .people)
    let hud = JGProgressHUD()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.headlineLabel.font = UIFont.asset(.regular, fontSize: .title)
        self.headlineLabel.textColor = UIColor.Asset.white
        self.subTitleLabel.font = UIFont.asset(.regular, fontSize: .head4)
        self.subTitleLabel.textColor = UIColor.Asset.white
        self.cameraRollButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .head4)
        self.cameraRollButton.setTitleColor(UIColor.Asset.lightBlue, for: .normal)
        self.cameraRollButton.setBackgroundImage(UIColor.Asset.darkGraphiteBlue.toImage(), for: .normal)
        self.cameraRollButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.Asset.lightBlue)
        self.takePhotoButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .head4)
        self.takePhotoButton.setTitleColor(UIColor.Asset.white, for: .normal)
        self.takePhotoButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
        self.takePhotoButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.clear)
        self.viewModel.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Defaults[.screenId] = ""
        self.hud.textLabel.text = "Saving"
        self.setupNavBar()
        self.headlineLabel.text = Localization.ChooseProfileImage.headline.text
        self.subTitleLabel.text = Localization.ChooseProfileImage.description.text
        self.cameraRollButton.setTitle(Localization.ChooseProfileImage.cameraRoll.text, for: .normal)
        self.takePhotoButton.setTitle(Localization.ChooseProfileImage.takePhoto.text, for: .normal)
    }

    func setupNavBar() {
        if self.viewModel.authorType == .page {
            self.customNavigationBar(.primary, title: "", textColor: UIColor.Asset.white)
            let leftIcon = NavBarButtonType.back.barButton
            leftIcon.addTarget(self, action: #selector(leftButtonAction), for: .touchUpInside)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftIcon)

            var rightButton: [UIBarButtonItem] = []
            let icon = UIButton()
            icon.setTitle(Localization.ChooseProfileImage.skip.text, for: .normal)
            icon.titleLabel?.font = UIFont.asset(.bold, fontSize: .head4)
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
        if self.viewModel.authorType == .people {
            Utility.currentViewController().navigationController?.popViewController(animated: true)
        } else {
            let viewControllers: [UIViewController] = Utility.currentViewController().navigationController!.viewControllers as [UIViewController]
            Utility.currentViewController().navigationController!.popToViewController(viewControllers[viewControllers.count - 5], animated: true)
        }
    }

    @objc private func skipAction() {
        Utility.currentViewController().navigationController?.pushViewController(ProfileOpener.open(.about(AboutInfoViewModel(authorType: self.viewModel.authorType, castcleId: self.viewModel.castcleId, userRequest: self.viewModel.userRequest))), animated: true)
    }

    @IBAction func cameraRollAction(_ sender: Any) {
        let photosPickerAvatarViewController = TLPhotosPickerViewController()
        photosPickerAvatarViewController.delegate = self
        photosPickerAvatarViewController.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        photosPickerAvatarViewController.collectionView.backgroundColor = UIColor.clear
        photosPickerAvatarViewController.navigationBar.barTintColor = UIColor.Asset.darkGraphiteBlue
        photosPickerAvatarViewController.navigationBar.isTranslucent = false
        photosPickerAvatarViewController.titleLabel.font = UIFont.asset(.regular, fontSize: .overline)
        photosPickerAvatarViewController.subTitleLabel.font = UIFont.asset(.regular, fontSize: .small)
        photosPickerAvatarViewController.doneButton.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.asset(.bold, fontSize: .head4),
            NSAttributedString.Key.foregroundColor: UIColor.Asset.lightBlue
        ], for: .normal)
        photosPickerAvatarViewController.cancelButton.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.asset(.regular, fontSize: .body),
            NSAttributedString.Key.foregroundColor: UIColor.Asset.lightBlue
        ], for: .normal)
        var configureAvatar = TLPhotosPickerConfigure()
        configureAvatar.numberOfColumn = 3
        configureAvatar.singleSelectedMode = true
        configureAvatar.mediaType = .image
        configureAvatar.usedCameraButton = false
        configureAvatar.allowedLivePhotos = false
        configureAvatar.allowedPhotograph = false
        configureAvatar.allowedVideo = false
        configureAvatar.autoPlay = false
        configureAvatar.allowedVideoRecording = false
        configureAvatar.selectedColor = UIColor.Asset.lightBlue
        photosPickerAvatarViewController.configure = configureAvatar
        Utility.currentViewController().present(photosPickerAvatarViewController, animated: true, completion: nil)
    }

    @IBAction func takePhotoAction(_ sender: Any) {
        self.showCameraIfAuthorizedInSelectAvatarView()
    }

    private func showCameraIfAuthorizedInSelectAvatarView() {
        let cameraAuthorization = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraAuthorization {
        case .authorized:
            self.showCameraInSelectAvatarView()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { [weak self] (authorized) in
                DispatchQueue.main.async { [weak self] in
                    if authorized {
                        self?.showCameraInSelectAvatarView()
                    } else {
                        self?.handleDeniedCameraAuthorizationInSelectAvatarView()
                    }
                }
            })
        case .restricted, .denied:
            self.handleDeniedCameraAuthorizationInSelectAvatarView()
        @unknown default:
            break
        }
    }

    private func showCameraInSelectAvatarView() {
        let pickerAvatar = UIImagePickerController()
        pickerAvatar.sourceType = .camera
        var mediaTypes: [String] = []
        mediaTypes.append(kUTTypeImage as String)
        guard mediaTypes.count > 0 else {
            return
        }
        pickerAvatar.cameraDevice = .rear
        pickerAvatar.mediaTypes = mediaTypes
        pickerAvatar.allowsEditing = false
        pickerAvatar.delegate = self
        self.present(pickerAvatar, animated: true, completion: nil)
    }

    private func handleDeniedCameraAuthorizationInSelectAvatarView() {
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
    open func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
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
            if self.viewModel.authorType == .page {
                self.viewModel.updateUserAvatar(isPage: true)
            } else {
                self.viewModel.updateUserAvatar(isPage: false)
            }
        })
    }
}

extension SelectPhotoMethodViewController: SelectPhotoMethodViewModelDelegate {
    func didUpdateFinish(success: Bool) {
        if self.viewModel.isPage {
            if success {
                self.viewModel.getMyPage()
            } else {
                self.hud.dismiss()
            }
        } else {
            self.hud.dismiss()
            if success {
                Utility.currentViewController().navigationController?.pushViewController(ProfileOpener.open(.about(AboutInfoViewModel(authorType: self.viewModel.authorType, castcleId: self.viewModel.castcleId))), animated: true)
            }
        }
    }

    func didGetPageFinish() {
        self.hud.dismiss()
        Utility.currentViewController().navigationController?.pushViewController(ProfileOpener.open(.about(AboutInfoViewModel(authorType: self.viewModel.authorType, castcleId: self.viewModel.castcleId, userRequest: self.viewModel.userRequest))), animated: true)
    }
}
