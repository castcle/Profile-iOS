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
import JGProgressHUD

public protocol UpdateUserInfoTableViewCellDelegate: AnyObject {
    func didUpdateInfo(isProcess: Bool)
}

class UpdateUserInfoTableViewCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var linkTitleLabel: UILabel!
    @IBOutlet var overviewLabel: UILabel!
    @IBOutlet var overviewTextView: UITextView!
    @IBOutlet var birthdayTitleLabel: UILabel!
    @IBOutlet var birthdayLabel: UILabel!
    @IBOutlet var facebookTextField: UITextField!
    @IBOutlet var twitterTextField: UITextField!
    @IBOutlet var youtubeTextField: UITextField!
    @IBOutlet var mediumTextField: UITextField!
    @IBOutlet var websiteTextField: UITextField!
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

    public var delegate: UpdateUserInfoTableViewCellDelegate?
    let viewModel = UpdateUserInfoViewModel()
    let hud = JGProgressHUD()
    private var dobDate: Date?
    private var updateImageType: UpdateImageType = .none

    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.font = UIFont.asset(.bold, fontSize: .head4)
        self.titleLabel.textColor = UIColor.Asset.white
        self.subTitleLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.subTitleLabel.textColor = UIColor.Asset.white
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
        self.websiteIcon.image = UIImage.init(icon: .castcle(.link), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.lightBlue)

        self.hud.textLabel.text = "Saving"
        self.overviewTextView.delegate = self
        self.overviewTextView.placeholder = "Write something to introduce yourself!"
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
        self.hud.show(in: Utility.currentViewController().view)
        self.delegate?.didUpdateInfo(isProcess: true)
        self.viewModel.userRequest.payload.overview = self.overviewTextView.text ?? ""
        self.viewModel.userRequest.payload.links.facebook = (self.facebookTextField.text! == "https://" ? "" : self.facebookTextField.text!)
        self.viewModel.userRequest.payload.links.twitter = (self.twitterTextField.text! == "https://" ? "" : self.twitterTextField.text!)
        self.viewModel.userRequest.payload.links.youtube = (self.youtubeTextField.text! == "https://" ? "" : self.youtubeTextField.text!)
        self.viewModel.userRequest.payload.links.medium = (self.mediumTextField.text! == "https://" ? "" : self.mediumTextField.text!)
        self.viewModel.userRequest.payload.links.website = (self.websiteTextField.text! == "https://" ? "" : self.websiteTextField.text!)
        self.viewModel.updateProfile()
    }
}

extension UpdateUserInfoTableViewCell: DatePickerViewControllerDelegate {
    func datePickerViewController(_ view: DatePickerViewController, didSelectDate date: Date, displayDate: String) {
        self.viewModel.dobDate = date
        self.birthdayLabel.text = displayDate
    }
}

extension UpdateUserInfoTableViewCell: UpdateUserInfoViewModelDelegate {
    func didUpdateInfoFinish(success: Bool) {
        self.hud.dismiss()
        if success {
            Utility.currentViewController().view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        } else {
            self.delegate?.didUpdateInfo(isProcess: false)
        }
    }
}
