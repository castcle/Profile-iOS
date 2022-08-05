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
//  EditPageInfoTableViewCell.swift
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
import JGProgressHUD
import TOCropViewController
import TLPhotoPicker

protocol EditPageInfoTableViewCellDelegate: AnyObject {
    func didUpdatePageInfo(_ cell: EditPageInfoTableViewCell, userInfo: UserInfo)
}

class EditPageInfoTableViewCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet var pageCoverImage: UIImageView!
    @IBOutlet var pageAvatarImage: UIImageView!
    @IBOutlet var editPageCoverButton: UIButton!
    @IBOutlet var editPageAvaterButton: UIButton!
    @IBOutlet var pageCastcleIdLabel: UILabel!
    @IBOutlet var pageCastcleIdNoticeLabel: UILabel!
    @IBOutlet var prefixLabel: UILabel!
    @IBOutlet var pageDisplayNameLabel: UILabel!
    @IBOutlet var pageLinkTitleLabel: UILabel!
    @IBOutlet var pageOverviewLabel: UILabel!
    @IBOutlet var pageOverviewTextView: UITextView!
    @IBOutlet var pageCastcleIdTextField: UITextField!
    @IBOutlet var pageDisplayNameTextField: UITextField!
    @IBOutlet var pageFacebookTextField: UITextField!
    @IBOutlet var pageTwitterTextField: UITextField!
    @IBOutlet var pageYoutubeTextField: UITextField!
    @IBOutlet var pageMediumTextField: UITextField!
    @IBOutlet var pageWebsiteTextField: UITextField!
    @IBOutlet var pageCastcleIdView: UIView!
    @IBOutlet var pageDisplayNameView: UIView!
    @IBOutlet var pageAboutView: UIView!
    @IBOutlet var pageFacebookView: UIView!
    @IBOutlet var pageTwitterView: UIView!
    @IBOutlet var pageYoutubeView: UIView!
    @IBOutlet var pageMediumView: UIView!
    @IBOutlet var pageWebsiteView: UIView!
    @IBOutlet var pagePageInfoTitleLabel: UILabel!
    @IBOutlet var pageEmailTitleLabel: UILabel!
    @IBOutlet var pagePhoneTitleLabel: UILabel!
    @IBOutlet var pageEmailLabel: UILabel!
    @IBOutlet var pagePhoneLabel: UILabel!
    @IBOutlet var pageEmailIcon: UIImageView!
    @IBOutlet var pagePhoneIcon: UIImageView!
    @IBOutlet var pageFacebookIconView: UIView!
    @IBOutlet var pageFacebookIcon: UIImageView!
    @IBOutlet var pageTwitterIconView: UIView!
    @IBOutlet var pageTwitterIcon: UIImageView!
    @IBOutlet var pageYoutubeIconView: UIView!
    @IBOutlet var pageYoutubeIcon: UIImageView!
    @IBOutlet var pageMediumIconView: UIView!
    @IBOutlet var pageMediumIcon: UIImageView!
    @IBOutlet var pageWebsiteIconView: UIView!
    @IBOutlet var pageWebsiteIcon: UIImageView!
    @IBOutlet var saveButton: UIButton!

    var delegate: EditPageInfoTableViewCellDelegate?
    let viewModel = EditInfoViewModel()
    let hud = JGProgressHUD()
    private var updateImageType: UpdateImageType = .none

    override func awakeFromNib() {
        super.awakeFromNib()
        self.pageAvatarImage.circle(color: UIColor.Asset.white)
        self.editPageAvaterButton.setImage(UIImage.init(icon: .castcle(.camera), size: CGSize(width: 15, height: 15), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        self.editPageAvaterButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
        self.editPageAvaterButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.Asset.white)
        self.editPageCoverButton.setImage(UIImage.init(icon: .castcle(.camera), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        self.editPageCoverButton.setBackgroundImage(UIColor.Asset.gray.toImage(), for: .normal)
        self.editPageCoverButton.capsule()
        self.pageCastcleIdLabel.font = UIFont.asset(.bold, fontSize: .body)
        self.pageCastcleIdLabel.textColor = UIColor.Asset.white
        self.pageCastcleIdNoticeLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.pageCastcleIdNoticeLabel.textColor = UIColor.Asset.white
        self.prefixLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.prefixLabel.textColor = UIColor.Asset.lightGray
        self.pageDisplayNameLabel.font = UIFont.asset(.bold, fontSize: .body)
        self.pageDisplayNameLabel.textColor = UIColor.Asset.white
        self.pageOverviewLabel.font = UIFont.asset(.bold, fontSize: .body)
        self.pageOverviewLabel.textColor = UIColor.Asset.white
        self.pageOverviewTextView.font = UIFont.asset(.regular, fontSize: .body)
        self.pageOverviewTextView.textColor = UIColor.Asset.white
        self.pageLinkTitleLabel.font = UIFont.asset(.bold, fontSize: .body)
        self.pageLinkTitleLabel.textColor = UIColor.Asset.white
        self.pagePageInfoTitleLabel.textColor = UIColor.Asset.lightGray
        self.pagePageInfoTitleLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.pageEmailTitleLabel.textColor = UIColor.Asset.white
        self.pageEmailTitleLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.pagePhoneTitleLabel.textColor = UIColor.Asset.white
        self.pagePhoneTitleLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.pageEmailLabel.textColor = UIColor.Asset.lightGray
        self.pageEmailLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.pagePhoneLabel.textColor = UIColor.Asset.lightGray
        self.pagePhoneLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.pageEmailIcon.image = UIImage.init(icon: .castcle(.next), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white)
        self.pagePhoneIcon.image = UIImage.init(icon: .castcle(.next), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white)
        self.pageCastcleIdTextField.font = UIFont.asset(.regular, fontSize: .body)
        self.pageCastcleIdTextField.textColor = UIColor.Asset.white
        self.pageDisplayNameTextField.font = UIFont.asset(.regular, fontSize: .body)
        self.pageDisplayNameTextField.textColor = UIColor.Asset.white
        self.pageFacebookTextField.font = UIFont.asset(.regular, fontSize: .body)
        self.pageFacebookTextField.textColor = UIColor.Asset.white
        self.pageTwitterTextField.font = UIFont.asset(.regular, fontSize: .body)
        self.pageTwitterTextField.textColor = UIColor.Asset.white
        self.pageYoutubeTextField.font = UIFont.asset(.regular, fontSize: .body)
        self.pageYoutubeTextField.textColor = UIColor.Asset.white
        self.pageMediumTextField.font = UIFont.asset(.regular, fontSize: .body)
        self.pageMediumTextField.textColor = UIColor.Asset.white
        self.pageWebsiteTextField.font = UIFont.asset(.regular, fontSize: .body)
        self.pageWebsiteTextField.textColor = UIColor.Asset.white
        self.pageCastcleIdView.custom(color: UIColor.Asset.cellBackground, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.pageDisplayNameView.custom(color: UIColor.Asset.cellBackground, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.pageAboutView.custom(color: UIColor.Asset.cellBackground, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.pageFacebookView.custom(color: UIColor.Asset.cellBackground, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.pageTwitterView.custom(color: UIColor.Asset.cellBackground, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.pageYoutubeView.custom(color: UIColor.Asset.cellBackground, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.pageMediumView.custom(color: UIColor.Asset.cellBackground, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.pageWebsiteView.custom(color: UIColor.Asset.cellBackground, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.pageFacebookIconView.capsule(color: UIColor.Asset.facebook)
        self.pageFacebookIcon.image = UIImage.init(icon: .castcle(.facebook), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
        self.pageTwitterIconView.capsule(color: UIColor.Asset.twitter)
        self.pageTwitterIcon.image = UIImage.init(icon: .castcle(.twitter), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
        self.pageYoutubeIconView.capsule(color: UIColor.Asset.white)
        self.pageYoutubeIcon.image = UIImage.init(icon: .castcle(.youtubeBold), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.denger)
        self.pageMediumIconView.capsule(color: UIColor.Asset.white)
        self.pageMediumIcon.image = UIImage.init(icon: .castcle(.medium), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.black)
        self.pageWebsiteIconView.capsule(color: UIColor.Asset.white)
        self.pageWebsiteIcon.image = UIImage.init(icon: .castcle(.others), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.lightBlue)

        self.hud.textLabel.text = "Saving"
        self.pageOverviewTextView.delegate = self
        self.pageOverviewTextView.placeholder = "Write something to introduce yourself!"
        self.saveButton.setTitle("Save", for: .normal)
        self.saveButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .head4)
        self.saveButton.setTitleColor(UIColor.Asset.white, for: .normal)
        self.saveButton.capsule(color: UIColor.Asset.lightBlue, borderWidth: 1, borderColor: UIColor.Asset.lightBlue)
        self.viewModel.delegate = self
        self.pageCastcleIdTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configCell(userInfo: UserInfo) {
        self.viewModel.userInfo = userInfo
        self.mappingData()
        self.updateUI()
    }

    private func mappingData() {
        self.pageOverviewTextView.text = self.viewModel.userInfo.overview
        self.pageFacebookTextField.text = (self.viewModel.userInfo.links.facebook.isEmpty ? UrlProtocol.https.value : self.viewModel.userInfo.links.facebook)
        self.pageTwitterTextField.text = (self.viewModel.userInfo.links.twitter.isEmpty ? UrlProtocol.https.value : self.viewModel.userInfo.links.twitter)
        self.pageYoutubeTextField.text = (self.viewModel.userInfo.links.youtube.isEmpty ? UrlProtocol.https.value : self.viewModel.userInfo.links.youtube)
        self.pageMediumTextField.text = (self.viewModel.userInfo.links.medium.isEmpty ? UrlProtocol.https.value : self.viewModel.userInfo.links.medium)
        self.pageWebsiteTextField.text = (self.viewModel.userInfo.links.website.isEmpty ? UrlProtocol.https.value : self.viewModel.userInfo.links.website)
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        if textField.tag == 0 {
            let displayCastcleId = textField.text ?? ""
            textField.text = displayCastcleId.toRawCastcleId
        }
    }

    private func updateUI() {
        if let avatar = self.viewModel.avatar {
            self.pageAvatarImage.image = avatar
        } else {
            let url = URL(string: self.viewModel.userInfo.images.avatar.thumbnail)
            self.pageAvatarImage.kf.setImage(with: url, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
        }

        if let cover = self.viewModel.cover {
            self.pageCoverImage.image = cover
        } else {
            let url = URL(string: self.viewModel.userInfo.images.cover.fullHd)
            self.pageCoverImage.kf.setImage(with: url, placeholder: UIImage.Asset.placeholder, options: [.transition(.fade(0.35))])
        }

        self.pageCastcleIdTextField.text = self.viewModel.userInfo.castcleId.toRawCastcleId
        self.pageDisplayNameTextField.text = self.viewModel.userInfo.displayName
        if self.viewModel.userInfo.canUpdateCastcleId {
            self.pageCastcleIdNoticeLabel.text = ""
            self.pageCastcleIdTextField.isEnabled = true
        } else {
            self.pageCastcleIdNoticeLabel.text = "Once your Castcle ID has been changed, you can edit it again after 60 days."
            self.pageCastcleIdTextField.isEnabled = false
        }

        if self.viewModel.userInfo.contact.email.isEmpty {
            self.pageEmailLabel.textColor = UIColor.Asset.lightGray
            self.pageEmailLabel.text = "None"
        } else {
            self.pageEmailLabel.textColor = UIColor.Asset.lightBlue
            self.pageEmailLabel.text = self.viewModel.userInfo.contact.email
        }

        if self.viewModel.userInfo.contact.phone.isEmpty {
            self.pagePhoneLabel.textColor = UIColor.Asset.lightGray
            self.pagePhoneLabel.text = "None"
        } else {
            self.pagePhoneLabel.textColor = UIColor.Asset.lightBlue
            self.pagePhoneLabel.text = "\(self.viewModel.userInfo.contact.countryCode.isEmpty ? "(+66)" : "(\(self.viewModel.userInfo.contact.countryCode)")) \(self.viewModel.userInfo.contact.phone)"
        }
    }

    private func disableUI(isActive: Bool) {
        if isActive {
            self.pageOverviewTextView.isEditable = true
            self.pageFacebookTextField.isEnabled = true
            self.pageTwitterTextField.isEnabled = true
            self.pageYoutubeTextField.isEnabled = true
            self.pageMediumTextField.isEnabled = true
            self.pageWebsiteTextField.isEnabled = true
        } else {
            self.pageOverviewTextView.isEditable = false
            self.pageFacebookTextField.isEnabled = false
            self.pageTwitterTextField.isEnabled = false
            self.pageYoutubeTextField.isEnabled = false
            self.pageMediumTextField.isEnabled = false
            self.pageWebsiteTextField.isEnabled = false
        }
    }

    @IBAction func updateEmailAction(_ sender: Any) {
        let viewController = ProfileOpener.open(.contactEmail(EditInfoViewModel(profileType: self.viewModel.profileType, userInfo: self.viewModel.userInfo))) as? ContactEmailViewController
        viewController?.delegate = self
        Utility.currentViewController().navigationController?.pushViewController(viewController ?? ContactEmailViewController(), animated: true)
    }

    @IBAction func updatePhoneAction(_ sender: Any) {
        let viewController = ProfileOpener.open(.contactPhone(EditInfoViewModel(profileType: self.viewModel.profileType, userInfo: self.viewModel.userInfo))) as? ContactPhoneViewController
        viewController?.delegate = self
        Utility.currentViewController().navigationController?.pushViewController(viewController ?? ContactPhoneViewController(), animated: true)
    }

    @IBAction func saveAction(_ sender: Any) {
        guard (self.pageCastcleIdTextField.text!).trimmingCharacters(in: .whitespacesAndNewlines).toCastcleId.isCastcleId else {
            ApiHelper.displayError(error: "Castcle ID cannot contain special characters")
            return
        }
        self.hud.show(in: Utility.currentViewController().view)
        self.disableUI(isActive: false)

        if self.viewModel.userInfo.canUpdateCastcleId && ((self.pageCastcleIdTextField.text!).trimmingCharacters(in: .whitespacesAndNewlines).toCastcleId != self.viewModel.userInfo.castcleId) {
            self.viewModel.userRequest.payload.castcleId = (self.pageCastcleIdTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).toCastcleId
        }
        if (self.pageDisplayNameTextField.text!).trimmingCharacters(in: .whitespacesAndNewlines) != self.viewModel.userInfo.displayName {
            self.viewModel.userRequest.payload.displayName = (self.pageDisplayNameTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        }
        self.viewModel.userRequest.payload.overview = self.pageOverviewTextView.text ?? ""
        self.viewModel.userRequest.payload.links.facebook = (self.pageFacebookTextField.text! == UrlProtocol.https.value ? "" : self.pageFacebookTextField.text!.toUrlString)
        self.viewModel.userRequest.payload.links.twitter = (self.pageTwitterTextField.text! == UrlProtocol.https.value ? "" : self.pageTwitterTextField.text!.toUrlString)
        self.viewModel.userRequest.payload.links.youtube = (self.pageYoutubeTextField.text! == UrlProtocol.https.value ? "" : self.pageYoutubeTextField.text!.toUrlString)
        self.viewModel.userRequest.payload.links.medium = (self.pageMediumTextField.text! == UrlProtocol.https.value ? "" : self.pageMediumTextField.text!.toUrlString)
        self.viewModel.userRequest.payload.links.website = (self.pageWebsiteTextField.text! == UrlProtocol.https.value ? "" : self.pageWebsiteTextField.text!.toUrlString)
        self.viewModel.updateProfile(isPage: true, castcleId: self.viewModel.userInfo.castcleId)
    }

    @IBAction func editCoverAction(_ sender: Any) {
        self.updateImageType = .cover
        self.selectImageSourcePageInfo()
    }

    @IBAction func editProfileImageAction(_ sender: Any) {
        self.updateImageType = .avatar
        self.selectImageSourcePageInfo()
    }

    private func selectImageSourcePageInfo() {
        let actionSheet = CCActionSheet()
        let albumButton = CCAction(title: "Choose from Camera Roll", image: UIImage.init(icon: .castcle(.image), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white), style: .normal) {
            actionSheet.dismissActionSheet()
            self.selectCameraRollPageInfo()
        }
        let cameraButton = CCAction(title: "Take Photo", image: UIImage.init(icon: .castcle(.camera), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white), style: .normal) {
            actionSheet.dismissActionSheet()
            self.selectTakePhotoPageInfo()
        }
        actionSheet.addActions([albumButton, cameraButton])
        Utility.currentViewController().present(actionSheet, animated: true, completion: nil)
    }

    private func selectCameraRollPageInfo() {
        let photosPickerPageInfoViewController = TLPhotosPickerViewController()
        photosPickerPageInfoViewController.delegate = self
        photosPickerPageInfoViewController.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        photosPickerPageInfoViewController.collectionView.backgroundColor = UIColor.clear
        photosPickerPageInfoViewController.navigationBar.barTintColor = UIColor.Asset.darkGraphiteBlue
        photosPickerPageInfoViewController.navigationBar.isTranslucent = false
        photosPickerPageInfoViewController.titleLabel.font = UIFont.asset(.regular, fontSize: .overline)
        photosPickerPageInfoViewController.subTitleLabel.font = UIFont.asset(.regular, fontSize: .small)
        photosPickerPageInfoViewController.doneButton.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.asset(.bold, fontSize: .head4),
            NSAttributedString.Key.foregroundColor: UIColor.Asset.lightBlue
        ], for: .normal)
        photosPickerPageInfoViewController.cancelButton.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.asset(.regular, fontSize: .body),
            NSAttributedString.Key.foregroundColor: UIColor.Asset.lightBlue
        ], for: .normal)

        var configurePageInfo = TLPhotosPickerConfigure()
        configurePageInfo.numberOfColumn = 3
        configurePageInfo.singleSelectedMode = true
        configurePageInfo.mediaType = .image
        configurePageInfo.usedCameraButton = false
        configurePageInfo.allowedLivePhotos = false
        configurePageInfo.allowedPhotograph = false
        configurePageInfo.allowedVideo = false
        configurePageInfo.autoPlay = false
        configurePageInfo.allowedVideoRecording = false
        configurePageInfo.selectedColor = UIColor.Asset.lightBlue
        photosPickerPageInfoViewController.configure = configurePageInfo
        Utility.currentViewController().present(photosPickerPageInfoViewController, animated: true, completion: nil)
    }

    private func selectTakePhotoPageInfo() {
        self.showCameraIfAuthorizedPageInfo()
    }

    private func showCameraIfAuthorizedPageInfo() {
        let cameraAuthorization = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraAuthorization {
        case .authorized:
            self.showCameraPageInfo()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { [weak self] (authorized) in
                DispatchQueue.main.async { [weak self] in
                    if authorized {
                        self?.showCameraPageInfo()
                    } else {
                        self?.handleDeniedCameraAuthorizationPageInfo()
                    }
                }
            })
        case .restricted, .denied:
            self.handleDeniedCameraAuthorizationPageInfo()
        @unknown default:
            break
        }
    }

    private func showCameraPageInfo() {
        let pickerPageInfo = UIImagePickerController()
        pickerPageInfo.sourceType = .camera
        var mediaTypes: [String] = []
        mediaTypes.append(kUTTypeImage as String)
        guard mediaTypes.count > 0 else {
            return
        }
        pickerPageInfo.cameraDevice = .rear
        pickerPageInfo.mediaTypes = mediaTypes
        pickerPageInfo.allowsEditing = false
        pickerPageInfo.delegate = self
        Utility.currentViewController().present(pickerPageInfo, animated: true, completion: nil)
    }

    private func handleDeniedCameraAuthorizationPageInfo() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: "Denied camera permissions granted", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            Utility.currentViewController().present(alert, animated: true, completion: nil)
        }
    }

    private func presentCropViewControllerPageInfo(image: UIImage, updateImageType: UpdateImageType) {
        if updateImageType == .avatar {
            let cropPageInfoController = TOCropViewController(croppingStyle: .circular, image: image)
            cropPageInfoController.delegate = self
            Utility.currentViewController().present(cropPageInfoController, animated: true, completion: nil)
        } else {
            let cropPageInfoController = TOCropViewController(croppingStyle: .default, image: image)
            cropPageInfoController.aspectRatioPreset = .preset4x3
            cropPageInfoController.aspectRatioLockEnabled = true
            cropPageInfoController.resetAspectRatioEnabled = false
            cropPageInfoController.aspectRatioPickerButtonHidden = true
            cropPageInfoController.delegate = self
            Utility.currentViewController().present(cropPageInfoController, animated: true, completion: nil)
        }
    }
}

extension EditPageInfoTableViewCell: EditInfoViewModelDelegate {
    func didGetInfoFinish(success: Bool) {
        // Not use
    }

    func didUpdateInfoFinish(success: Bool) {
        self.hud.dismiss()
        if success {
            Utility.currentViewController().navigationController?.popViewController(animated: true)
            self.delegate?.didUpdatePageInfo(self, userInfo: self.viewModel.userInfo)
        } else {
            self.disableUI(isActive: true)
        }
    }
}

extension EditPageInfoTableViewCell: TLPhotosPickerViewControllerDelegate {
    func shouldDismissPhotoPicker(withTLPHAssets: [TLPHAsset]) -> Bool {
        if let asset = withTLPHAssets.first, let image = asset.fullResolutionImage {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if self.updateImageType == .avatar {
                    self.presentCropViewControllerPageInfo(image: image, updateImageType: .avatar)
                } else if self.updateImageType == .cover {
                    self.presentCropViewControllerPageInfo(image: image, updateImageType: .cover)
                }
            }
        }
        return true
    }
}

extension EditPageInfoTableViewCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    open func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
        picker.dismiss(animated: true, completion: {
            if self.updateImageType == .avatar {
                self.presentCropViewControllerPageInfo(image: image, updateImageType: .avatar)
            } else if self.updateImageType == .cover {
                self.presentCropViewControllerPageInfo(image: image, updateImageType: .cover)
            }
        })
    }
}

extension EditPageInfoTableViewCell: TOCropViewControllerDelegate {
    func cropViewController(_ cropViewController: TOCropViewController, didCropToCircularImage image: UIImage, with cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true, completion: {
            if self.updateImageType == .avatar {
                let avatarPageInfoCropImage = image.resizeImage(targetSize: CGSize.init(width: 200, height: 200))
                self.pageAvatarImage.image = avatarPageInfoCropImage
                self.viewModel.avatar = avatarPageInfoCropImage
            }
        })
    }

    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true, completion: {
            if self.updateImageType == .cover {
                let coverPageInfoCropImage = image.resizeImage(targetSize: CGSize.init(width: 640, height: 480))
                self.pageCoverImage.image = coverPageInfoCropImage
                self.viewModel.cover = coverPageInfoCropImage
            }
        })
    }
}

extension EditPageInfoTableViewCell: ContactEmailViewControllerDelegate {
    func didChangeEmail(_ contactEmailViewController: ContactEmailViewController, email: String) {
        self.viewModel.userInfo.contact.email = email
        self.pageEmailLabel.textColor = UIColor.Asset.lightBlue
        self.pageEmailLabel.text = self.viewModel.userInfo.contact.email
    }
}

extension EditPageInfoTableViewCell: ContactPhoneViewControllerDelegate {
    func didChangePhone(_ contactPhoneViewController: ContactPhoneViewController, phone: String, countryCode: String) {
        self.viewModel.userInfo.contact.phone = phone
        self.viewModel.userInfo.contact.countryCode = countryCode
        self.pagePhoneLabel.textColor = UIColor.Asset.lightBlue
        self.pagePhoneLabel.text = "\(self.viewModel.userInfo.contact.countryCode.isEmpty ? "(+66)" : "(\(self.viewModel.userInfo.contact.countryCode)")) \(self.viewModel.userInfo.contact.phone)"
    }
}
