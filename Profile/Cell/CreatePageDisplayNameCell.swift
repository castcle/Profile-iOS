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
//  CreatePageDisplayNameCell.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 16/9/2564 BE.
//

import UIKit
import Core
import Authen
import JGProgressHUD

class CreatePageDisplayNameCell: UICollectionViewCell, UITextFieldDelegate {

    @IBOutlet var headlineLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var displayNameView: UIView!
    @IBOutlet var castcleIdPasswordView: UIView!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var displayNameTextfield: UITextField!
    @IBOutlet var idTextField: UITextField!
    @IBOutlet var checkImage: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    private var viewModel = CreatePageDisplayNameViewModel()
    let hud = JGProgressHUD()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.hud.textLabel.text = "Creating"
        self.displayNameView.custom(color: UIColor.Asset.darkGray, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.castcleIdPasswordView.custom(color: UIColor.Asset.darkGray, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.headlineLabel.font = UIFont.asset(.regular, fontSize: .title)
        self.headlineLabel.textColor = UIColor.Asset.white
        self.subTitleLabel.font = UIFont.asset(.regular, fontSize: .head4)
        self.subTitleLabel.textColor = UIColor.Asset.white
        self.setupNextButton(isActive: false)
        self.activityIndicator.color = UIColor.Asset.lightBlue
        self.activityIndicator.isHidden = true
        self.checkImage.isHidden = true
        self.checkImage.tintColor = UIColor.Asset.denger
        self.displayNameTextfield.font = UIFont.asset(.regular, fontSize: .body)
        self.displayNameTextfield.textColor = UIColor.Asset.white
        self.idTextField.font = UIFont.asset(.regular, fontSize: .body)
        self.idTextField.textColor = UIColor.Asset.white
        self.displayNameTextfield.delegate = self
        self.displayNameTextfield.tag = 0
        self.idTextField.delegate = self
        self.idTextField.tag = 1
        self.idTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }

    func configCell(viewModel: CreatePageDisplayNameViewModel) {
        self.viewModel = viewModel
        self.viewModel.delegate = self
        self.headlineLabel.text = Localization.CreatePageName.headline.text
        self.subTitleLabel.text = Localization.CreatePageName.description.text
        self.displayNameTextfield.placeholder = Localization.CreatePageName.displayName.text
        self.nextButton.setTitle(Localization.CreatePageName.button.text, for: .normal)
    }

    private func castcleId(displayCastcleId: String) -> String {
        return displayCastcleId.replacingOccurrences(of: "@", with: "")
    }

    private func updateUI() {
        self.idTextField.isEnabled = true
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
        if self.viewModel.isCastcleIdExist {
            self.setupNextButton(isActive: false)
            self.checkImage.isHidden = false
            self.checkImage.image = UIImage.init(icon: .castcle(.incorrect), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.denger)
            self.idTextField.textColor = UIColor.Asset.denger
        } else {
            if self.displayNameTextfield.text!.isEmpty {
                self.setupNextButton(isActive: false)
            } else {
                self.setupNextButton(isActive: true)
            }
            self.checkImage.isHidden = false
            self.checkImage.image = UIImage.init(icon: .castcle(.checkmark), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.lightBlue)
            self.idTextField.textColor = UIColor.Asset.white
        }
    }

    private func setupNextButton(isActive: Bool) {
        self.nextButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .head4)
        if isActive {
            self.nextButton.setTitleColor(UIColor.Asset.white, for: .normal)
            self.nextButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
            self.nextButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.clear)
        } else {
            self.nextButton.setTitleColor(UIColor.Asset.gray, for: .normal)
            self.nextButton.setBackgroundImage(UIColor.Asset.darkGraphiteBlue.toImage(), for: .normal)
            self.nextButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.Asset.black)
        }
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.tag == 1 {
            let displayCastcleId = textField.text ?? ""
            let castcleId = self.castcleId(displayCastcleId: displayCastcleId)
            if !castcleId.isEmpty {
                textField.text = "@\(castcleId)"
            } else {
                textField.text = ""
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.setupNextButton(isActive: false)
        if textField.tag == 1 {
            self.checkImage.isHidden = true
            self.idTextField.textColor = UIColor.Asset.white
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            let displayName = textField.text ?? ""
            self.viewModel.authenRequest.displayName = displayName
            if !self.viewModel.authenRequest.displayName.isEmpty && !self.viewModel.isCastcleIdExist {
                self.setupNextButton(isActive: true)
            } else if !self.viewModel.authenRequest.displayName.isEmpty && self.viewModel.isCastcleIdExist {
                self.idTextField.isEnabled = false
                self.activityIndicator.isHidden = false
                self.checkImage.isHidden = true
                self.activityIndicator.startAnimating()
                self.viewModel.suggestCastcleId()
            } else {
                self.setupNextButton(isActive: false)
            }
        } else if textField.tag == 1 {
            let idCastcle = textField.text ?? ""
            if idCastcle.isEmpty {
                self.setupNextButton(isActive: false)
                self.checkImage.isHidden = true
                textField.textColor = UIColor.Asset.white
            } else {
                textField.isEnabled = false
                self.activityIndicator.isHidden = false
                self.checkImage.isHidden = true
                self.activityIndicator.startAnimating()
                self.viewModel.authenRequest.castcleId = self.castcleId(displayCastcleId: textField.text!)
                self.viewModel.checkCastcleIdExists()
            }
        }
    }

    static func cellSize(width: CGFloat) -> CGSize {
        return CGSize(width: width, height: 650)
    }

    @IBAction func nextAction(_ sender: Any) {
        self.endEditing(true)
        if !self.displayNameTextfield.text!.isEmpty && !self.viewModel.isCastcleIdExist {
            self.hud.show(in: Utility.currentViewController().view)
            self.viewModel.pageRequest.castcleId = self.viewModel.authenRequest.castcleId
            self.viewModel.pageRequest.displayName = self.viewModel.authenRequest.displayName
            self.viewModel.createPage()
        }
    }
}

extension CreatePageDisplayNameCell: CreatePageDisplayNameViewModelDelegate {
    func didSuggestCastcleIdFinish(suggestCastcleId: String) {
        self.viewModel.authenRequest.castcleId = suggestCastcleId
        self.viewModel.isCastcleIdExist = false
        self.idTextField.text = "@\(suggestCastcleId)"
        self.updateUI()
    }

    func didCheckCastcleIdExistsFinish() {
        self.updateUI()
    }

    func didCreatePageFinish(success: Bool, castcleId: String) {
        if success {
            self.viewModel.getAllMyPage(castcleId: castcleId)
        } else {
            self.hud.dismiss()
        }
    }

    func didGetAllPageFinish(castcleId: String) {
        self.hud.dismiss()
        Utility.currentViewController().navigationController?.pushViewController(ProfileOpener.open(.photoMethod(SelectPhotoMethodViewModel(authorType: .page, castcleId: castcleId))), animated: true)
    }
}
