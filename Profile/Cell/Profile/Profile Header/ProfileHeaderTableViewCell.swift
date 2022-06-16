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
//  ProfileHeaderTableViewCell.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 3/1/2565 BE.
//

import UIKit
import Photos
import MobileCoreServices
import Core
import Component
import Networking
import NVActivityIndicatorView
import ActiveLabel
import TLPhotoPicker
import TOCropViewController

protocol ProfileHeaderTableViewCellDelegate: AnyObject {
    func didUpdateProfileSuccess(_ profileHeaderTableViewCell: ProfileHeaderTableViewCell)
    func didAuthen(_ profileHeaderTableViewCell: ProfileHeaderTableViewCell)
    func didBlocked(_ profileHeaderTableViewCell: ProfileHeaderTableViewCell)
}

class ProfileHeaderTableViewCell: UITableViewCell {

    @IBOutlet var coverImage: UIImageView!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var editCoverButton: UIButton!
    @IBOutlet var moreButton: UIButton!
    @IBOutlet var editProfileImageButton: UIButton!
    @IBOutlet var displayNameLabel: UILabel!
    @IBOutlet var userIdLabel: UILabel!
    @IBOutlet var bioLabel: UILabel!
    @IBOutlet var editProfileButton: UIButton!
    @IBOutlet var viewProfileButton: UIButton!
    @IBOutlet var followButton: UIButton!
    @IBOutlet var followLabel: ActiveLabel!
    @IBOutlet var coverLoadView: UIView!
    @IBOutlet var coverBackgroundView: UIView!
    @IBOutlet var coverIndicator: NVActivityIndicatorView!
    @IBOutlet var uploadCoverLabel: UILabel!
    @IBOutlet var avatarLoadView: UIView!
    @IBOutlet var avatarBackgroundView: UIView!
    @IBOutlet var avatarIndicator: NVActivityIndicatorView!

    public var delegate: ProfileHeaderTableViewCellDelegate?
    private var viewModel = ProfileHeaderViewModel(profileType: .unknow, userInfo: UserInfo())
    private let editProfileViewModel = EditProfileViewModel()
    private var updateImageType: UpdateImageType = .none

    override func awakeFromNib() {
        super.awakeFromNib()
        self.displayNameLabel.font = UIFont.asset(.regular, fontSize: .head4)
        self.displayNameLabel.textColor = UIColor.Asset.white
        self.userIdLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.userIdLabel.textColor = UIColor.Asset.gray
        self.bioLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.bioLabel.textColor = UIColor.Asset.white
        self.uploadCoverLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.uploadCoverLabel.textColor = UIColor.Asset.white
        self.profileImage.circle(color: UIColor.Asset.white)
        self.avatarLoadView.capsule(borderWidth: 2.0, borderColor: UIColor.Asset.white)
        self.editProfileImageButton.setImage(UIImage.init(icon: .castcle(.camera), size: CGSize(width: 15, height: 15), textColor: UIColor.Asset.darkGraphiteBlue).withRenderingMode(.alwaysOriginal), for: .normal)
        self.editProfileImageButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
        self.editProfileImageButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.Asset.darkGraphiteBlue)
        self.moreButton.setImage(UIImage.init(icon: .castcle(.ellipsisV), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.gray).withRenderingMode(.alwaysOriginal), for: .normal)
        self.moreButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.Asset.gray)
        self.editCoverButton.setImage(UIImage.init(icon: .castcle(.camera), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        self.editCoverButton.setBackgroundImage(UIColor.Asset.gray.toImage(), for: .normal)
        self.editCoverButton.capsule()
        self.editProfileButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .overline)
        self.editProfileButton.setTitleColor(UIColor.Asset.lightBlue, for: .normal)
        self.editProfileButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.Asset.lightBlue)
        self.viewProfileButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .overline)
        self.viewProfileButton.setTitleColor(UIColor.Asset.lightBlue, for: .normal)
        self.viewProfileButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.Asset.lightBlue)
        self.coverBackgroundView.backgroundColor = UIColor.Asset.darkGray
        self.avatarBackgroundView.backgroundColor = UIColor.Asset.darkGray
        self.coverLoadView.isHidden = true
        self.avatarLoadView.isHidden = true
        self.coverIndicator.type = .ballBeat
        self.avatarIndicator.type = .ballBeat
        self.editProfileViewModel.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configCell(viewModel: ProfileHeaderViewModel) {
        self.viewModel = viewModel
        self.updateProfileUI()
        self.viewModel.delegate = self
        self.followUI()
    }

    @IBAction func editCoverAction(_ sender: Any) {
        if self.viewModel.profileType == .mine {
            self.updateImageType = .cover
            self.selectImageSource()
        }
    }

    @IBAction func editProfileImageAction(_ sender: Any) {
        if self.viewModel.profileType == .mine {
            self.updateImageType = .avatar
            self.selectImageSource()
        }
    }

    @IBAction func moreAction(_ sender: Any) {
        if self.viewModel.profileType == .mine {
            let castcleId: String = UserManager.shared.rawCastcleId
            let actionSheet = CCActionSheet()
            let syncButton = CCAction(title: "Sync social media", image: UIImage.init(icon: .castcle(.bindLink), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white), style: .normal) {
                actionSheet.dismissActionSheet()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    Utility.currentViewController().navigationController?.pushViewController(ProfileOpener.open(.syncSocialMedia(SyncSocialMediaViewModel(castcleId: castcleId))), animated: true)
                }
            }
            actionSheet.addActions([syncButton])
            Utility.currentViewController().present(actionSheet, animated: true, completion: nil)
        } else {
            let actionSheet = CCActionSheet()
            let castcleId: String = self.viewModel.userInfo.castcleId
            let reportButton = CCAction(title: "Report @\(castcleId)", image: UIImage.init(icon: .castcle(.report), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white), style: .normal) {
                actionSheet.dismissActionSheet()
                if UserManager.shared.isLogin {
                    self.viewModel.reportUser(castcleId: castcleId)
                } else {
                    self.delegate?.didAuthen(self)
                }
            }
            let blockButton = CCAction(title: "Block @\(castcleId)", image: UIImage.init(icon: .castcle(.block), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white), style: .normal) {
                actionSheet.dismissActionSheet()
                if UserManager.shared.isLogin {
                    self.viewModel.blockUser(castcleId: castcleId)
                } else {
                    self.delegate?.didAuthen(self)
                }
            }
            actionSheet.addActions([blockButton, reportButton])
            Utility.currentViewController().present(actionSheet, animated: true, completion: nil)
        }
    }

    @IBAction func editProfileAction(_ sender: Any) {
        if self.viewModel.profileType == .mine {
            Utility.currentViewController().navigationController?.pushViewController(ProfileOpener.open(.editInfo(self.viewModel.profileType, self.viewModel.userInfo)), animated: true)
        }
    }

    @IBAction func viewProfileAction(_ sender: Any) {
        Utility.currentViewController().navigationController?.pushViewController(ProfileOpener.open(.userInfo(UserInfoViewModel(userInfo: self.viewModel.userInfo))), animated: true)
    }

    @IBAction func followAction(_ sender: Any) {
        if UserManager.shared.isLogin {
            if self.viewModel.isFollow {
                self.viewModel.unfollowUser()
            } else {
                self.viewModel.followUser()
            }
            self.viewModel.isFollow.toggle()
            self.followUI()
        } else {
            self.delegate?.didAuthen(self)
        }
    }
}

extension ProfileHeaderTableViewCell {
    private func updateProfileUI() {
        if self.viewModel.profileType == .mine {
            if let avatar = self.editProfileViewModel.avatar {
                self.profileImage.image = avatar
            } else {
                let url = URL(string: UserManager.shared.avatar)
                self.profileImage.kf.setImage(with: url, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
            }

            if let cover = self.editProfileViewModel.cover {
                self.coverImage.image = cover
            } else {
                let url = URL(string: UserManager.shared.cover)
                self.coverImage.kf.setImage(with: url, placeholder: UIImage.Asset.placeholder, options: [.transition(.fade(0.35))])
            }

            self.displayNameLabel.text = UserManager.shared.displayName
            self.userIdLabel.text = UserManager.shared.castcleId
            self.followLabel.customize { label in
                label.font = UIFont.asset(.regular, fontSize: .body)
                label.numberOfLines = 1
                label.textColor = UIColor.Asset.gray

                let followingType = ActiveType.custom(pattern: "\(UserManager.shared.following) Following")
                let followerType = ActiveType.custom(pattern: "\(UserManager.shared.followers) Followers")

                label.enabledTypes = [followingType, followerType]
                label.customColor[followingType] = UIColor.Asset.white
                label.customSelectedColor[followingType] = UIColor.Asset.gray
                label.customColor[followerType] = UIColor.Asset.white
                label.customSelectedColor[followerType] = UIColor.Asset.gray

                label.handleCustomTap(for: followingType) { _ in
                    Utility.currentViewController().navigationController?.pushViewController(ProfileOpener.open(.userFollow(UserFollowViewModel(followType: .following, castcleId: UserManager.shared.rawCastcleId))), animated: true)
                }

                label.handleCustomTap(for: followerType) { _ in
                    Utility.currentViewController().navigationController?.pushViewController(ProfileOpener.open(.userFollow(UserFollowViewModel(followType: .follower, castcleId: UserManager.shared.rawCastcleId))), animated: true)
                }
            }
            self.followLabel.text = "\(UserManager.shared.following) Following   \(UserManager.shared.followers) Followers"
            self.bioLabel.text = UserManager.shared.overview
            self.editProfileButton.setTitle("Edit Profile", for: .normal)

            // MARK: - Hide and show button
            self.editCoverButton.isHidden = false
            self.editProfileButton.isHidden = false
            self.editProfileImageButton.isHidden = false
            self.viewProfileButton.isHidden = true
            self.followButton.isHidden = true
        } else {
            let urlProfile = URL(string: self.viewModel.userInfo.images.avatar.thumbnail)
            let urlCover = URL(string: self.viewModel.userInfo.images.cover.fullHd)
            self.profileImage.kf.setImage(with: urlProfile, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
            self.coverImage.kf.setImage(with: urlCover, placeholder: UIImage.Asset.placeholder, options: [.transition(.fade(0.35))])
            self.displayNameLabel.text = self.viewModel.userInfo.displayName
            self.userIdLabel.text = "@\(self.viewModel.userInfo.castcleId)"
            self.followLabel.customize { label in
                label.font = UIFont.asset(.regular, fontSize: .body)
                label.numberOfLines = 1
                label.textColor = UIColor.Asset.gray
                let followingType = ActiveType.custom(pattern: "\(self.viewModel.userInfo.following.count) Following")
                let followerType = ActiveType.custom(pattern: "\(self.viewModel.userInfo.followers.count) Followers")
                label.enabledTypes = [followingType, followerType]
                label.customColor[followingType] = UIColor.Asset.white
                label.customSelectedColor[followingType] = UIColor.Asset.gray
                label.customColor[followerType] = UIColor.Asset.white
                label.customSelectedColor[followerType] = UIColor.Asset.gray
                label.handleCustomTap(for: followingType) { _ in
                    Utility.currentViewController().navigationController?.pushViewController(ProfileOpener.open(.userFollow(UserFollowViewModel(followType: .following, castcleId: self.viewModel.userInfo.castcleId))), animated: true)
                }
                label.handleCustomTap(for: followerType) { _ in
                    Utility.currentViewController().navigationController?.pushViewController(ProfileOpener.open(.userFollow(UserFollowViewModel(followType: .follower, castcleId: self.viewModel.userInfo.castcleId))), animated: true)
                }
            }
            self.followLabel.text = "\(self.viewModel.userInfo.following.count) Following   \(self.viewModel.userInfo.followers.count) Followers"
            self.bioLabel.text = self.viewModel.userInfo.overview
            self.viewProfileButton.setTitle("View Profile", for: .normal)

            // MARK: - Hide and show button
            self.editCoverButton.isHidden = true
            self.editProfileButton.isHidden = true
            self.editProfileImageButton.isHidden = true
            self.viewProfileButton.isHidden = false
            self.followButton.isHidden = false
        }
    }

    private func followUI() {
        if self.viewModel.isFollow {
            self.followButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .overline)
            self.followButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
            self.followButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.Asset.lightBlue)
            self.followButton.setIcon(prefixText: "Following  ", prefixTextColor: UIColor.Asset.white, icon: .castcle(.checkmark), iconColor: UIColor.Asset.white, postfixText: "", postfixTextColor: UIColor.Asset.white, forState: .normal, textSize: 14, iconSize: 14)
        } else {
            self.followButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .overline)
            self.followButton.setBackgroundImage(UIColor.Asset.darkGray.toImage(), for: .normal)
            self.followButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.Asset.lightBlue)
            self.followButton.setIcon(prefixText: "     Follow     ", prefixTextColor: UIColor.Asset.lightBlue, icon: .castcle(.checkmark), iconColor: UIColor.Asset.darkGray, postfixText: "", postfixTextColor: UIColor.Asset.white, forState: .normal, textSize: 14, iconSize: 0)
        }
    }

    private func selectImageSource() {
        let actionSheet = CCActionSheet()
        let albumButton = CCAction(title: "Choose from Camera Roll", image: UIImage.init(icon: .castcle(.image), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white), style: .normal) {
            actionSheet.dismissActionSheet()
            self.selectCameraRoll()
        }
        let cameraButton = CCAction(title: "Take Photo", image: UIImage.init(icon: .castcle(.camera), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white), style: .normal) {
            actionSheet.dismissActionSheet()
            self.selectTakePhoto()
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

extension ProfileHeaderTableViewCell: TLPhotosPickerViewControllerDelegate {
    func shouldDismissPhotoPicker(withTLPHAssets: [TLPHAsset]) -> Bool {
        if let asset = withTLPHAssets.first, let image = asset.fullResolutionImage {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if self.updateImageType == .avatar {
                    self.presentCropViewController(image: image, updateImageType: .avatar)
                } else if self.updateImageType == .cover {
                    self.presentCropViewController(image: image, updateImageType: .cover)
                }
            }
        }
        return true
    }
}

extension ProfileHeaderTableViewCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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

extension ProfileHeaderTableViewCell: TOCropViewControllerDelegate {
    func cropViewController(_ cropViewController: TOCropViewController, didCropToCircularImage image: UIImage, with cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true, completion: {
            if self.updateImageType == .avatar {
                let avatarCropImage = image.resizeImage(targetSize: CGSize.init(width: 200, height: 200))
                self.profileImage.image = avatarCropImage
                self.editProfileViewModel.avatar = avatarCropImage
                self.avatarLoadView.isHidden = false
                self.avatarIndicator.startAnimating()
                self.editProfileViewModel.updateAvatar(isPage: false, castcleId: UserManager.shared.rawCastcleId)
            }
        })
    }

    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true, completion: {
            if self.updateImageType == .cover {
                let coverCropImage = image.resizeImage(targetSize: CGSize.init(width: 640, height: 480))
                self.coverImage.image = coverCropImage
                self.editProfileViewModel.cover = coverCropImage
                self.coverLoadView.isHidden = false
                self.coverIndicator.startAnimating()
                self.editProfileViewModel.updateCover(isPage: false, castcleId: UserManager.shared.rawCastcleId)
            }
        })
    }
}

extension ProfileHeaderTableViewCell: EditProfileViewModelDelegate {
    func didUpdateInfoFinish(success: Bool) {
        if success {
            self.avatarLoadView.isHidden = true
            self.coverLoadView.isHidden = true
            self.avatarIndicator.stopAnimating()
            self.coverIndicator.stopAnimating()
            if self.updateImageType == .avatar {
                self.delegate?.didUpdateProfileSuccess(self)
                self.updateImageType = .none
            }
        }
    }
}

extension ProfileHeaderTableViewCell: ProfileHeaderViewModelDelegate {
    func didBlocked() {
        self.delegate?.didBlocked(self)
    }
}
