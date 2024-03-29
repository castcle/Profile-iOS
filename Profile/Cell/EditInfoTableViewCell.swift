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
import Networking
import Component
import UITextView_Placeholder
import PanModal
import Defaults
import TOCropViewController
import TLPhotoPicker
import Mantis

protocol EditInfoTableViewCellDelegate: AnyObject {
    func didUpdateUserInfo(_ cell: EditInfoTableViewCell, userInfo: UserInfo)
}

class EditInfoTableViewCell: UITableViewCell, UITextViewDelegate, UITextFieldDelegate {

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

    var delegate: EditInfoTableViewCellDelegate?
    let viewModel = EditInfoViewModel()
    private var dobDate: Date?
    private var updateImageType: UpdateImageType = .none

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

        self.castcleIdView.custom(color: UIColor.Asset.cellBackground, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.displayNameView.custom(color: UIColor.Asset.cellBackground, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.aboutView.custom(color: UIColor.Asset.cellBackground, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.facebookView.custom(color: UIColor.Asset.cellBackground, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.twitterView.custom(color: UIColor.Asset.cellBackground, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.youtubeView.custom(color: UIColor.Asset.cellBackground, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.mediumView.custom(color: UIColor.Asset.cellBackground, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.websiteView.custom(color: UIColor.Asset.cellBackground, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.arrowImage.image = UIImage.init(icon: .castcle(.next), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white)
        self.facebookIconView.capsule(color: UIColor.Asset.facebook)
        self.facebookIcon.image = UIImage.init(icon: .castcle(.facebook), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
        self.twitterIconView.capsule(color: UIColor.Asset.twitter)
        self.twitterIcon.image = UIImage.init(icon: .castcle(.twitter), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
        self.youtubeIconView.capsule(color: UIColor.Asset.white)
        self.youtubeIcon.image = UIImage.init(icon: .castcle(.youtubeBold), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.denger)
        self.mediumIconView.capsule(color: UIColor.Asset.white)
        self.mediumIcon.image = UIImage.init(icon: .castcle(.medium), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.black)
        self.websiteIconView.capsule(color: UIColor.Asset.white)
        self.websiteIcon.image = UIImage.init(icon: .castcle(.others), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.lightBlue)

        self.overviewTextView.delegate = self
        self.overviewTextView.placeholder = "Write something to introduce yourself!"
        self.viewModel.delegate = self
        self.viewModel.profileType = .mine
        self.castcleIdTextField.tag = 0
        self.castcleIdTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.displayNameTextField.tag = 1
        self.displayNameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.facebookTextField.delegate = self
        self.facebookTextField.tag = 2
        self.facebookTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.twitterTextField.delegate = self
        self.twitterTextField.tag = 3
        self.twitterTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.youtubeTextField.delegate = self
        self.youtubeTextField.tag = 4
        self.youtubeTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.mediumTextField.delegate = self
        self.mediumTextField.tag = 5
        self.mediumTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.websiteTextField.delegate = self
        self.websiteTextField.tag = 6
        self.websiteTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
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

        self.castcleIdTextField.text = UserManager.shared.castcleId.toRawCastcleId
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

        self.facebookTextField.text = (UserManager.shared.facebookLink.isEmpty ? UrlProtocol.https.value : UserManager.shared.facebookLink)
        self.twitterTextField.text = (UserManager.shared.twitterLink.isEmpty ? UrlProtocol.https.value : UserManager.shared.twitterLink)
        self.youtubeTextField.text = (UserManager.shared.youtubeLink.isEmpty ? UrlProtocol.https.value : UserManager.shared.youtubeLink)
        self.mediumTextField.text = (UserManager.shared.mediumLink.isEmpty ? UrlProtocol.https.value : UserManager.shared.mediumLink)
        self.websiteTextField.text = (UserManager.shared.websiteLink.isEmpty ? UrlProtocol.https.value : UserManager.shared.websiteLink)
        self.viewModel.mappingData()
        self.saveButton.activeButton(isActive: false)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag >= 2 && textField.tag <= 6 {
            textField.text = (textField.text! == UrlProtocol.https.value ? "" : textField.text!.toUrlString)
        }
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        if textField.tag == 0 {
            let displayCastcleId = textField.text ?? ""
            textField.text = displayCastcleId.toRawCastcleId
            if UserManager.shared.canUpdateCastcleId && ((textField.text!).trimmingCharacters(in: .whitespacesAndNewlines).toCastcleId != UserManager.shared.castcleId) {
                self.viewModel.userRequest.payload.castcleId = (textField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).toCastcleId
            } else {
                self.viewModel.userRequest.payload.castcleId = ""
            }
        } else if textField.tag == 1 {
            if (textField.text!).trimmingCharacters(in: .whitespacesAndNewlines) != UserManager.shared.displayName {
                self.viewModel.userRequest.payload.displayName = (textField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            } else {
                self.viewModel.userRequest.payload.displayName = ""
            }
        } else if textField.tag == 2 {
            self.viewModel.userRequest.payload.links.facebook = (textField.text! == UrlProtocol.https.value ? "" : textField.text!.toUrlString)
        } else if textField.tag == 3 {
            self.viewModel.userRequest.payload.links.twitter = (textField.text! == UrlProtocol.https.value ? "" : textField.text!.toUrlString)
        } else if textField.tag == 4 {
            self.viewModel.userRequest.payload.links.youtube = (textField.text! == UrlProtocol.https.value ? "" : textField.text!.toUrlString)
        } else if textField.tag == 5 {
            self.viewModel.userRequest.payload.links.medium = (textField.text! == UrlProtocol.https.value ? "" : textField.text!.toUrlString)
        } else if textField.tag == 6 {
            self.viewModel.userRequest.payload.links.website = (textField.text! == UrlProtocol.https.value ? "" : textField.text!.toUrlString)
        }
        self.saveButton.activeButton(isActive: self.viewModel.isCanUpdateInfo())
    }

    func textViewDidChange(_ textView: UITextView) {
        let overView = (textView.text ?? "").substringWithRange(range: 280)
        textView.text = overView
        self.viewModel.userRequest.payload.overview = overView
        self.saveButton.activeButton(isActive: self.viewModel.isCanUpdateInfo())
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
        let viewController = ComponentOpener.open(.datePicker) as? DatePickerViewController
        viewController?.initDate = self.dobDate
        viewController?.delegate = self
        Utility.currentViewController().presentPanModal(viewController ?? DatePickerViewController())
    }

    @IBAction func saveAction(_ sender: Any) {
        if self.viewModel.isCanUpdateInfo() {
            guard (self.castcleIdTextField.text!).trimmingCharacters(in: .whitespacesAndNewlines).toCastcleId.isCastcleId else {
                ApiHelper.displayError(error: "Castcle ID cannot contain special characters")
                return
            }
            CCLoading.shared.show(text: "Saving")
            self.disableUI(isActive: false)
            self.viewModel.updateProfile(isPage: false, castcleId: UserManager.shared.castcleId)
        }
    }

    @IBAction func editCoverAction(_ sender: Any) {
        self.updateImageType = .cover
        self.selectImageSourceEditInfo()
    }

    @IBAction func editProfileImageAction(_ sender: Any) {
        self.updateImageType = .avatar
        self.selectImageSourceEditInfo()
    }

    private func selectImageSourceEditInfo() {
        let actionSheet = CCActionSheet()
        let albumButton = CCAction(title: "Choose from Camera Roll", image: UIImage.init(icon: .castcle(.image), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white), style: .normal) {
            actionSheet.dismissActionSheet()
            self.selectCameraRollEditInfo()
        }
        let cameraButton = CCAction(title: "Take Photo", image: UIImage.init(icon: .castcle(.camera), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white), style: .normal) {
            actionSheet.dismissActionSheet()
            self.selectTakePhotoEditInfo()
        }

        actionSheet.addActions([albumButton, cameraButton])
        Utility.currentViewController().present(actionSheet, animated: true, completion: nil)
    }

    private func selectCameraRollEditInfo() {
        let photosPickerEditInfoViewController = TLPhotosPickerViewController()
        photosPickerEditInfoViewController.delegate = self
        photosPickerEditInfoViewController.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        photosPickerEditInfoViewController.collectionView.backgroundColor = UIColor.clear
        photosPickerEditInfoViewController.navigationBar.barTintColor = UIColor.Asset.darkGraphiteBlue
        photosPickerEditInfoViewController.navigationBar.isTranslucent = false
        photosPickerEditInfoViewController.titleLabel.font = UIFont.asset(.regular, fontSize: .overline)
        photosPickerEditInfoViewController.subTitleLabel.font = UIFont.asset(.regular, fontSize: .small)
        photosPickerEditInfoViewController.doneButton.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.asset(.bold, fontSize: .head4),
            NSAttributedString.Key.foregroundColor: UIColor.Asset.lightBlue
        ], for: .normal)
        photosPickerEditInfoViewController.cancelButton.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.asset(.regular, fontSize: .body),
            NSAttributedString.Key.foregroundColor: UIColor.Asset.lightBlue
        ], for: .normal)
        var configureEditInfo = TLPhotosPickerConfigure()
        configureEditInfo.numberOfColumn = 3
        configureEditInfo.singleSelectedMode = true
        configureEditInfo.mediaType = .image
        configureEditInfo.usedCameraButton = false
        configureEditInfo.allowedLivePhotos = false
        configureEditInfo.allowedPhotograph = false
        configureEditInfo.allowedVideo = false
        configureEditInfo.autoPlay = false
        configureEditInfo.allowedVideoRecording = false
        configureEditInfo.selectedColor = UIColor.Asset.lightBlue
        photosPickerEditInfoViewController.configure = configureEditInfo
        Utility.currentViewController().present(photosPickerEditInfoViewController, animated: true, completion: nil)
    }

    private func selectTakePhotoEditInfo() {
        self.showCameraIfAuthorizedEditInfo()
    }

    private func showCameraIfAuthorizedEditInfo() {
        let cameraAuthorization = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraAuthorization {
        case .authorized:
            self.showCameraEditInfo()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { [weak self] (authorized) in
                DispatchQueue.main.async { [weak self] in
                    if authorized {
                        self?.showCameraEditInfo()
                    } else {
                        self?.handleDeniedCameraAuthorizationEditInfo()
                    }
                }
            })
        case .restricted, .denied:
            self.handleDeniedCameraAuthorizationEditInfo()
        @unknown default:
            break
        }
    }

    private func showCameraEditInfo() {
        let pickerEditInfo = UIImagePickerController()
        pickerEditInfo.sourceType = .camera
        var mediaTypes: [String] = []
        mediaTypes.append(kUTTypeImage as String)
        guard mediaTypes.count > 0 else {
            return
        }
        pickerEditInfo.cameraDevice = .rear
        pickerEditInfo.mediaTypes = mediaTypes
        pickerEditInfo.allowsEditing = false
        pickerEditInfo.delegate = self
        Utility.currentViewController().present(pickerEditInfo, animated: true, completion: nil)
    }

    private func handleDeniedCameraAuthorizationEditInfo() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: "Denied camera permissions granted", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            Utility.currentViewController().present(alert, animated: true, completion: nil)
        }
    }

    private func presentCropViewControllerEditInfo(image: UIImage, updateImageType: UpdateImageType) {
        if updateImageType == .avatar {
            var config = Mantis.Config()
            config.cropViewConfig.cropShapeType = .circle(maskOnly: true)
            let cropViewController = Mantis.cropViewController(image: image, config: config)
            cropViewController.delegate = self
            cropViewController.modalPresentationStyle = .fullScreen
            Utility.currentViewController().present(cropViewController, animated: true)
        } else {
            let cropEditInfoController = TOCropViewController(croppingStyle: .default, image: image)
            cropEditInfoController.aspectRatioPreset = .preset16x9
            cropEditInfoController.aspectRatioLockEnabled = true
            cropEditInfoController.resetAspectRatioEnabled = false
            cropEditInfoController.aspectRatioPickerButtonHidden = true
            cropEditInfoController.delegate = self
            Utility.currentViewController().present(cropEditInfoController, animated: true, completion: nil)
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
    func didGetInfoFinish(success: Bool) {
        // Not use
    }

    func didUpdateInfoFinish(success: Bool) {
        CCLoading.shared.dismiss()
        if success {
            Utility.currentViewController().navigationController?.popViewController(animated: true)
            self.delegate?.didUpdateUserInfo(self, userInfo: self.viewModel.userInfo)
        } else {
            self.disableUI(isActive: true)
        }
    }
}

extension EditInfoTableViewCell: TLPhotosPickerViewControllerDelegate {
    func shouldDismissPhotoPicker(withTLPHAssets: [TLPHAsset]) -> Bool {
        if let asset = withTLPHAssets.first, let image = asset.fullResolutionImage {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if self.updateImageType == .avatar {
                    self.presentCropViewControllerEditInfo(image: image, updateImageType: .avatar)
                } else if self.updateImageType == .cover {
                    self.presentCropViewControllerEditInfo(image: image, updateImageType: .cover)
                }
            }
        }
        return true
    }
}

extension EditInfoTableViewCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    open func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
        picker.dismiss(animated: true, completion: {
            if self.updateImageType == .avatar {
                self.presentCropViewControllerEditInfo(image: image, updateImageType: .avatar)
            } else if self.updateImageType == .cover {
                self.presentCropViewControllerEditInfo(image: image, updateImageType: .cover)
            }
        })
    }
}

extension EditInfoTableViewCell: TOCropViewControllerDelegate {
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true, completion: {
            if self.updateImageType == .cover {
                let coverEditInfoCropImage = image.resizeImage(targetSize: CGSize.init(width: 640, height: 360))
                self.coverImage.image = coverEditInfoCropImage
                self.viewModel.cover = coverEditInfoCropImage
            }
            self.saveButton.activeButton(isActive: self.viewModel.isCanUpdateInfo())
        })
    }
}

extension EditInfoTableViewCell: CropViewControllerDelegate {
    func cropViewControllerDidCrop(_ cropViewController: Mantis.CropViewController, cropped: UIImage, transformation: Mantis.Transformation, cropInfo: Mantis.CropInfo) {
        cropViewController.dismiss(animated: true, completion: {
            if self.updateImageType == .avatar {
                let avatarEditInfoCropImage = cropped.resizeImage(targetSize: CGSize.init(width: 200, height: 200))
                self.profileImage.image = avatarEditInfoCropImage
                self.viewModel.avatar = avatarEditInfoCropImage
            }
            self.saveButton.activeButton(isActive: self.viewModel.isCanUpdateInfo())
        })
    }

    func cropViewControllerDidCancel(_ cropViewController: Mantis.CropViewController, original: UIImage) {
        cropViewController.dismiss(animated: true)
    }

    func cropViewControllerDidFailToCrop(_ cropViewController: Mantis.CropViewController, original: UIImage) {}
    func cropViewControllerDidBeginResize(_ cropViewController: Mantis.CropViewController) {}
    func cropViewControllerDidEndResize(_ cropViewController: Mantis.CropViewController, original: UIImage, cropInfo: Mantis.CropInfo) {}
}
