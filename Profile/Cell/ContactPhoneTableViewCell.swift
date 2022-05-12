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
//  ContactPhoneTableViewCell.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 22/4/2565 BE.
//

import UIKit
import Core
import Component
import JGProgressHUD
import RealmSwift

protocol ContactPhoneTableViewCellDelegate: AnyObject {
    func didChangePhone(_ contactPhoneTableViewCell: ContactPhoneTableViewCell, phone: String, countryCode: String)
}

class ContactPhoneTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var codeLabel: UILabel!
    @IBOutlet var codeView: UIView!
    @IBOutlet var mobileViewView: UIView!
    @IBOutlet var mobileTextField: UITextField!
    @IBOutlet var dropdownImage: UIImageView!

    public var delegate: ContactPhoneTableViewCellDelegate?
    var viewModel = EditInfoViewModel()
    let hud = JGProgressHUD()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.hud.textLabel.text = "Saving"
        self.subtitleLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.subtitleLabel.textColor = UIColor.Asset.white
        self.setupSaveButton(isActive: false)
        self.codeLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.codeLabel.textColor = UIColor.Asset.white
        self.mobileTextField.font = UIFont.asset(.regular, fontSize: .overline)
        self.mobileTextField.textColor = UIColor.Asset.white
        self.codeView.capsule(color: UIColor.Asset.darkGray)
        self.mobileViewView.capsule(color: UIColor.Asset.darkGray)
        self.dropdownImage.image = UIImage.init(icon: .castcle(.dropDown), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.lightBlue)
        self.mobileTextField.delegate = self
        self.mobileTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configCell(viewModel: EditInfoViewModel) {
        self.viewModel = viewModel
        self.mobileTextField.text = self.viewModel.userInfo.contact.phone
        if !self.viewModel.userInfo.contact.countryCode.isEmpty {
            do {
                let realm = try Realm()
                if let countryCode = realm.objects(CountryCode.self).filter("dialCode == '\(self.viewModel.userInfo.contact.countryCode)'").first {
                    self.codeLabel.text = "\(countryCode.dialCode) \(countryCode.code)"
                }
            } catch {}
        } else {
            self.viewModel.userRequest.payload.contact.countryCode = "+66"
            self.codeLabel.text = "+66 TH"
        }
        self.viewModel.delegate = self
    }

    private func isCanNext() -> Bool {
        if self.mobileTextField.text!.isEmpty {
            return false
        } else {
            return true
        }
    }

    private func setupSaveButton(isActive: Bool) {
        self.saveButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .head4)
        if isActive {
            self.saveButton.setTitleColor(UIColor.Asset.white, for: .normal)
            self.saveButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
            self.saveButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.clear)
        } else {
            self.saveButton.setTitleColor(UIColor.Asset.gray, for: .normal)
            self.saveButton.setBackgroundImage(UIColor.Asset.darkGraphiteBlue.toImage(), for: .normal)
            self.saveButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.Asset.black)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
       return true
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        let mobileNumber = (textField.text ?? "").substringWithRange(range: 20)
        if mobileNumber.isEmpty {
            self.setupSaveButton(isActive: false)
        } else {
            self.setupSaveButton(isActive: true)
        }
        textField.text = mobileNumber
    }

    @IBAction func selectContryCodeAction(_ sender: Any) {
        let viewController = ComponentOpener.open(.selectCode) as? SelectCodeViewController
        viewController?.delegate = self
        Utility.currentViewController().navigationController?.pushViewController(viewController ?? SelectCodeViewController(), animated: true)
    }

    @IBAction func nextAction(_ sender: Any) {
        self.endEditing(true)
        if self.isCanNext() {
            self.hud.show(in: Utility.currentViewController().view)
            self.viewModel.userRequest.payload.contact.phone = self.mobileTextField.text!
            self.viewModel.updateProfile(isPage: true, castcleId: self.viewModel.userInfo.castcleId)
        }
    }
}

extension ContactPhoneTableViewCell: EditInfoViewModelDelegate {
    func didGetInfoFinish(success: Bool) {
        // Not use
    }

    func didUpdateInfoFinish(success: Bool) {
        self.hud.dismiss()
        self.delegate?.didChangePhone(self, phone: self.viewModel.userRequest.payload.contact.phone, countryCode: self.viewModel.userRequest.payload.contact.countryCode)
        Utility.currentViewController().navigationController?.popViewController(animated: true)
    }
}

extension ContactPhoneTableViewCell: SelectCodeViewControllerDelegate {
    func didSelectCountryCode(_ view: SelectCodeViewController, countryCode: CountryCode) {
        self.viewModel.userRequest.payload.contact.countryCode = countryCode.dialCode
        self.codeLabel.text = "\(countryCode.dialCode) \(countryCode.code)"
        self.setupSaveButton(isActive: self.isCanNext())
    }
}
