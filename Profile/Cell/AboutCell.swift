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
//  AboutCell.swift
//  Profile
//
//  Created by Tanakorn Phoochaliaw on 6/8/2564 BE.
//

import UIKit
import Core
import Component
import JVFloatLabeledTextField
import UITextView_Placeholder
import PanModal

protocol AboutCellDelegate {
    func didUpdateData(isUpdate: Bool)
}

class AboutCell: UICollectionViewCell, UITextViewDelegate {

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
    
    var delegate: AboutCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
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
        
        self.birthdayTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        self.checkIsEdit()
    }
    
    private func checkIsEdit() {
        if !self.birthdayTextField.text!.isEmpty && self.overviewTextView.text!.isEmpty {
            self.delegate?.didUpdateData(isUpdate: false)
        } else {
            self.delegate?.didUpdateData(isUpdate: true)
        }
    }

    static func cellSize(width: CGFloat) -> CGSize {
        return CGSize(width: width, height: 400)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 161
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.checkIsEdit()
    }
    
    @IBAction func selectDateAction(_ sender: Any) {
        let vc = ComponentOpener.open(.datePicker) as? DatePickerViewController
        vc?.delegate = self
        Utility.currentViewController().presentPanModal(vc ?? DatePickerViewController())
    }
}

extension AboutCell: DatePickerViewControllerDelegate {
    func datePickerViewController(_ view: DatePickerViewController, didSelectDate date: Date, displayDate: String) {
        self.birthdayTextField.text = displayDate
    }
}
