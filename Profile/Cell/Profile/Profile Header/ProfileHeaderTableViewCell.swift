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
import Mantis
import Lightbox

protocol ProfileHeaderTableViewCellDelegate: AnyObject {
    func didUpdateProfileSuccess(_ profileHeaderTableViewCell: ProfileHeaderTableViewCell)
    func didAuthen(_ profileHeaderTableViewCell: ProfileHeaderTableViewCell)
    func didBlocked(_ profileHeaderTableViewCell: ProfileHeaderTableViewCell)
    func didFollow(_ profileHeaderTableViewCell: ProfileHeaderTableViewCell, followed: Bool)
}

class ProfileHeaderTableViewCell: UITableViewCell {

    @IBOutlet var userCoverImage: UIImageView!
    @IBOutlet var userAvatarImage: UIImageView!
    @IBOutlet var editUserCoverButton: UIButton!
    @IBOutlet var moreButton: UIButton!
    @IBOutlet var editUserAvatarButton: UIButton!
    @IBOutlet var userDisplayNameLabel: UILabel!
    @IBOutlet var userCastcleIdLabel: UILabel!
    @IBOutlet var userBioLabel: UILabel!
    @IBOutlet var editUserProfileButton: UIButton!
    @IBOutlet var viewUserProfileButton: UIButton!
    @IBOutlet var userFollowButton: UIButton!
    @IBOutlet var userFollowLabel: ActiveLabel!
    @IBOutlet var userCoverLoadView: UIView!
    @IBOutlet var userCoverBackgroundView: UIView!
    @IBOutlet var userCoverIndicator: NVActivityIndicatorView!
    @IBOutlet var userUploadCoverLabel: UILabel!
    @IBOutlet var userAvatarLoadView: UIView!
    @IBOutlet var userAvatarBackgroundView: UIView!
    @IBOutlet var userAvatarIndicator: NVActivityIndicatorView!

    public var delegate: ProfileHeaderTableViewCellDelegate?
    private var viewModel = ProfileHeaderViewModel(profileType: .unknow, userInfo: UserInfo())
    private let editProfileViewModel = EditProfileViewModel()
    private var updateImageType: UpdateImageType = .none

    override func awakeFromNib() {
        super.awakeFromNib()
        self.userDisplayNameLabel.font = UIFont.asset(.regular, fontSize: .head4)
        self.userDisplayNameLabel.textColor = UIColor.Asset.white
        self.userCastcleIdLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.userCastcleIdLabel.textColor = UIColor.Asset.gray
        self.userBioLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.userBioLabel.textColor = UIColor.Asset.white
        self.userUploadCoverLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.userUploadCoverLabel.textColor = UIColor.Asset.white
        self.userAvatarImage.circle(color: UIColor.Asset.white)
        self.userAvatarLoadView.capsule(borderWidth: 2.0, borderColor: UIColor.Asset.white)
        self.editUserAvatarButton.setImage(UIImage.init(icon: .castcle(.camera), size: CGSize(width: 15, height: 15), textColor: UIColor.Asset.darkGraphiteBlue).withRenderingMode(.alwaysOriginal), for: .normal)
        self.editUserAvatarButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
        self.editUserAvatarButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.Asset.darkGraphiteBlue)
        self.moreButton.setImage(UIImage.init(icon: .castcle(.ellipsisV), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.gray).withRenderingMode(.alwaysOriginal), for: .normal)
        self.moreButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.Asset.gray)
        self.editUserCoverButton.setImage(UIImage.init(icon: .castcle(.camera), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        self.editUserCoverButton.setBackgroundImage(UIColor.Asset.gray.toImage(), for: .normal)
        self.editUserCoverButton.capsule()
        self.editUserProfileButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .overline)
        self.editUserProfileButton.setTitleColor(UIColor.Asset.lightBlue, for: .normal)
        self.editUserProfileButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.Asset.lightBlue)
        self.viewUserProfileButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .overline)
        self.viewUserProfileButton.setTitleColor(UIColor.Asset.lightBlue, for: .normal)
        self.viewUserProfileButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.Asset.lightBlue)
        self.userCoverBackgroundView.backgroundColor = UIColor.Asset.cellBackground
        self.userAvatarBackgroundView.backgroundColor = UIColor.Asset.cellBackground
        self.userCoverLoadView.isHidden = true
        self.userAvatarLoadView.isHidden = true
        self.userCoverIndicator.type = .ballBeat
        self.userAvatarIndicator.type = .ballBeat
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
            self.selectImageSourceProfileHeader()
        }
    }

    @IBAction func editProfileImageAction(_ sender: Any) {
        if self.viewModel.profileType == .mine {
            self.updateImageType = .avatar
            self.selectImageSourceProfileHeader()
        }
    }

    @IBAction func moreAction(_ sender: Any) {
        if self.viewModel.profileType == .mine {
            let castcleId: String = UserManager.shared.castcleId
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
            let reportUserButton = CCAction(title: "Report \(castcleId)", image: UIImage.init(icon: .castcle(.report), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white), style: .normal) {
                actionSheet.dismissActionSheet()
                if UserManager.shared.isLogin {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        let reportDict: [String: Any] = [
                            JsonKey.castcleId.rawValue: castcleId,
                            JsonKey.contentId.rawValue: ""
                        ]
                        NotificationCenter.default.post(name: .openReportDelegate, object: nil, userInfo: reportDict)
                    }
                } else {
                    self.delegate?.didAuthen(self)
                }
            }
            let blockUserButton = CCAction(title: "Block \(castcleId)", image: UIImage.init(icon: .castcle(.block), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white), style: .normal) {
                actionSheet.dismissActionSheet()
                if UserManager.shared.isLogin {
                    self.viewModel.blockUser(castcleId: castcleId)
                } else {
                    self.delegate?.didAuthen(self)
                }
            }
            actionSheet.addActions([blockUserButton, reportUserButton])
            Utility.currentViewController().present(actionSheet, animated: true, completion: nil)
        }
    }

    @IBAction func editUserProfileAction(_ sender: Any) {
        if self.viewModel.profileType == .mine {
            let viewController = ProfileOpener.open(.editInfo(self.viewModel.profileType, self.viewModel.userInfo)) as? EditInfoViewController
            viewController?.delegate = self
            Utility.currentViewController().navigationController?.pushViewController(viewController ?? EditInfoViewController(), animated: true)
        }
    }

    @IBAction func viewUserProfileAction(_ sender: Any) {
        Utility.currentViewController().navigationController?.pushViewController(ProfileOpener.open(.userInfo(UserInfoViewModel(userInfo: self.viewModel.userInfo))), animated: true)
    }

    @IBAction func userFollowAction(_ sender: Any) {
        if UserManager.shared.isLogin {
            if self.viewModel.isFollow {
                self.viewModel.unfollowUser()
            } else {
                self.viewModel.followUser()
            }
            self.viewModel.isFollow.toggle()
            UserHelper.shared.updateIsFollowAuthorRef(userId: self.viewModel.userInfo.id, isFollow: self.viewModel.isFollow)
            self.followUI()
            self.delegate?.didFollow(self, followed: self.viewModel.isFollow)
        } else {
            self.delegate?.didAuthen(self)
        }
    }

    @IBAction func viewCoverAction(_ sender: Any) {
        if self.viewModel.profileType == .mine {
            self.displayUserImage(imageUrl: UserManager.shared.coverFullHd)
        } else {
            self.displayUserImage(imageUrl: self.viewModel.userInfo.images.cover.fullHd)
        }
    }

    @IBAction func viewAvatarAction(_ sender: Any) {
        if self.viewModel.profileType == .mine {
            self.displayUserImage(imageUrl: UserManager.shared.avatarFullHd)
        } else {
            self.displayUserImage(imageUrl: self.viewModel.userInfo.images.avatar.fullHd)
        }
    }
}

extension ProfileHeaderTableViewCell {
    private func displayUserImage(imageUrl: String) {
        let images = [
            LightboxImage(imageURL: URL(string: imageUrl)!)
        ]
        LightboxConfig.CloseButton.textAttributes = [
            .font: UIFont.asset(.bold, fontSize: .body),
            .foregroundColor: UIColor.Asset.white
          ]
        LightboxConfig.CloseButton.text = "Close"
        let controller = LightboxController(images: images)
        controller.pageDelegate = self
        controller.dismissalDelegate = self
        controller.dynamicBackground = true
        controller.footerView.isHidden = true
        Utility.currentViewController().present(controller, animated: true, completion: nil)
    }

    private func updateProfileUI() {
        if self.viewModel.profileType == .mine {
            if let avatar = self.editProfileViewModel.avatar {
                self.userAvatarImage.image = avatar
            } else {
                let url = URL(string: UserManager.shared.avatar)
                self.userAvatarImage.kf.setImage(with: url, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
            }

            if let cover = self.editProfileViewModel.cover {
                self.userCoverImage.image = cover
            } else {
                let url = URL(string: UserManager.shared.cover)
                self.userCoverImage.kf.setImage(with: url, placeholder: UIImage.Asset.placeholder, options: [.transition(.fade(0.35))])
            }

            self.userDisplayNameLabel.text = UserManager.shared.displayName
            self.userCastcleIdLabel.text = UserManager.shared.castcleId
            self.userFollowLabel.customize { label in
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
                    Utility.currentViewController().navigationController?.pushViewController(ProfileOpener.open(.userFollow(UserFollowViewModel(followType: .following, castcleId: UserManager.shared.castcleId))), animated: true)
                }

                label.handleCustomTap(for: followerType) { _ in
                    Utility.currentViewController().navigationController?.pushViewController(ProfileOpener.open(.userFollow(UserFollowViewModel(followType: .follower, castcleId: UserManager.shared.castcleId))), animated: true)
                }
            }
            self.userFollowLabel.text = "\(UserManager.shared.following) Following   \(UserManager.shared.followers) Followers"
            self.userBioLabel.text = UserManager.shared.overview
            self.editUserProfileButton.setTitle("Edit Profile", for: .normal)

            // MARK: - Hide and show button
            self.editUserCoverButton.isHidden = false
            self.editUserProfileButton.isHidden = false
            self.editUserAvatarButton.isHidden = false
            self.viewUserProfileButton.isHidden = true
            self.userFollowButton.isHidden = true
        } else {
            let urlProfile = URL(string: self.viewModel.userInfo.images.avatar.thumbnail)
            let urlCover = URL(string: self.viewModel.userInfo.images.cover.fullHd)
            self.userAvatarImage.kf.setImage(with: urlProfile, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
            self.userCoverImage.kf.setImage(with: urlCover, placeholder: UIImage.Asset.placeholder, options: [.transition(.fade(0.35))])
            self.userDisplayNameLabel.text = self.viewModel.userInfo.displayName
            self.userCastcleIdLabel.text = self.viewModel.userInfo.castcleId
            self.userFollowLabel.customize { label in
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
            self.userFollowLabel.text = "\(self.viewModel.userInfo.following.count) Following   \(self.viewModel.userInfo.followers.count) Followers"
            self.userBioLabel.text = self.viewModel.userInfo.overview
            self.viewUserProfileButton.setTitle("View Profile", for: .normal)

            // MARK: - Hide and show button
            self.editUserCoverButton.isHidden = true
            self.editUserProfileButton.isHidden = true
            self.editUserAvatarButton.isHidden = true
            self.viewUserProfileButton.isHidden = false
            self.userFollowButton.isHidden = false
        }
    }

    private func followUI() {
        if self.viewModel.isFollow {
            self.userFollowButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .overline)
            self.userFollowButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
            self.userFollowButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.Asset.lightBlue)
            self.userFollowButton.setIcon(prefixText: "Following  ", prefixTextColor: UIColor.Asset.white, icon: .castcle(.checkmark), iconColor: UIColor.Asset.white, postfixText: "", postfixTextColor: UIColor.Asset.white, forState: .normal, textSize: 14, iconSize: 14)
        } else {
            self.userFollowButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .overline)
            self.userFollowButton.setBackgroundImage(UIColor.Asset.cellBackground.toImage(), for: .normal)
            self.userFollowButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.Asset.lightBlue)
            self.userFollowButton.setIcon(prefixText: "     Follow     ", prefixTextColor: UIColor.Asset.lightBlue, icon: .castcle(.checkmark), iconColor: UIColor.Asset.cellBackground, postfixText: "", postfixTextColor: UIColor.Asset.white, forState: .normal, textSize: 14, iconSize: 0)
        }
    }

    private func selectImageSourceProfileHeader() {
        let actionSheet = CCActionSheet()
        let albumButton = CCAction(title: "Choose from Camera Roll", image: UIImage.init(icon: .castcle(.image), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white), style: .normal) {
            actionSheet.dismissActionSheet()
            self.selectCameraRollProfileHeader()
        }
        let cameraButton = CCAction(title: "Take Photo", image: UIImage.init(icon: .castcle(.camera), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white), style: .normal) {
            actionSheet.dismissActionSheet()
            self.selectTakePhotoProfileHeader()
        }
        actionSheet.addActions([albumButton, cameraButton])
        Utility.currentViewController().present(actionSheet, animated: true, completion: nil)
    }

    private func selectCameraRollProfileHeader() {
        let photosPickerProfileHeaderViewController = TLPhotosPickerViewController()
        photosPickerProfileHeaderViewController.delegate = self
        photosPickerProfileHeaderViewController.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        photosPickerProfileHeaderViewController.collectionView.backgroundColor = UIColor.clear
        photosPickerProfileHeaderViewController.navigationBar.barTintColor = UIColor.Asset.darkGraphiteBlue
        photosPickerProfileHeaderViewController.navigationBar.isTranslucent = false
        photosPickerProfileHeaderViewController.titleLabel.font = UIFont.asset(.regular, fontSize: .overline)
        photosPickerProfileHeaderViewController.subTitleLabel.font = UIFont.asset(.regular, fontSize: .small)
        photosPickerProfileHeaderViewController.doneButton.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.asset(.bold, fontSize: .head4),
            NSAttributedString.Key.foregroundColor: UIColor.Asset.lightBlue
        ], for: .normal)
        photosPickerProfileHeaderViewController.cancelButton.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.asset(.regular, fontSize: .body),
            NSAttributedString.Key.foregroundColor: UIColor.Asset.lightBlue
        ], for: .normal)

        var configureProfileHeader = TLPhotosPickerConfigure()
        configureProfileHeader.numberOfColumn = 3
        configureProfileHeader.singleSelectedMode = true
        configureProfileHeader.mediaType = .image
        configureProfileHeader.usedCameraButton = false
        configureProfileHeader.allowedLivePhotos = false
        configureProfileHeader.allowedPhotograph = false
        configureProfileHeader.allowedVideo = false
        configureProfileHeader.autoPlay = false
        configureProfileHeader.allowedVideoRecording = false
        configureProfileHeader.selectedColor = UIColor.Asset.lightBlue
        photosPickerProfileHeaderViewController.configure = configureProfileHeader
        Utility.currentViewController().present(photosPickerProfileHeaderViewController, animated: true, completion: nil)
    }

    private func selectTakePhotoProfileHeader() {
        self.showCameraIfAuthorizedProfileHeader()
    }

    private func showCameraIfAuthorizedProfileHeader() {
        let cameraAuthorization = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraAuthorization {
        case .authorized:
            self.showCameraProfileHeader()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { [weak self] (authorized) in
                DispatchQueue.main.async { [weak self] in
                    if authorized {
                        self?.showCameraProfileHeader()
                    } else {
                        self?.handleDeniedCameraAuthorizationProfileHeader()
                    }
                }
            })
        case .restricted, .denied:
            self.handleDeniedCameraAuthorizationProfileHeader()
        @unknown default:
            break
        }
    }

    private func showCameraProfileHeader() {
        let pickerProfileHeader = UIImagePickerController()
        pickerProfileHeader.sourceType = .camera
        var mediaTypes: [String] = []
        mediaTypes.append(kUTTypeImage as String)
        guard mediaTypes.count > 0 else {
            return
        }
        pickerProfileHeader.cameraDevice = .rear
        pickerProfileHeader.mediaTypes = mediaTypes
        pickerProfileHeader.allowsEditing = false
        pickerProfileHeader.delegate = self
        Utility.currentViewController().present(pickerProfileHeader, animated: true, completion: nil)
    }

    private func handleDeniedCameraAuthorizationProfileHeader() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: "Denied camera permissions granted", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            Utility.currentViewController().present(alert, animated: true, completion: nil)
        }
    }

    private func presentCropViewControllerProfileHeader(image: UIImage, updateImageType: UpdateImageType) {
        if updateImageType == .avatar {
            var config = Mantis.Config()
            config.cropViewConfig.cropShapeType = .circle(maskOnly: true)
            let cropViewController = Mantis.cropViewController(image: image, config: config)
            cropViewController.delegate = self
            cropViewController.modalPresentationStyle = .fullScreen
            Utility.currentViewController().present(cropViewController, animated: true)
        } else {
            let cropProfileHeaderController = TOCropViewController(croppingStyle: .default, image: image)
            cropProfileHeaderController.aspectRatioPreset = .preset16x9
            cropProfileHeaderController.aspectRatioLockEnabled = true
            cropProfileHeaderController.resetAspectRatioEnabled = false
            cropProfileHeaderController.aspectRatioPickerButtonHidden = true
            cropProfileHeaderController.delegate = self
            Utility.currentViewController().present(cropProfileHeaderController, animated: true, completion: nil)
        }
    }
}

extension ProfileHeaderTableViewCell: TLPhotosPickerViewControllerDelegate {
    func shouldDismissPhotoPicker(withTLPHAssets: [TLPHAsset]) -> Bool {
        if let asset = withTLPHAssets.first, let image = asset.fullResolutionImage {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if self.updateImageType == .avatar {
                    self.presentCropViewControllerProfileHeader(image: image, updateImageType: .avatar)
                } else if self.updateImageType == .cover {
                    self.presentCropViewControllerProfileHeader(image: image, updateImageType: .cover)
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
                self.presentCropViewControllerProfileHeader(image: image, updateImageType: .avatar)
            } else if self.updateImageType == .cover {
                self.presentCropViewControllerProfileHeader(image: image, updateImageType: .cover)
            }
        })
    }
}

extension ProfileHeaderTableViewCell: TOCropViewControllerDelegate {
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true, completion: {
            if self.updateImageType == .cover {
                let coverCropImage = image.resizeImage(targetSize: CGSize.init(width: 640, height: 360))
                self.userCoverImage.image = coverCropImage
                self.editProfileViewModel.cover = coverCropImage
                self.userCoverLoadView.isHidden = false
                self.userCoverIndicator.startAnimating()
                self.editProfileViewModel.updateCover(isPage: false, castcleId: UserManager.shared.castcleId)
            }
        })
    }
}

extension ProfileHeaderTableViewCell: CropViewControllerDelegate {
    func cropViewControllerDidCrop(_ cropViewController: Mantis.CropViewController, cropped: UIImage, transformation: Mantis.Transformation, cropInfo: Mantis.CropInfo) {
        cropViewController.dismiss(animated: true, completion: {
            if self.updateImageType == .avatar {
                let avatarCropImage = cropped.resizeImage(targetSize: CGSize.init(width: 200, height: 200))
                self.userAvatarImage.image = avatarCropImage
                self.editProfileViewModel.avatar = avatarCropImage
                self.userAvatarLoadView.isHidden = false
                self.userAvatarIndicator.startAnimating()
                self.editProfileViewModel.updateAvatar(isPage: false, castcleId: UserManager.shared.castcleId)
            }
        })
    }

    func cropViewControllerDidCancel(_ cropViewController: Mantis.CropViewController, original: UIImage) {
        cropViewController.dismiss(animated: true)
    }

    func cropViewControllerDidFailToCrop(_ cropViewController: Mantis.CropViewController, original: UIImage) {}
    func cropViewControllerDidBeginResize(_ cropViewController: Mantis.CropViewController) {}
    func cropViewControllerDidEndResize(_ cropViewController: Mantis.CropViewController, original: UIImage, cropInfo: Mantis.CropInfo) {}
}

extension ProfileHeaderTableViewCell: EditProfileViewModelDelegate {
    func didUpdateInfoFinish(success: Bool) {
        if success {
            self.userAvatarLoadView.isHidden = true
            self.userCoverLoadView.isHidden = true
            self.userAvatarIndicator.stopAnimating()
            self.userCoverIndicator.stopAnimating()
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

extension ProfileHeaderTableViewCell: LightboxControllerPageDelegate {
    public func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
        // MARK: - Lightbox Move Page
    }
}

extension ProfileHeaderTableViewCell: LightboxControllerDismissalDelegate {
    public func lightboxControllerWillDismiss(_ controller: LightboxController) {
        // MARK: - Lightbox Dismiss
    }
}

extension ProfileHeaderTableViewCell: EditInfoViewControllerDelegate {
    func didUpdateInfo(_ view: EditInfoViewController, userInfo: UserInfo) {
        self.viewModel.userInfo = userInfo
        self.updateProfileUI()
    }
}
