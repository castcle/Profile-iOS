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
//  EditInfoTableViewCell.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 8/8/2564 BE.
//

import UIKit
import Photos
import MobileCoreServices
import Core
import Component
import UITextView_Placeholder
import PanModal
import Defaults
import JGProgressHUD
import TOCropViewController
import TLPhotoPicker

class EditInfoTableViewCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet var coverImage: UIImageView!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var editCoverButton: UIButton!
    @IBOutlet var editProfileImageButton: UIButton!
    @IBOutlet var castcleIdLabel: UILabel!
    @IBOutlet var castcleIdNoticeLabel: UILabel!
    @IBOutlet var prefixLabel: UILabel!
    @IBOutlet var displayNameLabel: UILabel!
    @IBOutlet var linkTitleLabel: UILabel!
    @IBOutlet var overviewLabel: UILabel!
    @IBOutlet var overviewTextView: UITextView!
    @IBOutlet var birthdayTitleLabel: UILabel!
    @IBOutlet var birthdayLabel: UILabel!
    @IBOutlet var castcleIdTextField: UITextField!
    @IBOutlet var displayNameTextField: UITextField!
    @IBOutlet var facebookTextField: UITextField!
    @IBOutlet var twitterTextField: UITextField!
    @IBOutlet var youtubeTextField: UITextField!
    @IBOutlet var mediumTextField: UITextField!
    @IBOutlet var websiteTextField: UITextField!
    @IBOutlet var castcleIdView: UIView!
    @IBOutlet var displayNameView: UIView!
    @IBOutlet var aboutView: UIView!
    @IBOutlet var facebookView: UIView!
    @IBOutlet var twitterView: UIView!
    @IBOutlet var youtubeView: UIView!
    @IBOutlet var mediumView: UIView!
    @IBOutlet var websiteView: UIView!
    @IBOutlet var arrowImage: UIImageView!
    
    @IBOutlet var facebookIconView: UIView!
    @IBOutlet var facebookIcon: UIImageView!
    @IBOutlet var twitterIconView: UIView!
    @IBOutlet var twitterIcon: UIImageView!
    @IBOutlet var youtubeIconView: UIView!
    @IBOutlet var youtubeIcon: UIImageView!
    @IBOutlet var mediumIconView: UIView!
    @IBOutlet var mediumIcon: UIImageView!
    @IBOutlet var websiteIconView: UIView!
    @IBOutlet var websiteIcon: UIImageView!
    
    @IBOutlet var selectDateButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    
    let viewModel = EditInfoViewModel()
    let hud = JGProgressHUD()
    private var dobDate: Date? = nil
    private var updateImageType: UpdateImageType = .none
    
    enum UpdateImageType {
        case none
        case avatar
        case cover
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profileImage.circle(color: UIColor.Asset.white)
        self.editProfileImageButton.setImage(UIImage.init(icon: .castcle(.camera), size: CGSize(width: 15, height: 15), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        self.editProfileImageButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
        self.editProfileImageButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.Asset.white)
        self.editCoverButton.setImage(UIImage.init(icon: .castcle(.camera), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        self.editCoverButton.setBackgroundImage(UIColor.Asset.gray.toImage(), for: .normal)
        self.editCoverButton.capsule()
        
        self.castcleIdLabel.font = UIFont.asset(.bold, fontSize: .body)
        self.castcleIdLabel.textColor = UIColor.Asset.white
        self.castcleIdNoticeLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.castcleIdNoticeLabel.textColor = UIColor.Asset.white
        self.prefixLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.prefixLabel.textColor = UIColor.Asset.lightGray
        self.displayNameLabel.font = UIFont.asset(.bold, fontSize: .body)
        self.displayNameLabel.textColor = UIColor.Asset.white
        self.overviewLabel.font = UIFont.asset(.bold, fontSize: .body)
        self.overviewLabel.textColor = UIColor.Asset.white
        self.overviewTextView.font = UIFont.asset(.regular, fontSize: .body)
        self.overviewTextView.textColor = UIColor.Asset.white
        self.birthdayTitleLabel.font = UIFont.asset(.bold, fontSize: .body)
        self.birthdayTitleLabel.textColor = UIColor.Asset.white
        self.birthdayLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.birthdayLabel.textColor = UIColor.Asset.lightBlue
        self.linkTitleLabel.font = UIFont.asset(.bold, fontSize: .body)
        self.linkTitleLabel.textColor = UIColor.Asset.white
        
        self.castcleIdTextField.font = UIFont.asset(.regular, fontSize: .body)
        self.castcleIdTextField.textColor = UIColor.Asset.white
        self.displayNameTextField.font = UIFont.asset(.regular, fontSize: .body)
        self.displayNameTextField.textColor = UIColor.Asset.white
        self.facebookTextField.font = UIFont.asset(.regular, fontSize: .body)
        self.facebookTextField.textColor = UIColor.Asset.white
        self.twitterTextField.font = UIFont.asset(.regular, fontSize: .body)
        self.twitterTextField.textColor = UIColor.Asset.white
        self.youtubeTextField.font = UIFont.asset(.regular, fontSize: .body)
        self.youtubeTextField.textColor = UIColor.Asset.white
        self.mediumTextField.font = UIFont.asset(.regular, fontSize: .body)
        self.mediumTextField.textColor = UIColor.Asset.white
        self.websiteTextField.font = UIFont.asset(.regular, fontSize: .body)
        self.websiteTextField.textColor = UIColor.Asset.white
        
        self.castcleIdView.custom(color: UIColor.Asset.darkGray, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.displayNameView.custom(color: UIColor.Asset.darkGray, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.aboutView.custom(color: UIColor.Asset.darkGray, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.facebookView.custom(color: UIColor.Asset.darkGray, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.twitterView.custom(color: UIColor.Asset.darkGray, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.youtubeView.custom(color: UIColor.Asset.darkGray, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.mediumView.custom(color: UIColor.Asset.darkGray, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.websiteView.custom(color: UIColor.Asset.darkGray, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        
        self.arrowImage.image = UIImage.init(icon: .castcle(.next), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white)
        
        self.facebookIconView.capsule(color: UIColor.Asset.facebook)
        self.facebookIcon.image = UIImage.init(icon: .castcle(.facebook), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
        self.twitterIconView.capsule(color: UIColor.Asset.twitter)
        self.twitterIcon.image = UIImage.init(icon: .castcle(.twitter), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
        self.youtubeIconView.capsule(color: UIColor.Asset.white)
        self.youtubeIcon.image = UIImage.init(icon: .castcle(.youtube), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.denger)
        self.mediumIconView.capsule(color: UIColor.Asset.white)
        self.mediumIcon.image = UIImage.init(icon: .castcle(.medium), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.black)
        self.websiteIconView.capsule(color: UIColor.Asset.white)
        self.websiteIcon.image = UIImage.init(icon: .castcle(.image), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.lightBlue)

        self.hud.textLabel.text = "Saving"
        self.overviewTextView.delegate = self
        self.overviewTextView.placeholder = "Write something to introduce yourself!"
        self.saveButton.setTitle("Save", for: .normal)
        self.saveButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .h4)
        self.saveButton.setTitleColor(UIColor.Asset.white, for: .normal)
        self.saveButton.capsule(color: UIColor.Asset.lightBlue, borderWidth: 1, borderColor: UIColor.Asset.lightBlue)
        self.viewModel.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configCell() {
        self.updateUI()
    }
    
    private func updateUI() {
        if let avatar = self.viewModel.avatar {
            self.profileImage.image = avatar
        } else {
            let url = URL(string: UserManager.shared.avatar)
            self.profileImage.kf.setImage(with: url, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
        }
        
        if let cover = self.viewModel.cover {
            self.coverImage.image = cover
        } else {
            let url = URL(string: UserManager.shared.cover)
            self.coverImage.kf.setImage(with: url, placeholder: UIImage.Asset.placeholder, options: [.transition(.fade(0.35))])
        }
        
        self.castcleIdTextField.text = UserManager.shared.rawCastcleId
        self.displayNameTextField.text = UserManager.shared.displayName
        self.overviewTextView.text = UserManager.shared.overview
        
        if UserManager.shared.canUpdateCastcleId {
            self.castcleIdNoticeLabel.text = ""
            self.castcleIdTextField.isEnabled = true
        } else {
            self.castcleIdNoticeLabel.text = "Once your Castcle ID has been changed, you can edit it again after 60 days."
            self.castcleIdTextField.isEnabled = false
        }
        
        self.dobDate = (UserManager.shared.dob == "" ? nil : (Date.stringToDate(str: UserManager.shared.dob)))
        if let dob = self.dobDate {
            self.birthdayLabel.text = dob.dateToString()
        } else {
            self.birthdayLabel.text = "N/A"
        }
        
        self.facebookTextField.text = (UserManager.shared.facebookLink.isEmpty ? "https://" : UserManager.shared.facebookLink)
        self.twitterTextField.text = (UserManager.shared.twitterLink.isEmpty ? "https://" : UserManager.shared.twitterLink)
        self.youtubeTextField.text = (UserManager.shared.youtubeLink.isEmpty ? "https://" : UserManager.shared.youtubeLink)
        self.mediumTextField.text = (UserManager.shared.mediumLink.isEmpty ? "https://" : UserManager.shared.mediumLink)
        self.websiteTextField.text = (UserManager.shared.websiteLink.isEmpty ? "https://" : UserManager.shared.websiteLink)
    }
    
    private func disableUI(isActive: Bool) {
        if isActive {
            self.overviewTextView.isEditable = true
            self.selectDateButton.isEnabled = true
            self.facebookTextField.isEnabled = true
            self.twitterTextField.isEnabled = true
            self.youtubeTextField.isEnabled = true
            self.mediumTextField.isEnabled = true
            self.websiteTextField.isEnabled = true
        } else {
            self.overviewTextView.isEditable = false
            self.selectDateButton.isEnabled = false
            self.facebookTextField.isEnabled = false
            self.twitterTextField.isEnabled = false
            self.youtubeTextField.isEnabled = false
            self.mediumTextField.isEnabled = false
            self.websiteTextField.isEnabled = false
        }
    }
    
    @IBAction func selectDateAction(_ sender: Any) {
        let vc = ComponentOpener.open(.datePicker) as? DatePickerViewController
        vc?.initDate = self.dobDate
        vc?.delegate = self
        Utility.currentViewController().presentPanModal(vc ?? DatePickerViewController())
    }
    
    @IBAction func saveAction(_ sender: Any) {
        self.hud.show(in: Utility.currentViewController().view)
        self.disableUI(isActive: false)
        
        if (self.castcleIdTextField.text!).trimmingCharacters(in: .whitespacesAndNewlines) != UserManager.shared.rawCastcleId {
            self.viewModel.userRequest.payload.castcleId = (self.castcleIdTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        if (self.displayNameTextField.text!).trimmingCharacters(in: .whitespacesAndNewlines) != UserManager.shared.displayName {
            self.viewModel.userRequest.payload.displayName = (self.displayNameTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        self.viewModel.userRequest.payload.overview = self.overviewTextView.text ?? ""
        self.viewModel.userRequest.payload.links.facebook = (self.facebookTextField.text! == "https://" ? "" : self.facebookTextField.text!)
        self.viewModel.userRequest.payload.links.twitter = (self.twitterTextField.text! == "https://" ? "" : self.twitterTextField.text!)
        self.viewModel.userRequest.payload.links.youtube = (self.youtubeTextField.text! == "https://" ? "" : self.youtubeTextField.text!)
        self.viewModel.userRequest.payload.links.medium = (self.mediumTextField.text! == "https://" ? "" : self.mediumTextField.text!)
        self.viewModel.userRequest.payload.links.website = (self.websiteTextField.text! == "https://" ? "" : self.websiteTextField.text!)
        self.viewModel.updateProfile(isPage: false, castcleId: UserManager.shared.rawCastcleId)
    }
    
    @IBAction func editCoverAction(_ sender: Any) {
        self.updateImageType = .cover
        self.selectImageSource()
    }
    
    @IBAction func editProfileImageAction(_ sender: Any) {
        self.updateImageType = .avatar
        self.selectImageSource()
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

extension EditInfoTableViewCell: DatePickerViewControllerDelegate {
    func datePickerViewController(_ view: DatePickerViewController, didSelectDate date: Date, displayDate: String) {
        self.viewModel.dobDate = date
        self.birthdayLabel.text = displayDate
    }
}

extension EditInfoTableViewCell: EditInfoViewModelDelegate {
    func didUpdateInfoFinish(success: Bool) {
        self.hud.dismiss()
        if success {
            Utility.currentViewController().navigationController?.popViewController(animated: true)
        } else {
            self.disableUI(isActive: true)
        }
    }
}

extension EditInfoTableViewCell: TLPhotosPickerViewControllerDelegate {
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

extension EditInfoTableViewCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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

extension EditInfoTableViewCell: TOCropViewControllerDelegate {
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
