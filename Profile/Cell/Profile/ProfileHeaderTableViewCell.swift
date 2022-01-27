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
import NVActivityIndicatorView
import ActiveLabel
import TLPhotoPicker
import TOCropViewController

protocol ProfileHeaderTableViewCellDelegate {
    func didUpdateProfileSuccess(_ profileHeaderTableViewCell: ProfileHeaderTableViewCell)
    func didAuthen(_ profileHeaderTableViewCell: ProfileHeaderTableViewCell)
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
    private var viewModel = ProfileHeaderViewModel(profileType: .unknow, userInfo: nil)
    private let editProfileViewModel = EditProfileViewModel()
    private var updateImageType: UpdateImageType = .none
    
    enum UpdateImageType {
        case none
        case avatar
        case cover
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.displayNameLabel.font = UIFont.asset(.regular, fontSize: .h4)
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
        self.followUI()
    }
    
    @IBAction func editCoverAction(_ sender: Any) {
        if self.viewModel.profileType == .me || self.viewModel.profileType == .myPage {
            self.updateImageType = .cover
            self.selectImageSource()
        }
    }
    
    @IBAction func editProfileImageAction(_ sender: Any) {
        if self.viewModel.profileType == .me || self.viewModel.profileType == .myPage {
            self.updateImageType = .avatar
            self.selectImageSource()
        }
    }
    
    @IBAction func moreAction(_ sender: Any) {
        if self.viewModel.profileType == .myPage {
            let actionSheet = CCActionSheet()
//            let syncButton = CCAction(title: "Sync social media", image: UIImage.init(icon: .castcle(.bindLink), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white), style: .default) {
//                actionSheet.dismissActionSheet()
//            }
            let deleteButton = CCAction(title: "Delete page", image: UIImage.init(icon: .castcle(.deleteOne), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white), style: .default) {
                actionSheet.dismissActionSheet()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    Utility.currentViewController().navigationController?.pushViewController(ProfileOpener.open(.deletePage(DeletePageViewModel(page: self.viewModel.pageInfo))), animated: true)
                }
            }
//            let shareButton = CCAction(title: "Share", image: UIImage.init(icon: .castcle(.share), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white), style: .default) {
//                actionSheet.dismissActionSheet()
//            }
            
            actionSheet.addActions([deleteButton])
            Utility.currentViewController().present(actionSheet, animated: true, completion: nil)
        } else if self.viewModel.profileType != .me && self.viewModel.profileType != .myPage {
            let actionSheet = CCActionSheet()
            
            var castcleId: String = ""
            var userId: String = ""
            if self.viewModel.profileType == .page {
                castcleId = self.viewModel.pageInfo.castcleId
                userId = self.viewModel.pageInfo.id
            } else {
                castcleId = self.viewModel.userInfo?.castcleId ?? ""
                userId = self.viewModel.userInfo?.id ?? ""
            }
            
            let reportButton = CCAction(title: "Report @\(castcleId)", image: UIImage.init(icon: .castcle(.report), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white), style: .default) {
                actionSheet.dismissActionSheet()
                if UserManager.shared.isLogin {
                    self.viewModel.reportUser(castcleId: castcleId)
                } else {
                    self.delegate?.didAuthen(self)
                }
            }
            let blockButton = CCAction(title: "Block @\(castcleId)", image: UIImage.init(icon: .castcle(.block), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white), style: .default) {
                actionSheet.dismissActionSheet()
                if UserManager.shared.isLogin {
                    self.viewModel.blockUser(castcleId: castcleId, userId: userId)
                } else {
                    self.delegate?.didAuthen(self)
                }
            }
            actionSheet.addActions([blockButton, reportButton])
            Utility.currentViewController().present(actionSheet, animated: true, completion: nil)
        }
    }
    
    @IBAction func editProfileAction(_ sender: Any) {
        if self.viewModel.profileType == .me || self.viewModel.profileType == .myPage {
            Utility.currentViewController().navigationController?.pushViewController(ProfileOpener.open(.editInfo(self.viewModel.profileType, self.viewModel.pageInfo)), animated: true)
        }
    }
    
    @IBAction func viewProfileAction(_ sender: Any) {
        Utility.currentViewController().navigationController?.pushViewController(ProfileOpener.open(.userInfo(UserInfoViewModel(profileType: self.viewModel.profileType, pageInfo: self.viewModel.pageInfo, userInfo: self.viewModel.userInfo))), animated: true)
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
        if self.viewModel.profileType == .me {
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
        } else if self.viewModel.profileType == .myPage || self.viewModel.profileType == .page {
            let urlProfile = URL(string: self.viewModel.pageInfo.images.avatar.thumbnail)
            let urlCover = URL(string: self.viewModel.pageInfo.images.cover.large)
            
            if let avatar = self.editProfileViewModel.avatar {
                self.profileImage.image = avatar
            } else {
                self.profileImage.kf.setImage(with: urlProfile, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
            }
            
            if let cover = self.editProfileViewModel.cover {
                self.coverImage.image = cover
            } else {
                self.coverImage.kf.setImage(with: urlCover, placeholder: UIImage.Asset.placeholder, options: [.transition(.fade(0.35))])
            }
        } else {
            guard let user = self.viewModel.userInfo else { return }
            let urlProfile = URL(string: user.images.avatar.thumbnail)
            let urlCover = URL(string: user.images.cover.fullHd)
            
            self.profileImage.kf.setImage(with: urlProfile, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
            self.coverImage.kf.setImage(with: urlCover, placeholder: UIImage.Asset.placeholder, options: [.transition(.fade(0.35))])
        }
        
        if self.viewModel.profileType == .myPage || self.viewModel.profileType == .page {
            self.displayNameLabel.text = self.viewModel.pageInfo.displayName
            self.userIdLabel.text = "@\(self.viewModel.pageInfo.castcleId)"
            
            self.followLabel.customize { label in
                label.font = UIFont.asset(.regular, fontSize: .body)
                label.numberOfLines = 1
                label.textColor = UIColor.Asset.gray
                
                let followingType = ActiveType.custom(pattern: "\(self.viewModel.pageInfo.following.count) ")
                let followerType = ActiveType.custom(pattern: "\(self.viewModel.pageInfo.followers.count) ")
                
                label.enabledTypes = [followingType, followerType]
                label.customColor[followingType] = UIColor.Asset.white
                label.customSelectedColor[followingType] = UIColor.Asset.gray
                label.customColor[followerType] = UIColor.Asset.white
                label.customSelectedColor[followerType] = UIColor.Asset.gray
            }
            self.followLabel.text = "\(self.viewModel.pageInfo.following.count) Following   \(self.viewModel.pageInfo.followers.count) Followers"
            self.bioLabel.text = self.viewModel.pageInfo.overview
        } else if self.viewModel.profileType == .me {
            self.displayNameLabel.text = UserManager.shared.displayName
            self.userIdLabel.text = UserManager.shared.castcleId
            
            self.followLabel.customize { label in
                label.font = UIFont.asset(.regular, fontSize: .body)
                label.numberOfLines = 1
                label.textColor = UIColor.Asset.gray
                
                let followingType = ActiveType.custom(pattern: UserManager.shared.following)
                let followerType = ActiveType.custom(pattern: UserManager.shared.followers)
                
                label.enabledTypes = [followingType, followerType]
                label.customColor[followingType] = UIColor.Asset.white
                label.customSelectedColor[followingType] = UIColor.Asset.gray
                label.customColor[followerType] = UIColor.Asset.white
                label.customSelectedColor[followerType] = UIColor.Asset.gray
            }
            self.followLabel.text = "\(UserManager.shared.following)Following   \(UserManager.shared.followers)Followers"
            self.bioLabel.text = UserManager.shared.overview
        } else {
            guard let user = self.viewModel.userInfo else { return }
            self.displayNameLabel.text = user.displayName
            self.userIdLabel.text = "@\(user.castcleId)"
            
            self.followLabel.customize { label in
                label.font = UIFont.asset(.regular, fontSize: .body)
                label.numberOfLines = 1
                label.textColor = UIColor.Asset.gray
                
                let followingType = ActiveType.custom(pattern: "\(user.following.count) ")
                let followerType = ActiveType.custom(pattern: "\(user.followers.count) ")
                
                label.enabledTypes = [followingType, followerType]
                label.customColor[followingType] = UIColor.Asset.white
                label.customSelectedColor[followingType] = UIColor.Asset.gray
                label.customColor[followerType] = UIColor.Asset.white
                label.customSelectedColor[followerType] = UIColor.Asset.gray
            }
            self.followLabel.text = "\(user.following.count) Following   \(user.followers.count) Followers"
            self.bioLabel.text = user.overview
        }
        
        if self.viewModel.profileType == .me || self.viewModel.profileType == .myPage {
            self.editCoverButton.isHidden = false
            self.editProfileButton.isHidden = false
            self.editProfileImageButton.isHidden = false
            self.viewProfileButton.isHidden = true
            self.followButton.isHidden = true
        } else {
            self.editCoverButton.isHidden = true
            self.editProfileButton.isHidden = true
            self.editProfileImageButton.isHidden = true
            self.viewProfileButton.isHidden = false
            self.followButton.isHidden = false
        }
    }
    
    private func followUI() {
        if self.viewModel.isFollow == true {
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
        let albumButton = CCAction(title: "Choose from Camera Roll", image: UIImage.init(icon: .castcle(.image), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white), style: .default) {
            actionSheet.dismissActionSheet()
            self.selectCameraRoll()
        }
        let cameraButton = CCAction(title: "Take Photo", image: UIImage.init(icon: .castcle(.camera), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white), style: .default) {
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

extension ProfileHeaderTableViewCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    open func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
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
                if self.viewModel.profileType == .me {
                    self.avatarLoadView.isHidden = false
                    self.avatarIndicator.startAnimating()
                    self.editProfileViewModel.updateAvatar()
                } else if self.viewModel.profileType == .myPage {
                    self.avatarLoadView.isHidden = false
                    self.avatarIndicator.startAnimating()
                    self.editProfileViewModel.updatePageAvatar(castcleId: self.viewModel.pageInfo.castcleId)
                }
            }
        })
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true, completion: {
            if self.updateImageType == .cover {
                let coverCropImage = image.resizeImage(targetSize: CGSize.init(width: 640, height: 480))
                self.coverImage.image = coverCropImage
                self.editProfileViewModel.cover = coverCropImage
                if self.viewModel.profileType == .me {
                    self.coverLoadView.isHidden = false
                    self.coverIndicator.startAnimating()
                    self.editProfileViewModel.updateCover()
                } else if self.viewModel.profileType == .myPage {
                    self.coverLoadView.isHidden = false
                    self.coverIndicator.startAnimating()
                    self.editProfileViewModel.updatePageCover(castcleId: self.viewModel.pageInfo.castcleId)
                }
            }
        })
    }
}

extension ProfileHeaderTableViewCell: EditProfileViewModelDelegate {
    func didUpdateProfileFinish(success: Bool) {
        if success {
            self.avatarLoadView.isHidden = true
            self.coverLoadView.isHidden = true
            self.avatarIndicator.stopAnimating()
            self.coverIndicator.stopAnimating()
            if self.updateImageType == .avatar {
                if self.viewModel.profileType == .me {
                    self.delegate?.didUpdateProfileSuccess(self)
                }
                self.updateImageType = .none
            }
        }
    }
    
    func didUpdatePageFinish(success: Bool) {
        if success {
            self.avatarLoadView.isHidden = true
            self.coverLoadView.isHidden = true
            self.avatarIndicator.stopAnimating()
            self.coverIndicator.stopAnimating()
            if self.updateImageType == .avatar {
                if self.viewModel.profileType == .myPage {
                    self.delegate?.didUpdateProfileSuccess(self)
                }
                self.updateImageType = .none
            }
        }
    }
}
