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
//  SocialTableViewCell.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 16/9/2564 BE.
//

import UIKit
import JVFloatLabeledTextField

class SocialTableViewCell: UITableViewCell {

    @IBOutlet var valueView: UIView!
    @IBOutlet var valueTextField: JVFloatLabeledTextField! {
        didSet {
            self.valueTextField.font = UIFont.asset(.regular, fontSize: .body)
            self.valueTextField.placeholderColor = UIColor.Asset.gray
            self.valueTextField.floatingLabelTextColor = UIColor.Asset.gray
            self.valueTextField.floatingLabelActiveTextColor = UIColor.Asset.gray
            self.valueTextField.floatingLabelFont = UIFont.asset(.regular, fontSize: .small)
            self.valueTextField.textColor = UIColor.Asset.white
        }
    }

    var socialLink: SocialLink? {
        didSet {
            guard let socialLink = self.socialLink else { return }
            self.valueTextField.placeholder = socialLink.socialLinkType.rawValue
            self.valueTextField.text = socialLink.value
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.valueView.custom(color: UIColor.Asset.darkGray, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
