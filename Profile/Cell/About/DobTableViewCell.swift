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
//  DobTableViewCell.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 16/9/2564 BE.
//

import UIKit
import Core
import Component
import JVFloatLabeledTextField

protocol DobTableViewCellDelegate {
    func didUpdateData(_ dobTableViewCell: DobTableViewCell, date: Date, displayDate: String)
}

class DobTableViewCell: UITableViewCell {

    @IBOutlet var birthdayLabel: UILabel!
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
    @IBOutlet var birthdayView: UIView!
    
    var delegate: DobTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.birthdayView.custom(color: UIColor.Asset.darkGray, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.birthdayLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.birthdayLabel.textColor = UIColor.Asset.white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func selectDateAction(_ sender: Any) {
        let vc = ComponentOpener.open(.datePicker) as? DatePickerViewController
        vc?.delegate = self
        Utility.currentViewController().presentPanModal(vc ?? DatePickerViewController())
    }
}

extension DobTableViewCell: DatePickerViewControllerDelegate {
    func datePickerViewController(_ view: DatePickerViewController, didSelectDate date: Date, displayDate: String) {
        self.birthdayTextField.text = displayDate
        self.delegate?.didUpdateData(self, date: date, displayDate: displayDate)
    }
}
