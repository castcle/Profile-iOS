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
//  ContactEmailTableViewCell.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 21/4/2565 BE.
//

import UIKit
import Core
import JGProgressHUD

protocol ContactEmailTableViewCellDelegate: AnyObject {
    func didChangeEmail(_ contactEmailTableViewCell: ContactEmailTableViewCell, email: String)
}

class ContactEmailTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var emailView: UIView!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var saveButton: UIButton!

    public var delegate: ContactEmailTableViewCellDelegate?
    var viewModel = EditInfoViewModel()
    let hud = JGProgressHUD()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.hud.textLabel.text = "Saving"
        self.emailView.custom(color: UIColor.Asset.darkGray, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.subtitleLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.subtitleLabel.textColor = UIColor.Asset.white
        self.emailTextField.font = UIFont.asset(.regular, fontSize: .body)
        self.emailTextField.textColor = UIColor.Asset.white
        self.saveButton.activeButton(isActive: false)
        self.emailTextField.delegate = self
        self.emailTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configCell(viewModel: EditInfoViewModel) {
        self.viewModel = viewModel
        self.emailTextField.text = self.viewModel.userInfo.contact.email
        self.viewModel.delegate = self
    }

    private func isCanNext() -> Bool {
        if self.emailTextField.text!.isEmpty {
            return false
        } else {
            return true
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
       return true
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        self.saveButton.activeButton(isActive: self.isCanNext())
    }

    @IBAction func nextAction(_ sender: Any) {
        self.endEditing(true)
        if self.isCanNext() {
            self.hud.show(in: Utility.currentViewController().view)
            self.viewModel.userRequest.payload.contact.email = self.emailTextField.text!
            self.viewModel.updateProfile(isPage: true, castcleId: self.viewModel.userInfo.castcleId)
        }
    }
}

extension ContactEmailTableViewCell: EditInfoViewModelDelegate {
    func didGetInfoFinish(success: Bool) {
        // Not use
    }

    func didUpdateInfoFinish(success: Bool) {
        self.hud.dismiss()
        self.delegate?.didChangeEmail(self, email: self.viewModel.userRequest.payload.contact.email)
        Utility.currentViewController().navigationController?.popViewController(animated: true)
    }
}
