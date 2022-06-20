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
    let viewModel = UpdateUserInfoViewModel()
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
        self.selectImageSourceUserImage()
    }

    @IBAction func editProfileImageAction(_ sender: Any) {
        self.updateImageType = .avatar
        self.selectImageSourceUserImage()
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

    private func selectImageSourceUserImage() {
        let actionSheet = CCActionSheet()
        let albumButton = CCAction(title: "Choose from Camera Roll", image: UIImage.init(icon: .castcle(.image), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white), style: .normal) {
            actionSheet.dismissActionSheet()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                self.selectCameraRollUserImage()
            }
        }
        let cameraButton = CCAction(title: "Take Photo", image: UIImage.init(icon: .castcle(.camera), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white), style: .normal) {
            actionSheet.dismissActionSheet()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                self.selectTakePhotoUserImage()
            }
        }
        actionSheet.addActions([albumButton, cameraButton])
        Utility.currentViewController().present(actionSheet, animated: true, completion: nil)
    }

    private func selectCameraRollUserImage() {
        let photosPickerUserImageViewController = TLPhotosPickerViewController()
        photosPickerUserImageViewController.delegate = self
        photosPickerUserImageViewController.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        photosPickerUserImageViewController.collectionView.backgroundColor = UIColor.clear
        photosPickerUserImageViewController.navigationBar.barTintColor = UIColor.Asset.darkGraphiteBlue
        photosPickerUserImageViewController.navigationBar.isTranslucent = false
        photosPickerUserImageViewController.titleLabel.font = UIFont.asset(.regular, fontSize: .overline)
        photosPickerUserImageViewController.subTitleLabel.font = UIFont.asset(.regular, fontSize: .small)
        photosPickerUserImageViewController.doneButton.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.asset(.bold, fontSize: .head4),
            NSAttributedString.Key.foregroundColor: UIColor.Asset.lightBlue
        ], for: .normal)
        photosPickerUserImageViewController.cancelButton.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.asset(.regular, fontSize: .body),
            NSAttributedString.Key.foregroundColor: UIColor.Asset.lightBlue
        ], for: .normal)
        var configureUserImage = TLPhotosPickerConfigure()
        configureUserImage.numberOfColumn = 3
        configureUserImage.singleSelectedMode = true
        configureUserImage.mediaType = .image
        configureUserImage.usedCameraButton = false
        configureUserImage.allowedLivePhotos = false
        configureUserImage.allowedPhotograph = false
        configureUserImage.allowedVideo = false
        configureUserImage.autoPlay = false
        configureUserImage.allowedVideoRecording = false
        configureUserImage.selectedColor = UIColor.Asset.lightBlue
        photosPickerUserImageViewController.configure = configureUserImage
        Utility.currentViewController().present(photosPickerUserImageViewController, animated: true, completion: nil)
    }

    private func selectTakePhotoUserImage() {
        self.showCameraIfAuthorizedUserImage()
    }

    private func showCameraIfAuthorizedUserImage() {
        let cameraAuthorization = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraAuthorization {
        case .authorized:
            self.showCameraUserImage()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { [weak self] (authorized) in
                DispatchQueue.main.async { [weak self] in
                    if authorized {
                        self?.showCameraUserImage()
                    } else {
                        self?.handleDeniedCameraAuthorizationUserImage()
                    }
                }
            })
        case .restricted, .denied:
            self.handleDeniedCameraAuthorizationUserImage()
        @unknown default:
            break
        }
    }

    private func showCameraUserImage() {
        let pickerUserImage = UIImagePickerController()
        pickerUserImage.sourceType = .camera
        var mediaTypes: [String] = []
        mediaTypes.append(kUTTypeImage as String)
        guard mediaTypes.count > 0 else {
            return
        }
        pickerUserImage.cameraDevice = .rear
        pickerUserImage.mediaTypes = mediaTypes
        pickerUserImage.allowsEditing = false
        pickerUserImage.delegate = self
        Utility.currentViewController().present(pickerUserImage, animated: true, completion: nil)
    }

    private func handleDeniedCameraAuthorizationUserImage() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: "Denied camera permissions granted", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            Utility.currentViewController().present(alert, animated: true, completion: nil)
        }
    }

    private func presentCropViewControllerUserImage(image: UIImage, updateImageType: UpdateImageType) {
        if updateImageType == .avatar {
            let cropUserImageController = TOCropViewController(croppingStyle: .circular, image: image)
            cropUserImageController.delegate = self
            Utility.currentViewController().present(cropUserImageController, animated: true, completion: nil)
        } else {
            let cropUserImageController = TOCropViewController(croppingStyle: .default, image: image)
            cropUserImageController.aspectRatioPreset = .preset4x3
            cropUserImageController.aspectRatioLockEnabled = true
            cropUserImageController.resetAspectRatioEnabled = false
            cropUserImageController.aspectRatioPickerButtonHidden = true
            cropUserImageController.delegate = self
            Utility.currentViewController().present(cropUserImageController, animated: true, completion: nil)
        }
    }
}

extension UpdateUserImageTableViewCell: UpdateUserInfoViewModelDelegate {
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
        if let asset = withTLPHAssets.first, let image = asset.fullResolutionImage {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if self.updateImageType == .avatar {
                    self.presentCropViewControllerUserImage(image: image, updateImageType: .avatar)
                } else if self.updateImageType == .cover {
                    self.presentCropViewControllerUserImage(image: image, updateImageType: .cover)
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
                self.presentCropViewControllerUserImage(image: image, updateImageType: .avatar)
            } else if self.updateImageType == .cover {
                self.presentCropViewControllerUserImage(image: image, updateImageType: .cover)
            }
        })
    }
}

extension UpdateUserImageTableViewCell: TOCropViewControllerDelegate {
    func cropViewController(_ cropViewController: TOCropViewController, didCropToCircularImage image: UIImage, with cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true, completion: {
            if self.updateImageType == .avatar {
                let avatarUserImageCropImage = image.resizeImage(targetSize: CGSize.init(width: 200, height: 200))
                self.profileImage.image = avatarUserImageCropImage
                self.viewModel.avatar = avatarUserImageCropImage
            }
        })
    }

    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true, completion: {
            if self.updateImageType == .cover {
                let coverUserImageCropImage = image.resizeImage(targetSize: CGSize.init(width: 640, height: 480))
                self.coverImage.image = coverUserImageCropImage
                self.viewModel.cover = coverUserImageCropImage
            }
        })
    }
}
