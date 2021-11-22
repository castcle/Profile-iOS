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
//  MeHeaderViewController.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 13/8/2564 BE.
//

import UIKit
import Photos
import MobileCoreServices
import Core
import Component
import Post
import Kingfisher
import SwiftColor
import ActiveLabel
import TLPhotoPicker
import TOCropViewController

public protocol MeHeaderViewControllerDelegate {
    func didUpdateProfileFinish()
}

class MeHeaderViewController: UIViewController {

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
    
    @IBOutlet var lineView: UIView!
    @IBOutlet var newPostView: UIView!
    @IBOutlet var searchView: UIView!
    @IBOutlet var miniProfileImage: UIImageView!
    @IBOutlet var placeholderLabel: UILabel!
    @IBOutlet var postViewConstaint: NSLayoutConstraint!
    
    public var delegate: MeHeaderViewControllerDelegate?
    var viewModel = MeHeaderViewModel(profileType: .unknow, userInfo: nil)
    private let editProfileViewModel = EditProfileViewModel()
    private var updateImageType: UpdateImageType = .none
    
    enum UpdateImageType {
        case none
        case avatar
        case cover
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.Asset.darkGray
        self.displayNameLabel.font = UIFont.asset(.regular, fontSize: .h4)
        self.displayNameLabel.textColor = UIColor.Asset.white
        self.userIdLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.userIdLabel.textColor = UIColor.Asset.gray
        self.bioLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.bioLabel.textColor = UIColor.Asset.white
        
        self.profileImage.circle(color: UIColor.Asset.white)
        
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
        
        self.lineView.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.newPostView.backgroundColor = UIColor.Asset.darkGray
        self.searchView.custom(color: UIColor.Asset.darkGray, cornerRadius: 18, borderWidth: 1, borderColor: UIColor.Asset.darkGraphiteBlue)
        self.miniProfileImage.circle(color: UIColor.Asset.darkGraphiteBlue)
        self.placeholderLabel.font = UIFont.asset(.light, fontSize: .overline)
        self.placeholderLabel.textColor = UIColor.Asset.lightGray
        
        self.followUI()
        self.editProfileViewModel.delegate = self
        
        self.viewModel.didGetInfoFinish = {
            self.updateProfileUI()
            self.delegate?.didUpdateProfileFinish()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateProfileUI()
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadData(notfication:)), name: .getUserInfo, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .getUserInfo, object: nil)
    }
    
    @objc func reloadData(notfication: NSNotification) {
        self.viewModel.reloadInfo()
    }
    
    private func updateProfileUI() {
        if self.viewModel.profileType == .me {
            if let avatar = self.editProfileViewModel.avatar {
                self.profileImage.image = avatar
                self.miniProfileImage.image = avatar
            } else {
                self.profileImage.image = UserManager.shared.avatar
                self.miniProfileImage.image = UserManager.shared.avatar
            }
            
            if let cover = self.editProfileViewModel.cover {
                self.coverImage.image = cover
            } else {
                self.coverImage.image = UserManager.shared.cover
            }
        } else if self.viewModel.profileType == .myPage {
            let localProfile = ImageHelper.shared.loadImageFromDocumentDirectory(nameOfImage: self.viewModel.pageInfo.castcleId, type: .avatar)
            let localCover = ImageHelper.shared.loadImageFromDocumentDirectory(nameOfImage: self.viewModel.pageInfo.castcleId, type: .cover)
            
            if let avatar = self.editProfileViewModel.avatar {
                self.profileImage.image = avatar
                self.miniProfileImage.image = avatar
            } else {
                self.profileImage.image = localProfile
                self.miniProfileImage.image = localProfile
            }
            
            if let cover = self.editProfileViewModel.cover {
                self.coverImage.image = cover
            } else {
                self.coverImage.image = localCover
            }
        } else if self.viewModel.profileType == .page {
            let urlProfile = URL(string: self.viewModel.pageInfo.images.avatar.thumbnail)
            let urlCover = URL(string: self.viewModel.pageInfo.images.cover.large)
            
            if let avatar = self.editProfileViewModel.avatar {
                self.profileImage.image = avatar
                self.miniProfileImage.image = avatar
            } else {
                self.profileImage.kf.setImage(with: urlProfile, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
                self.miniProfileImage.kf.setImage(with: urlProfile, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
            }
            
            if let cover = self.editProfileViewModel.cover {
                self.coverImage.image = cover
            } else {
                self.coverImage.kf.setImage(with: urlCover, placeholder: UIImage.Asset.placeholder, options: [.transition(.fade(0.35))])
            }
        } else {
            guard let user = self.viewModel.userInfo else { return }
            let urlProfile = URL(string: user.images.avatar.thumbnail)
            let urlCover = URL(string: user.images.cover.thumbnail)
            
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
            
            self.newPostView.isHidden = false
            self.postViewConstaint.constant = 65.0
        } else {
            self.editCoverButton.isHidden = true
            self.editProfileButton.isHidden = true
            self.editProfileImageButton.isHidden = true
            
            self.viewProfileButton.isHidden = false
            self.followButton.isHidden = false
            
            self.newPostView.isHidden = true
            self.postViewConstaint.constant = 0.0
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
        self.present(picker, animated: true, completion: nil)
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
            self.present(cropController, animated: true, completion: nil)
        } else {
            let cropController = TOCropViewController(croppingStyle: .default, image: image)
            cropController.aspectRatioPreset = .preset4x3
            cropController.aspectRatioLockEnabled = true
            cropController.resetAspectRatioEnabled = false
            cropController.aspectRatioPickerButtonHidden = true
            cropController.delegate = self
            self.present(cropController, animated: true, completion: nil)
        }
    }
    
    @IBAction func postAction(_ sender: Any) {
        if self.viewModel.profileType == .me {
            let vc = PostOpener.open(.post(PostViewModel(postType: .newCast)))
            vc.modalPresentationStyle = .fullScreen
            Utility.currentViewController().present(vc, animated: true, completion: nil)
        } else if self.viewModel.profileType == .myPage {
            let vc = PostOpener.open(.post(PostViewModel(postType: .newCast, page: Page().initCustom(displayName: self.viewModel.pageInfo.displayName, castcleId: self.viewModel.pageInfo.castcleId))))
            vc.modalPresentationStyle = .fullScreen
            Utility.currentViewController().present(vc, animated: true, completion: nil)
        }
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
            let syncButton = CCAction(title: "Sync social media", image: UIImage.init(icon: .castcle(.bindLink), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white), style: .default) {
                actionSheet.dismissActionSheet()
            }
            let deleteButton = CCAction(title: "Delete page", image: UIImage.init(icon: .castcle(.deleteOne), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white), style: .default) {
                actionSheet.dismissActionSheet()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    Utility.currentViewController().navigationController?.pushViewController(ProfileOpener.open(.deletePage(DeletePageViewModel(page: self.viewModel.pageInfo))), animated: true)
                }
            }
            let shareButton = CCAction(title: "Share", image: UIImage.init(icon: .castcle(.share), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white), style: .default) {
                actionSheet.dismissActionSheet()
            }
            
            actionSheet.addActions([syncButton, deleteButton, shareButton])
            Utility.currentViewController().present(actionSheet, animated: true, completion: nil)
        }
        if self.viewModel.profileType != .me && self.viewModel.profileType != .myPage {
            let vc = ProfileOpener.open(.action) as? ProfileActionViewController
            Utility.currentViewController().presentPanModal(vc ?? ProfileActionViewController())
        }
    }
    
    @IBAction func editProfileAction(_ sender: Any) {
        if self.viewModel.profileType == .me || self.viewModel.profileType == .myPage {
            Utility.currentViewController().navigationController?.pushViewController(ProfileOpener.open(.editInfo(self.viewModel.profileType, self.viewModel.pageInfo)), animated: true)
        }
    }
    
    @IBAction func viewProfileAction(_ sender: Any) {
        Utility.currentViewController().navigationController?.pushViewController(ProfileOpener.open(.userInfo), animated: true)
    }
    
    @IBAction func followAction(_ sender: Any) {
        if self.viewModel.isFollow {
            self.viewModel.unfollowUser()
        } else {
            self.viewModel.followUser()
        }
        self.viewModel.isFollow.toggle()
        self.followUI()
    }
}

extension MeHeaderViewController: TLPhotosPickerViewControllerDelegate {
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

extension MeHeaderViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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

extension MeHeaderViewController: TOCropViewControllerDelegate {
    func cropViewController(_ cropViewController: TOCropViewController, didCropToCircularImage image: UIImage, with cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true, completion: {
            if self.updateImageType == .avatar {
                let avatarCropImage = image.resizeImage(targetSize: CGSize.init(width: 200, height: 200))
                self.profileImage.image = avatarCropImage
                self.miniProfileImage.image = avatarCropImage
                self.editProfileViewModel.avatar = avatarCropImage
                if self.viewModel.profileType == .me {
                    self.editProfileViewModel.updateAvatar()
                } else if self.viewModel.profileType == .myPage {
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
                    self.editProfileViewModel.updateCover()
                } else if self.viewModel.profileType == .myPage {
                    self.editProfileViewModel.updatePageCover(castcleId: self.viewModel.pageInfo.castcleId)
                }
            }
        })
    }
}

extension MeHeaderViewController: EditProfileViewModelDelegate {
    func didUpdateProfileFinish(success: Bool) {
        if success {
            if self.updateImageType == .avatar {
                if self.viewModel.profileType == .me {
                    self.delegate?.didUpdateProfileFinish()
                }
                self.updateImageType = .none
            }
            
        }
    }
    
    func didUpdatePageFinish(success: Bool) {
        if success {
            if self.updateImageType == .avatar {
                if self.viewModel.profileType == .myPage {
                    self.delegate?.didUpdateProfileFinish()
                }
                self.updateImageType = .none
            }
        }
    }
}
