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
//  UpdateUserInfoTableViewCell.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 10/5/2565 BE.
//

import UIKit
import Core
import Component

public protocol UpdateUserInfoTableViewCellDelegate: AnyObject {
    func didUpdateInfo(isProcess: Bool)
}

class UpdateUserInfoTableViewCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet var updateUserInfoTitleLabel: UILabel!
    @IBOutlet var updateUserInfoSubTitleLabel: UILabel!
    @IBOutlet var updateUserInfoLinkTitleLabel: UILabel!
    @IBOutlet var updateUserInfoBirthdayTitleLabel: UILabel!
    @IBOutlet var updateUserInfoOverviewTitleLabel: UILabel!
    @IBOutlet var userOverviewTextView: UITextView!
    @IBOutlet var userBirthdayLabel: UILabel!
    @IBOutlet var userFacebookTextField: UITextField!
    @IBOutlet var userTwitterTextField: UITextField!
    @IBOutlet var userYoutubeTextField: UITextField!
    @IBOutlet var userMediumTextField: UITextField!
    @IBOutlet var userWebsiteTextField: UITextField!
    @IBOutlet var userAboutView: UIView!
    @IBOutlet var userFacebookView: UIView!
    @IBOutlet var userTwitterView: UIView!
    @IBOutlet var userYoutubeView: UIView!
    @IBOutlet var userMediumView: UIView!
    @IBOutlet var userWebsiteView: UIView!
    @IBOutlet var arrowImage: UIImageView!
    @IBOutlet var userFacebookIconView: UIView!
    @IBOutlet var userFacebookIcon: UIImageView!
    @IBOutlet var userTwitterIconView: UIView!
    @IBOutlet var userTwitterIcon: UIImageView!
    @IBOutlet var userYoutubeIconView: UIView!
    @IBOutlet var userYoutubeIcon: UIImageView!
    @IBOutlet var userMediumIconView: UIView!
    @IBOutlet var userMediumIcon: UIImageView!
    @IBOutlet var userWebsiteIconView: UIView!
    @IBOutlet var userWebsiteIcon: UIImageView!
    @IBOutlet var selectDateButton: UIButton!
    @IBOutlet var saveButton: UIButton!

    public var delegate: UpdateUserInfoTableViewCellDelegate?
    let viewModel = UpdateUserInfoViewModel()
    private var dobDate: Date?
    private var updateImageType: UpdateImageType = .none

    override func awakeFromNib() {
        super.awakeFromNib()
        self.updateUserInfoTitleLabel.font = UIFont.asset(.bold, fontSize: .head4)
        self.updateUserInfoTitleLabel.textColor = UIColor.Asset.white
        self.updateUserInfoSubTitleLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.updateUserInfoSubTitleLabel.textColor = UIColor.Asset.white
        self.updateUserInfoOverviewTitleLabel.font = UIFont.asset(.bold, fontSize: .body)
        self.updateUserInfoOverviewTitleLabel.textColor = UIColor.Asset.white
        self.userOverviewTextView.font = UIFont.asset(.regular, fontSize: .body)
        self.userOverviewTextView.textColor = UIColor.Asset.white
        self.updateUserInfoBirthdayTitleLabel.font = UIFont.asset(.bold, fontSize: .body)
        self.updateUserInfoBirthdayTitleLabel.textColor = UIColor.Asset.white
        self.userBirthdayLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.userBirthdayLabel.textColor = UIColor.Asset.lightBlue
        self.updateUserInfoLinkTitleLabel.font = UIFont.asset(.bold, fontSize: .body)
        self.updateUserInfoLinkTitleLabel.textColor = UIColor.Asset.white
        self.userFacebookTextField.font = UIFont.asset(.regular, fontSize: .body)
        self.userFacebookTextField.textColor = UIColor.Asset.white
        self.userTwitterTextField.font = UIFont.asset(.regular, fontSize: .body)
        self.userTwitterTextField.textColor = UIColor.Asset.white
        self.userYoutubeTextField.font = UIFont.asset(.regular, fontSize: .body)
        self.userYoutubeTextField.textColor = UIColor.Asset.white
        self.userMediumTextField.font = UIFont.asset(.regular, fontSize: .body)
        self.userMediumTextField.textColor = UIColor.Asset.white
        self.userWebsiteTextField.font = UIFont.asset(.regular, fontSize: .body)
        self.userWebsiteTextField.textColor = UIColor.Asset.white
        self.userAboutView.custom(color: UIColor.Asset.cellBackground, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.userFacebookView.custom(color: UIColor.Asset.cellBackground, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.userTwitterView.custom(color: UIColor.Asset.cellBackground, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.userYoutubeView.custom(color: UIColor.Asset.cellBackground, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.userMediumView.custom(color: UIColor.Asset.cellBackground, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.userWebsiteView.custom(color: UIColor.Asset.cellBackground, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.arrowImage.image = UIImage.init(icon: .castcle(.next), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white)
        self.userFacebookIconView.capsule(color: UIColor.Asset.facebook)
        self.userFacebookIcon.image = UIImage.init(icon: .castcle(.facebook), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
        self.userTwitterIconView.capsule(color: UIColor.Asset.twitter)
        self.userTwitterIcon.image = UIImage.init(icon: .castcle(.twitter), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
        self.userYoutubeIconView.capsule(color: UIColor.Asset.white)
        self.userYoutubeIcon.image = UIImage.init(icon: .castcle(.youtubeBold), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.denger)
        self.userMediumIconView.capsule(color: UIColor.Asset.white)
        self.userMediumIcon.image = UIImage.init(icon: .castcle(.medium), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.black)
        self.userWebsiteIconView.capsule(color: UIColor.Asset.white)
        self.userWebsiteIcon.image = UIImage.init(icon: .castcle(.others), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.lightBlue)

        self.userOverviewTextView.delegate = self
        self.userOverviewTextView.placeholder = "Write something to introduce yourself!"
        self.saveButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .head4)
        self.saveButton.setTitleColor(UIColor.Asset.white, for: .normal)
        self.saveButton.capsule(color: UIColor.Asset.lightBlue, borderWidth: 1, borderColor: UIColor.Asset.lightBlue)
        self.viewModel.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func selectDateAction(_ sender: Any) {
        let viewController = ComponentOpener.open(.datePicker) as? DatePickerViewController
        viewController?.initDate = self.dobDate
        viewController?.delegate = self
        Utility.currentViewController().presentPanModal(viewController ?? DatePickerViewController())
    }

    @IBAction func saveAction(_ sender: Any) {
        CCLoading.shared.show(text: "Saving")
        self.delegate?.didUpdateInfo(isProcess: true)
        self.viewModel.userRequest.payload.overview = self.userOverviewTextView.text ?? ""
        self.viewModel.userRequest.payload.links.facebook = (self.userFacebookTextField.text! == UrlProtocol.https.value ? "" : self.userFacebookTextField.text!.toUrlString)
        self.viewModel.userRequest.payload.links.twitter = (self.userTwitterTextField.text! == UrlProtocol.https.value ? "" : self.userTwitterTextField.text!.toUrlString)
        self.viewModel.userRequest.payload.links.youtube = (self.userYoutubeTextField.text! == UrlProtocol.https.value ? "" : self.userYoutubeTextField.text!.toUrlString)
        self.viewModel.userRequest.payload.links.medium = (self.userMediumTextField.text! == UrlProtocol.https.value ? "" : self.userMediumTextField.text!.toUrlString)
        self.viewModel.userRequest.payload.links.website = (self.userWebsiteTextField.text! == UrlProtocol.https.value ? "" : self.userWebsiteTextField.text!.toUrlString)
        self.viewModel.updateProfile()
    }
}

extension UpdateUserInfoTableViewCell: DatePickerViewControllerDelegate {
    func datePickerViewController(_ view: DatePickerViewController, didSelectDate date: Date, displayDate: String) {
        self.viewModel.dobDate = date
        self.userBirthdayLabel.text = displayDate
    }
}

extension UpdateUserInfoTableViewCell: UpdateUserInfoViewModelDelegate {
    func didUpdateInfoFinish(success: Bool) {
        CCLoading.shared.dismiss()
        if success {
            Utility.currentViewController().view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        } else {
            self.delegate?.didUpdateInfo(isProcess: false)
        }
    }
}
