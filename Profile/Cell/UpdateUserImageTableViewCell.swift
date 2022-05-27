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
//  UpdateUserImageTableViewCell.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 10/5/2565 BE.
//

import UIKit
import Photos
import MobileCoreServices
import Core
import Component
import JGProgressHUD
import TOCropViewController
import TLPhotoPicker

public protocol UpdateUserImageTableViewCellDelegate: AnyObject {
    func didUpdateImage(isProcess: Bool)
}

class UpdateUserImageTableViewCell: UITableViewCell {

    @IBOutlet var coverImage: UIImageView!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var editCoverButton: UIButton!
    @IBOutlet var editProfileImageButton: UIButton!
    @IBOutlet var displayNameLabel: UILabel!
    @IBOutlet var castcleIdLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var saveButton: UIButton!

    public var delegate: UpdateUserImageTableViewCellDelegate?
    let viewModel = UpdateUserImageViewModel()
    let hud = JGProgressHUD()
    private var updateImageType: UpdateImageType = .none

    override func awakeFromNib() {
        super.awakeFromNib()
        self.coverImage.image = UIImage.Asset.placeholder
        self.profileImage.image = UIImage.Asset.userPlaceholder
        self.profileImage.circle(color: UIColor.Asset.white)
        self.editProfileImageButton.setImage(UIImage.init(icon: .castcle(.camera), size: CGSize(width: 15, height: 15), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        self.editProfileImageButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
        self.editProfileImageButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.Asset.white)
        self.editCoverButton.setImage(UIImage.init(icon: .castcle(.camera), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        self.editCoverButton.setBackgroundImage(UIColor.Asset.gray.toImage(), for: .normal)
        self.editCoverButton.capsule()
        self.displayNameLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.displayNameLabel.textColor = UIColor.Asset.white
        self.castcleIdLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.castcleIdLabel.textColor = UIColor.Asset.lightGray
        self.titleLabel.font = UIFont.asset(.bold, fontSize: .body)
        self.titleLabel.textColor = UIColor.Asset.white
        self.subTitleLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.subTitleLabel.textColor = UIColor.Asset.white
        self.hud.textLabel.text = "Saving"
        self.saveButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .head4)
        self.saveButton.setTitleColor(UIColor.Asset.white, for: .normal)
        self.saveButton.capsule(color: UIColor.Asset.lightBlue, borderWidth: 1, borderColor: UIColor.Asset.lightBlue)
        self.viewModel.delegate = self
        self.displayNameLabel.text = UserManager.shared.displayName
        self.castcleIdLabel.text = UserManager.shared.castcleId
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func editCoverAction(_ sender: Any) {
        self.updateImageType = .cover
        self.selectImageSource()
    }

    @IBAction func editProfileImageAction(_ sender: Any) {
        self.updateImageType = .avatar
        self.selectImageSource()
    }

    @IBAction func saveAction(_ sender: Any) {
        self.delegate?.didUpdateImage(isProcess: true)
        if self.viewModel.avatar != nil || self.viewModel.cover != nil {
            self.hud.show(in: Utility.currentViewController().view)
            self.viewModel.updateProfile()
        } else {
            Utility.currentViewController().navigationController?.pushViewController(ProfileOpener.open(.updateUserInfo), animated: true)
        }
    }

    private func selectImageSource() {
        let actionSheet = CCActionSheet()
        let albumButton = CCAction(title: "Choose from Camera Roll", image: UIImage.init(icon: .castcle(.image), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white), style: .normal) {
            actionSheet.dismissActionSheet()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                self.selectCameraRoll()
            }
        }
        let cameraButton = CCAction(title: "Take Photo", image: UIImage.init(icon: .castcle(.camera), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white), style: .normal) {
            actionSheet.dismissActionSheet()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                self.selectTakePhoto()
            }
        }
        actionSheet.addActions([albumButton, cameraButton])
        Utility.currentViewController().present(actionSheet, animated: true, completion: nil)
    }

    private func selectCameraRoll() {
        let photosPickerViewController = TLPhotosPickerViewController()
        photosPickerViewController.delegate = self
        photosPickerViewController.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        photosPickerViewController.collectionView.backgroundColor = UIColor.clear
        photosPickerViewController.navigationBar.barTintColor = UIColor.Asset.darkGraphiteBlue
        photosPickerViewController.navigationBar.isTranslucent = false
        photosPickerViewController.titleLabel.font = UIFont.asset(.regular, fontSize: .overline)
        photosPickerViewController.subTitleLabel.font = UIFont.asset(.regular, fontSize: .small)
        photosPickerViewController.doneButton.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.asset(.bold, fontSize: .head4),
            NSAttributedString.Key.foregroundColor: UIColor.Asset.lightBlue
        ], for: .normal)
        photosPickerViewController.cancelButton.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.asset(.regular, fontSize: .body),
            NSAttributedString.Key.foregroundColor: UIColor.Asset.lightBlue
        ], for: .normal)

        var configure = TLPhotosPickerConfigure()
        configure.numberOfColumn = 3
        configure.singleSelectedMode = true
        configure.mediaType = .image
        configure.usedCameraButton = false
        configure.allowedLivePhotos = false
        configure.allowedPhotograph = false
        configure.allowedVideo = false
        configure.autoPlay = false
        configure.allowedVideoRecording = false
        configure.selectedColor = UIColor.Asset.lightBlue
        photosPickerViewController.configure = configure
        Utility.currentViewController().present(photosPickerViewController, animated: true, completion: nil)
    }

    private func selectTakePhoto() {
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
        Utility.currentViewController().present(picker, animated: true, completion: nil)
    }

    private func handleDeniedCameraAuthorization() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: "Denied camera permissions granted", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            Utility.currentViewController().present(alert, animated: true, completion: nil)
        }
    }

    private func presentCropViewController(image: UIImage, updateImageType: UpdateImageType) {
        if updateImageType == .avatar {
            let cropController = TOCropViewController(croppingStyle: .circular, image: image)
            cropController.delegate = self
            Utility.currentViewController().present(cropController, animated: true, completion: nil)
        } else {
            let cropController = TOCropViewController(croppingStyle: .default, image: image)
            cropController.aspectRatioPreset = .preset4x3
            cropController.aspectRatioLockEnabled = true
            cropController.resetAspectRatioEnabled = false
            cropController.aspectRatioPickerButtonHidden = true
            cropController.delegate = self
            Utility.currentViewController().present(cropController, animated: true, completion: nil)
        }
    }
}

extension UpdateUserImageTableViewCell: UpdateUserImageViewModelDelegate {
    func didUpdateInfoFinish(success: Bool) {
        self.hud.dismiss()
        if success {
            Utility.currentViewController().navigationController?.pushViewController(ProfileOpener.open(.updateUserInfo), animated: true)
        } else {
            self.delegate?.didUpdateImage(isProcess: false)
        }
    }
}

extension UpdateUserImageTableViewCell: TLPhotosPickerViewControllerDelegate {
    func shouldDismissPhotoPicker(withTLPHAssets: [TLPHAsset]) -> Bool {
        if let asset = withTLPHAssets.first {
            if let image = asset.fullResolutionImage {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if self.updateImageType == .avatar {
                        self.presentCropViewController(image: image, updateImageType: .avatar)
                    } else if self.updateImageType == .cover {
                        self.presentCropViewController(image: image, updateImageType: .cover)
                    }
                }
            }
        }
        return true
    }
}

extension UpdateUserImageTableViewCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    open func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
        picker.dismiss(animated: true, completion: {
            if self.updateImageType == .avatar {
                self.presentCropViewController(image: image, updateImageType: .avatar)
            } else if self.updateImageType == .cover {
                self.presentCropViewController(image: image, updateImageType: .cover)
            }
        })
    }
}

extension UpdateUserImageTableViewCell: TOCropViewControllerDelegate {
    func cropViewController(_ cropViewController: TOCropViewController, didCropToCircularImage image: UIImage, with cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true, completion: {
            if self.updateImageType == .avatar {
                let avatarCropImage = image.resizeImage(targetSize: CGSize.init(width: 200, height: 200))
                self.profileImage.image = avatarCropImage
                self.viewModel.avatar = avatarCropImage
            }
        })
    }

    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true, completion: {
            if self.updateImageType == .cover {
                let coverCropImage = image.resizeImage(targetSize: CGSize.init(width: 640, height: 480))
                self.coverImage.image = coverCropImage
                self.viewModel.cover = coverCropImage
            }
        })
    }
}
