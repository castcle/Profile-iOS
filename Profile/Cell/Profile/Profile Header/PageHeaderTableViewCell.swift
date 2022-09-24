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
//  PageHeaderTableViewCell.swift
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
import TLPhotoPicker
import TOCropViewController
import Mantis
import Lightbox

protocol PageHeaderTableViewCellDelegate: AnyObject {
    func didUpdateProfileSuccess(_ pageHeaderTableViewCell: PageHeaderTableViewCell)
    func didAuthen(_ pageHeaderTableViewCell: PageHeaderTableViewCell)
    func didBlocked(_ pageHeaderTableViewCell: PageHeaderTableViewCell)
    func didPageUpdateInfo(_ pageHeaderTableViewCell: PageHeaderTableViewCell, userInfo: UserInfo)
    func didFollow(_ pageHeaderTableViewCell: PageHeaderTableViewCell, followed: Bool)
}

class PageHeaderTableViewCell: UITableViewCell {

    @IBOutlet var pageCoverImage: UIImageView!
    @IBOutlet var pageAvatarImage: UIImageView!
    @IBOutlet var editPageCoverButton: UIButton!
    @IBOutlet var moreButton: UIButton!
    @IBOutlet var editPageAvatarButton: UIButton!
    @IBOutlet var pageDisplayNameLabel: UILabel!
    @IBOutlet var pageCastcleIdLabel: UILabel!
    @IBOutlet var pageBioLabel: UILabel!
    @IBOutlet var editPageProfileButton: UIButton!
    @IBOutlet var viewPageProfileButton: UIButton!
    @IBOutlet var pageFollowButton: UIButton!
    @IBOutlet var pageCoverLoadView: UIView!
    @IBOutlet var pageCoverBackgroundView: UIView!
    @IBOutlet var pageCoverIndicator: NVActivityIndicatorView!
    @IBOutlet var pageUploadCoverLabel: UILabel!
    @IBOutlet var pageAvatarLoadView: UIView!
    @IBOutlet var pageAvatarBackgroundView: UIView!
    @IBOutlet var pageAvatarIndicator: NVActivityIndicatorView!
    @IBOutlet var pageFollowerLabel: UILabel!
    @IBOutlet var pageFollowTitleLabel: UILabel!
    @IBOutlet var pageCastLabel: UILabel!
    @IBOutlet var pageCastTitleLabel: UILabel!

    public var delegate: PageHeaderTableViewCellDelegate?
    private var viewModel = ProfileHeaderViewModel(profileType: .unknow, userInfo: UserInfo())
    private let editProfileViewModel = EditProfileViewModel()
    private var updateImageType: UpdateImageType = .none

    override func awakeFromNib() {
        super.awakeFromNib()
        self.pageDisplayNameLabel.font = UIFont.asset(.regular, fontSize: .head4)
        self.pageDisplayNameLabel.textColor = UIColor.Asset.white
        self.pageCastcleIdLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.pageCastcleIdLabel.textColor = UIColor.Asset.gray
        self.pageBioLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.pageBioLabel.textColor = UIColor.Asset.white
        self.pageUploadCoverLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.pageUploadCoverLabel.textColor = UIColor.Asset.white
        self.pageFollowerLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.pageFollowerLabel.textColor = UIColor.Asset.white
        self.pageFollowTitleLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.pageFollowTitleLabel.textColor = UIColor.Asset.white
        self.pageCastLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.pageCastLabel.textColor = UIColor.Asset.white
        self.pageCastTitleLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.pageCastTitleLabel.textColor = UIColor.Asset.white
        self.pageAvatarImage.circle(color: UIColor.Asset.white)
        self.pageAvatarLoadView.capsule(borderWidth: 2.0, borderColor: UIColor.Asset.white)
        self.editPageAvatarButton.setImage(UIImage.init(icon: .castcle(.camera), size: CGSize(width: 15, height: 15), textColor: UIColor.Asset.darkGraphiteBlue).withRenderingMode(.alwaysOriginal), for: .normal)
        self.editPageAvatarButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
        self.editPageAvatarButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.Asset.darkGraphiteBlue)
        self.moreButton.setImage(UIImage.init(icon: .castcle(.ellipsisV), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.gray).withRenderingMode(.alwaysOriginal), for: .normal)
        self.moreButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.Asset.gray)
        self.editPageCoverButton.setImage(UIImage.init(icon: .castcle(.camera), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        self.editPageCoverButton.setBackgroundImage(UIColor.Asset.gray.toImage(), for: .normal)
        self.editPageCoverButton.capsule()
        self.editPageProfileButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .overline)
        self.editPageProfileButton.setTitleColor(UIColor.Asset.lightBlue, for: .normal)
        self.editPageProfileButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.Asset.lightBlue)
        self.viewPageProfileButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .overline)
        self.viewPageProfileButton.setTitleColor(UIColor.Asset.lightBlue, for: .normal)
        self.viewPageProfileButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.Asset.lightBlue)
        self.pageCoverBackgroundView.backgroundColor = UIColor.Asset.cellBackground
        self.pageAvatarBackgroundView.backgroundColor = UIColor.Asset.cellBackground
        self.pageCoverLoadView.isHidden = true
        self.pageAvatarLoadView.isHidden = true
        self.pageCoverIndicator.type = .ballBeat
        self.pageAvatarIndicator.type = .ballBeat
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

    @IBAction func viewFollower(_ sender: Any) {
        Utility.currentViewController().navigationController?.pushViewController(ProfileOpener.open(.userFollow(UserFollowViewModel(followType: .follower, castcleId: self.viewModel.userInfo.castcleId))), animated: true)
    }

    @IBAction func editCoverAction(_ sender: Any) {
        if self.viewModel.isMyPage {
            self.updateImageType = .cover
            self.selectImageSourcePageHeader()
        }
    }

    @IBAction func editProfileImageAction(_ sender: Any) {
        if self.viewModel.isMyPage {
            self.updateImageType = .avatar
            self.selectImageSourcePageHeader()
        }
    }

    @IBAction func moreAction(_ sender: Any) {
        if self.viewModel.isMyPage {
            let castcleId: String = self.viewModel.userInfo.castcleId
            let actionSheet = CCActionSheet()
            let deleteButton = CCAction(title: "Delete page", image: UIImage.init(icon: .castcle(.deleteOne), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white), style: .normal) {
                actionSheet.dismissActionSheet()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    Utility.currentViewController().navigationController?.pushViewController(ProfileOpener.open(.deletePage(DeletePageViewModel(userInfo: self.viewModel.userInfo))), animated: true)
                }
            }
            let syncButton = CCAction(title: "Sync social media", image: UIImage.init(icon: .castcle(.bindLink), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white), style: .normal) {
                actionSheet.dismissActionSheet()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    Utility.currentViewController().navigationController?.pushViewController(ProfileOpener.open(.syncSocialMedia(SyncSocialMediaViewModel(castcleId: castcleId))), animated: true)
                }
            }
            actionSheet.addActions([deleteButton, syncButton])
            Utility.currentViewController().present(actionSheet, animated: true, completion: nil)
        } else {
            let actionSheet = CCActionSheet()
            let castcleId: String = self.viewModel.userInfo.castcleId
            let reportPageButton = CCAction(title: "Report \(castcleId)", image: UIImage.init(icon: .castcle(.report), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white), style: .normal) {
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
            let blockPageButton = CCAction(title: "Block \(castcleId)", image: UIImage.init(icon: .castcle(.block), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white), style: .normal) {
                actionSheet.dismissActionSheet()
                if UserManager.shared.isLogin {
                    self.viewModel.blockUser(castcleId: castcleId)
                } else {
                    self.delegate?.didAuthen(self)
                }
            }
            actionSheet.addActions([blockPageButton, reportPageButton])
            Utility.currentViewController().present(actionSheet, animated: true, completion: nil)
        }
    }

    @IBAction func editPageProfileAction(_ sender: Any) {
        if self.viewModel.isMyPage {
            let viewController = ProfileOpener.open(.editInfo(self.viewModel.profileType, self.viewModel.userInfo)) as? EditInfoViewController
            viewController?.delegate = self
            Utility.currentViewController().navigationController?.pushViewController(viewController ?? EditInfoViewController(), animated: true)
        }
    }

    @IBAction func viewPageProfileAction(_ sender: Any) {
        Utility.currentViewController().navigationController?.pushViewController(ProfileOpener.open(.userInfo(UserInfoViewModel(userInfo: self.viewModel.userInfo))), animated: true)
    }

    @IBAction func pageFollowAction(_ sender: Any) {
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

    @IBAction func viewPageCoverAction(_ sender: Any) {
        self.displayPageImage(imageUrl: self.viewModel.userInfo.images.cover.fullHd)
    }

    @IBAction func viewPaAvatarAction(_ sender: Any) {
        self.displayPageImage(imageUrl: self.viewModel.userInfo.images.avatar.fullHd)
    }
}

extension PageHeaderTableViewCell {
    private func displayPageImage(imageUrl: String) {
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
        let urlProfile = URL(string: self.viewModel.userInfo.images.avatar.thumbnail)
        let urlCover = URL(string: self.viewModel.userInfo.images.cover.fullHd)
        if self.viewModel.isMyPage {
            if let avatar = self.editProfileViewModel.avatar {
                self.pageAvatarImage.image = avatar
            } else {
                self.pageAvatarImage.kf.setImage(with: urlProfile, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
            }

            if let cover = self.editProfileViewModel.cover {
                self.pageCoverImage.image = cover
            } else {
                self.pageCoverImage.kf.setImage(with: urlCover, placeholder: UIImage.Asset.placeholder, options: [.transition(.fade(0.35))])
            }
        } else {
            self.pageAvatarImage.kf.setImage(with: urlProfile, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
            self.pageCoverImage.kf.setImage(with: urlCover, placeholder: UIImage.Asset.placeholder, options: [.transition(.fade(0.35))])
        }

        self.pageDisplayNameLabel.text = self.viewModel.userInfo.displayName
        self.pageCastcleIdLabel.text = self.viewModel.userInfo.castcleId
        self.pageBioLabel.text = self.viewModel.userInfo.overview
        self.pageFollowerLabel.text = String.displayCount(count: self.viewModel.userInfo.followers.count)
        self.pageCastLabel.text = String.displayCount(count: self.viewModel.userInfo.casts)
        if self.viewModel.isMyPage {
            self.editPageProfileButton.setTitle("Edit Page", for: .normal)
            self.editPageCoverButton.isHidden = false
            self.editPageProfileButton.isHidden = false
            self.editPageAvatarButton.isHidden = false
            self.viewPageProfileButton.isHidden = true
            self.pageFollowButton.isHidden = true
        } else {
            self.viewPageProfileButton.setTitle("View Page", for: .normal)
            self.editPageCoverButton.isHidden = true
            self.editPageProfileButton.isHidden = true
            self.editPageAvatarButton.isHidden = true
            self.viewPageProfileButton.isHidden = false
            self.pageFollowButton.isHidden = false
        }
    }

    private func followUI() {
        if self.viewModel.isFollow {
            self.pageFollowButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .overline)
            self.pageFollowButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
            self.pageFollowButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.Asset.lightBlue)
            self.pageFollowButton.setIcon(prefixText: "Following  ", prefixTextColor: UIColor.Asset.white, icon: .castcle(.checkmark), iconColor: UIColor.Asset.white, postfixText: "", postfixTextColor: UIColor.Asset.white, forState: .normal, textSize: 14, iconSize: 14)
        } else {
            self.pageFollowButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .overline)
            self.pageFollowButton.setBackgroundImage(UIColor.Asset.cellBackground.toImage(), for: .normal)
            self.pageFollowButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.Asset.lightBlue)
            self.pageFollowButton.setIcon(prefixText: "     Follow     ", prefixTextColor: UIColor.Asset.lightBlue, icon: .castcle(.checkmark), iconColor: UIColor.Asset.cellBackground, postfixText: "", postfixTextColor: UIColor.Asset.white, forState: .normal, textSize: 14, iconSize: 0)
        }
    }

    private func selectImageSourcePageHeader() {
        let actionSheet = CCActionSheet()
        let albumButton = CCAction(title: "Choose from Camera Roll", image: UIImage.init(icon: .castcle(.image), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white), style: .normal) {
            actionSheet.dismissActionSheet()
            self.selectCameraRollPageHeader()
        }
        let cameraButton = CCAction(title: "Take Photo", image: UIImage.init(icon: .castcle(.camera), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white), style: .normal) {
            actionSheet.dismissActionSheet()
            self.selectTakePhotoPageHeader()
        }
        actionSheet.addActions([albumButton, cameraButton])
        Utility.currentViewController().present(actionSheet, animated: true, completion: nil)
    }

    private func selectCameraRollPageHeader() {
        let photosPickerPageHeaderViewController = TLPhotosPickerViewController()
        photosPickerPageHeaderViewController.delegate = self
        photosPickerPageHeaderViewController.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        photosPickerPageHeaderViewController.collectionView.backgroundColor = UIColor.clear
        photosPickerPageHeaderViewController.navigationBar.barTintColor = UIColor.Asset.darkGraphiteBlue
        photosPickerPageHeaderViewController.navigationBar.isTranslucent = false
        photosPickerPageHeaderViewController.titleLabel.font = UIFont.asset(.regular, fontSize: .overline)
        photosPickerPageHeaderViewController.subTitleLabel.font = UIFont.asset(.regular, fontSize: .small)
        photosPickerPageHeaderViewController.doneButton.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.asset(.bold, fontSize: .head4),
            NSAttributedString.Key.foregroundColor: UIColor.Asset.lightBlue
        ], for: .normal)
        photosPickerPageHeaderViewController.cancelButton.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.asset(.regular, fontSize: .body),
            NSAttributedString.Key.foregroundColor: UIColor.Asset.lightBlue
        ], for: .normal)
        var configurePageHeader = TLPhotosPickerConfigure()
        configurePageHeader.numberOfColumn = 3
        configurePageHeader.singleSelectedMode = true
        configurePageHeader.mediaType = .image
        configurePageHeader.usedCameraButton = false
        configurePageHeader.allowedLivePhotos = false
        configurePageHeader.allowedPhotograph = false
        configurePageHeader.allowedVideo = false
        configurePageHeader.autoPlay = false
        configurePageHeader.allowedVideoRecording = false
        configurePageHeader.selectedColor = UIColor.Asset.lightBlue
        photosPickerPageHeaderViewController.configure = configurePageHeader
        Utility.currentViewController().present(photosPickerPageHeaderViewController, animated: true, completion: nil)
    }

    private func selectTakePhotoPageHeader() {
        self.showCameraIfAuthorizedPageHeader()
    }

    private func showCameraIfAuthorizedPageHeader() {
        let cameraAuthorization = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraAuthorization {
        case .authorized:
            self.showCameraPageHeader()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { [weak self] (authorized) in
                DispatchQueue.main.async { [weak self] in
                    if authorized {
                        self?.showCameraPageHeader()
                    } else {
                        self?.handleDeniedCameraAuthorizationPageHeader()
                    }
                }
            })
        case .restricted, .denied:
            self.handleDeniedCameraAuthorizationPageHeader()
        @unknown default:
            break
        }
    }

    private func showCameraPageHeader() {
        let pickerPageHeader = UIImagePickerController()
        pickerPageHeader.sourceType = .camera
        var mediaTypes: [String] = []
        mediaTypes.append(kUTTypeImage as String)
        guard mediaTypes.count > 0 else {
            return
        }
        pickerPageHeader.cameraDevice = .rear
        pickerPageHeader.mediaTypes = mediaTypes
        pickerPageHeader.allowsEditing = false
        pickerPageHeader.delegate = self
        Utility.currentViewController().present(pickerPageHeader, animated: true, completion: nil)
    }

    private func handleDeniedCameraAuthorizationPageHeader() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: "Denied camera permissions granted", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            Utility.currentViewController().present(alert, animated: true, completion: nil)
        }
    }

    private func presentCropViewControllerPageHeader(image: UIImage, updateImageType: UpdateImageType) {
        if updateImageType == .avatar {
            var config = Mantis.Config()
            config.cropViewConfig.cropShapeType = .circle(maskOnly: true)
            let cropViewController = Mantis.cropViewController(image: image, config: config)
            cropViewController.delegate = self
            cropViewController.modalPresentationStyle = .fullScreen
            Utility.currentViewController().present(cropViewController, animated: true)
        } else {
            let cropPageHeaderController = TOCropViewController(croppingStyle: .default, image: image)
            cropPageHeaderController.aspectRatioPreset = .preset16x9
            cropPageHeaderController.aspectRatioLockEnabled = true
            cropPageHeaderController.resetAspectRatioEnabled = false
            cropPageHeaderController.aspectRatioPickerButtonHidden = true
            cropPageHeaderController.delegate = self
            Utility.currentViewController().present(cropPageHeaderController, animated: true, completion: nil)
        }
    }
}

extension PageHeaderTableViewCell: TLPhotosPickerViewControllerDelegate {
    func shouldDismissPhotoPicker(withTLPHAssets: [TLPHAsset]) -> Bool {
        if let asset = withTLPHAssets.first, let image = asset.fullResolutionImage {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if self.updateImageType == .avatar {
                    self.presentCropViewControllerPageHeader(image: image, updateImageType: .avatar)
                } else if self.updateImageType == .cover {
                    self.presentCropViewControllerPageHeader(image: image, updateImageType: .cover)
                }
            }
        }
        return true
    }
}

extension PageHeaderTableViewCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    open func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }

        picker.dismiss(animated: true, completion: {
            if self.updateImageType == .avatar {
                self.presentCropViewControllerPageHeader(image: image, updateImageType: .avatar)
            } else if self.updateImageType == .cover {
                self.presentCropViewControllerPageHeader(image: image, updateImageType: .cover)
            }
        })
    }
}

extension PageHeaderTableViewCell: TOCropViewControllerDelegate {
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true, completion: {
            if self.updateImageType == .cover {
                let coverCropImage = image.resizeImage(targetSize: CGSize.init(width: 640, height: 360))
                self.pageCoverImage.image = coverCropImage
                self.editProfileViewModel.cover = coverCropImage
                self.pageCoverLoadView.isHidden = false
                self.pageCoverIndicator.startAnimating()
                self.editProfileViewModel.updateCover(isPage: true, castcleId: self.viewModel.userInfo.castcleId)
            }
        })
    }
}

extension PageHeaderTableViewCell: CropViewControllerDelegate {
    func cropViewControllerDidCrop(_ cropViewController: Mantis.CropViewController, cropped: UIImage, transformation: Mantis.Transformation, cropInfo: Mantis.CropInfo) {
        cropViewController.dismiss(animated: true, completion: {
            if self.updateImageType == .avatar {
                let avatarCropImage = cropped.resizeImage(targetSize: CGSize.init(width: 200, height: 200))
                self.pageAvatarImage.image = avatarCropImage
                self.editProfileViewModel.avatar = avatarCropImage
                self.pageAvatarLoadView.isHidden = false
                self.pageAvatarIndicator.startAnimating()
                self.editProfileViewModel.updateAvatar(isPage: true, castcleId: self.viewModel.userInfo.castcleId)
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

extension PageHeaderTableViewCell: EditProfileViewModelDelegate {
    func didUpdateInfoFinish(success: Bool) {
        if success {
            self.pageAvatarLoadView.isHidden = true
            self.pageCoverLoadView.isHidden = true
            self.pageAvatarIndicator.stopAnimating()
            self.pageCoverIndicator.stopAnimating()
            if self.updateImageType == .avatar {
                self.delegate?.didUpdateProfileSuccess(self)
                self.updateImageType = .none
            }
        }
    }
}

extension PageHeaderTableViewCell: ProfileHeaderViewModelDelegate {
    func didBlocked() {
        self.delegate?.didBlocked(self)
    }
}

extension PageHeaderTableViewCell: LightboxControllerPageDelegate {
    public func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
        // MARK: - Lightbox Move Page
    }
}

extension PageHeaderTableViewCell: LightboxControllerDismissalDelegate {
    public func lightboxControllerWillDismiss(_ controller: LightboxController) {
        // MARK: - Lightbox Dismiss
    }
}

extension PageHeaderTableViewCell: EditInfoViewControllerDelegate {
    func didUpdateInfo(_ view: EditInfoViewController, userInfo: UserInfo) {
        self.viewModel.userInfo = userInfo
        self.updateProfileUI()
        self.delegate?.didPageUpdateInfo(self, userInfo: userInfo)
    }
}
