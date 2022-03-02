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
import Core
import Component
import JVFloatLabeledTextField
import UITextView_Placeholder
import PanModal
import Defaults
import JGProgressHUD

class EditInfoTableViewCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet var headlineLabel: UILabel!
    @IBOutlet var overviewLabel: UILabel!
    @IBOutlet var birthdayLabel: UILabel!
    @IBOutlet var overviewTextView: UITextView!
    @IBOutlet var birthdayTextField: JVFloatLabeledTextField! {
        didSet {
            self.birthdayTextField.font = UIFont.asset(.regular, fontSize: .body)
            self.birthdayTextField.placeholder = "Date"
            self.birthdayTextField.placeholderColor = UIColor.Asset.gray
            self.birthdayTextField.floatingLabelTextColor = UIColor.Asset.gray
            self.birthdayTextField.floatingLabelActiveTextColor = UIColor.Asset.gray
            self.birthdayTextField.floatingLabelFont = UIFont.asset(.regular, fontSize: .small)
            self.birthdayTextField.textColor = UIColor.Asset.white
        }
    }
    @IBOutlet var arrowImage: UIImageView!
    @IBOutlet var aboutView: UIView!
    @IBOutlet var birthdayView: UIView!
    
    @IBOutlet var linkTitleLabel: UILabel!
    
    @IBOutlet var facebookView: UIView!
    @IBOutlet var twitterView: UIView!
    @IBOutlet var youtubeView: UIView!
    @IBOutlet var mediumView: UIView!
    @IBOutlet var websiteView: UIView!
    @IBOutlet var facebookTextField: JVFloatLabeledTextField! {
        didSet {
            self.facebookTextField.font = UIFont.asset(.regular, fontSize: .body)
            self.facebookTextField.placeholder = "Facebook"
            self.facebookTextField.placeholderColor = UIColor.Asset.gray
            self.facebookTextField.floatingLabelTextColor = UIColor.Asset.gray
            self.facebookTextField.floatingLabelActiveTextColor = UIColor.Asset.gray
            self.facebookTextField.floatingLabelFont = UIFont.asset(.regular, fontSize: .small)
            self.facebookTextField.textColor = UIColor.Asset.white
        }
    }
    @IBOutlet var twitterTextField: JVFloatLabeledTextField! {
        didSet {
            self.twitterTextField.font = UIFont.asset(.regular, fontSize: .body)
            self.twitterTextField.placeholder = "Twitter"
            self.twitterTextField.placeholderColor = UIColor.Asset.gray
            self.twitterTextField.floatingLabelTextColor = UIColor.Asset.gray
            self.twitterTextField.floatingLabelActiveTextColor = UIColor.Asset.gray
            self.twitterTextField.floatingLabelFont = UIFont.asset(.regular, fontSize: .small)
            self.twitterTextField.textColor = UIColor.Asset.white
        }
    }
    @IBOutlet var youtubeTextField: JVFloatLabeledTextField! {
        didSet {
            self.youtubeTextField.font = UIFont.asset(.regular, fontSize: .body)
            self.youtubeTextField.placeholder = "Youtube"
            self.youtubeTextField.placeholderColor = UIColor.Asset.gray
            self.youtubeTextField.floatingLabelTextColor = UIColor.Asset.gray
            self.youtubeTextField.floatingLabelActiveTextColor = UIColor.Asset.gray
            self.youtubeTextField.floatingLabelFont = UIFont.asset(.regular, fontSize: .small)
            self.youtubeTextField.textColor = UIColor.Asset.white
        }
    }
    @IBOutlet var mediumTextField: JVFloatLabeledTextField! {
        didSet {
            self.mediumTextField.font = UIFont.asset(.regular, fontSize: .body)
            self.mediumTextField.placeholder = "Medium"
            self.mediumTextField.placeholderColor = UIColor.Asset.gray
            self.mediumTextField.floatingLabelTextColor = UIColor.Asset.gray
            self.mediumTextField.floatingLabelActiveTextColor = UIColor.Asset.gray
            self.mediumTextField.floatingLabelFont = UIFont.asset(.regular, fontSize: .small)
            self.mediumTextField.textColor = UIColor.Asset.white
        }
    }
    @IBOutlet var websiteTextField: JVFloatLabeledTextField! {
        didSet {
            self.websiteTextField.font = UIFont.asset(.regular, fontSize: .body)
            self.websiteTextField.placeholder = "Add website"
            self.websiteTextField.placeholderColor = UIColor.Asset.gray
            self.websiteTextField.floatingLabelTextColor = UIColor.Asset.gray
            self.websiteTextField.floatingLabelActiveTextColor = UIColor.Asset.gray
            self.websiteTextField.floatingLabelFont = UIFont.asset(.regular, fontSize: .small)
            self.websiteTextField.textColor = UIColor.Asset.white
        }
    }
    
    @IBOutlet var selectDateButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    
    let viewModel = EditProfileViewModel()
    let hud = JGProgressHUD()
    private var dobDate: Date? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.hud.textLabel.text = "Saving"
        self.aboutView.custom(color: UIColor.Asset.darkGray, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.birthdayView.custom(color: UIColor.Asset.darkGray, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.headlineLabel.font = UIFont.asset(.regular, fontSize: .title)
        self.headlineLabel.textColor = UIColor.Asset.white
        self.overviewLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.overviewLabel.textColor = UIColor.Asset.white
        self.birthdayLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.birthdayLabel.textColor = UIColor.Asset.white
        
        self.overviewTextView.delegate = self
        self.overviewTextView.placeholder = "What's make you different?"
        self.overviewTextView.text = UserManager.shared.overview
        
        self.linkTitleLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.linkTitleLabel.textColor = UIColor.Asset.white
        
        self.facebookView.custom(color: UIColor.Asset.darkGray, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.twitterView.custom(color: UIColor.Asset.darkGray, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.youtubeView.custom(color: UIColor.Asset.darkGray, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.mediumView.custom(color: UIColor.Asset.darkGray, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.websiteView.custom(color: UIColor.Asset.darkGray, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        
        self.facebookTextField.text = (UserManager.shared.facebookLink.isEmpty ? "https://" : UserManager.shared.facebookLink)
        self.twitterTextField.text = (UserManager.shared.twitterLink.isEmpty ? "https://" : UserManager.shared.twitterLink)
        self.youtubeTextField.text = (UserManager.shared.youtubeLink.isEmpty ? "https://" : UserManager.shared.youtubeLink)
        self.mediumTextField.text = (UserManager.shared.mediumLink.isEmpty ? "https://" : UserManager.shared.mediumLink)
        self.websiteTextField.text = (UserManager.shared.websiteLink.isEmpty ? "https://" : UserManager.shared.websiteLink)
        
        self.saveButton.setTitle("Save", for: .normal)
        self.saveButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .h4)
        self.saveButton.setTitleColor(UIColor.Asset.white, for: .normal)
        self.saveButton.capsule(color: UIColor.Asset.lightBlue, borderWidth: 1, borderColor: UIColor.Asset.lightBlue)
        
        self.dobDate = (UserManager.shared.dob == "" ? nil : (Date.stringToDate(str: UserManager.shared.dob)))
        if let dob = self.dobDate {
            self.birthdayTextField.text = dob.dateToString()
        } else {
            self.birthdayTextField.text = ""
        }
        self.viewModel.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func disableUI(isActive: Bool) {
        if isActive {
            self.overviewTextView.isEditable = true
            self.birthdayTextField.isEnabled = true
            self.selectDateButton.isEnabled = true
            self.facebookTextField.isEnabled = true
            self.twitterTextField.isEnabled = true
            self.youtubeTextField.isEnabled = true
            self.mediumTextField.isEnabled = true
            self.websiteTextField.isEnabled = true
        } else {
            self.overviewTextView.isEditable = false
            self.birthdayTextField.isEnabled = false
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
        self.viewModel.userRequest.payload.overview = self.overviewTextView.text ?? ""
        self.viewModel.userRequest.payload.links.facebook = (self.facebookTextField.text! == "https://" ? "" : self.facebookTextField.text!)
        self.viewModel.userRequest.payload.links.twitter = (self.twitterTextField.text! == "https://" ? "" : self.twitterTextField.text!)
        self.viewModel.userRequest.payload.links.youtube = (self.youtubeTextField.text! == "https://" ? "" : self.youtubeTextField.text!)
        self.viewModel.userRequest.payload.links.medium = (self.mediumTextField.text! == "https://" ? "" : self.mediumTextField.text!)
        self.viewModel.userRequest.payload.links.website = (self.websiteTextField.text! == "https://" ? "" : self.websiteTextField.text!)
        self.viewModel.updateProfile(isPage: false, castcleId: UserManager.shared.rawCastcleId)
    }
}

extension EditInfoTableViewCell: DatePickerViewControllerDelegate {
    func datePickerViewController(_ view: DatePickerViewController, didSelectDate date: Date, displayDate: String) {
        self.viewModel.dobDate = date
        self.birthdayTextField.text = displayDate
    }
}

extension EditInfoTableViewCell: EditProfileViewModelDelegate {
    func didUpdateInfoFinish(success: Bool) {
        if !self.viewModel.isPage {
            self.hud.dismiss()
            if success {
                Utility.currentViewController().navigationController?.popViewController(animated: true)
            } else {
                self.disableUI(isActive: true)
            }
        }
    }
}
