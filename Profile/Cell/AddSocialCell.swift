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
//  AddSocialCell.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 6/8/2564 BE.
//

import UIKit
import Core
import JVFloatLabeledTextField
import Defaults

class AddSocialCell: UICollectionViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var facebookView: UIView!
    @IBOutlet var twitterView: UIView!
    @IBOutlet var youtubeView: UIView!
    @IBOutlet var mediumView: UIView!
    @IBOutlet var websiteView: UIView!
    @IBOutlet var facebookTextField: JVFloatLabeledTextField! {
        didSet {
            self.facebookTextField.font = UIFont.asset(.regular, fontSize: .body)
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
            self.websiteTextField.placeholderColor = UIColor.Asset.gray
            self.websiteTextField.floatingLabelTextColor = UIColor.Asset.gray
            self.websiteTextField.floatingLabelActiveTextColor = UIColor.Asset.gray
            self.websiteTextField.floatingLabelFont = UIFont.asset(.regular, fontSize: .small)
            self.websiteTextField.textColor = UIColor.Asset.white
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        self.facebookView.custom(color: UIColor.Asset.darkGray, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.twitterView.custom(color: UIColor.Asset.darkGray, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.youtubeView.custom(color: UIColor.Asset.darkGray, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.mediumView.custom(color: UIColor.Asset.darkGray, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.websiteView.custom(color: UIColor.Asset.darkGray, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.titleLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.titleLabel.textColor = UIColor.Asset.white

        self.facebookTextField.tag = 0
        self.facebookTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.twitterTextField.tag = 1
        self.twitterTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.youtubeTextField.tag = 2
        self.youtubeTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.mediumTextField.tag = 3
        self.mediumTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.websiteTextField.tag = 4
        self.websiteTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)

        self.facebookTextField.text = (Defaults[.facebook].isEmpty ? UrlProtocol.https.value : Defaults[.facebook])
        self.twitterTextField.text = (Defaults[.twitter].isEmpty ? UrlProtocol.https.value : Defaults[.twitter])
        self.youtubeTextField.text = (Defaults[.youtube].isEmpty ? UrlProtocol.https.value : Defaults[.youtube])
        self.mediumTextField.text = (Defaults[.medium].isEmpty ? UrlProtocol.https.value : Defaults[.medium])
        self.websiteTextField.text = (Defaults[.website].isEmpty ? UrlProtocol.https.value : Defaults[.website])

        self.titleLabel.text = Localization.AddSocial.description.text
        self.facebookTextField.placeholder = Localization.AddSocial.facebook.text
        self.twitterTextField.placeholder = Localization.AddSocial.twitter.text
        self.youtubeTextField.placeholder = Localization.AddSocial.youtube.text
        self.mediumTextField.placeholder = Localization.AddSocial.medium.text
        self.websiteTextField.placeholder = Localization.AddSocial.website.text
    }

    static func cellSize(width: CGFloat) -> CGSize {
        return CGSize(width: width, height: 490)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.tag == 0 {
            Defaults[.facebook] = (textField.text! == UrlProtocol.https.value ? "" : textField.text!)
        } else if textField.tag == 1 {
            Defaults[.twitter] = (textField.text! == UrlProtocol.https.value ? "" : textField.text!)
        } else if textField.tag == 2 {
            Defaults[.youtube] = (textField.text! == UrlProtocol.https.value ? "" : textField.text!)
        } else if textField.tag == 3 {
            Defaults[.medium] = (textField.text! == UrlProtocol.https.value ? "" : textField.text!)
        } else if textField.tag == 4 {
            Defaults[.website] = (textField.text! == UrlProtocol.https.value ? "" : textField.text!)
        }
    }
}
