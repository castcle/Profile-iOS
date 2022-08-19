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
//  ConfirmDeletePageTableViewCell.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 18/10/2564 BE.
//

import UIKit
import Core
import Networking
import Component
import JVFloatLabeledTextField

class ConfirmDeletePageTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet var headlineLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var displayNameLabel: UILabel!
    @IBOutlet var pageLabel: UILabel!
    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var line1View: UIView!
    @IBOutlet var line2View: UIView!
    @IBOutlet var passwordView: UIView!
    @IBOutlet var passwordTextField: JVFloatLabeledTextField!
    @IBOutlet var showPasswordButton: UIButton!
    @IBOutlet var nextButton: UIButton!

    var viewModel = DeletePageViewModel(userInfo: UserInfo())

    override func awakeFromNib() {
        super.awakeFromNib()
        self.passwordView.custom(color: UIColor.Asset.cellBackground, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.headlineLabel.font = UIFont.asset(.regular, fontSize: .title)
        self.headlineLabel.textColor = UIColor.Asset.white
        self.subtitleLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.subtitleLabel.textColor = UIColor.Asset.white
        self.displayNameLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.displayNameLabel.textColor = UIColor.Asset.white
        self.pageLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.pageLabel.textColor = UIColor.Asset.white
        self.avatarImage.circle(color: UIColor.Asset.white)
        self.line1View.backgroundColor = UIColor.Asset.black
        self.line2View.backgroundColor = UIColor.Asset.black
        self.showPasswordButton.setImage(UIImage.init(icon: .castcle(.show), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        self.nextButton.activeButton(isActive: false)
        self.passwordTextField.tag = 0
        self.passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.passwordTextField.delegate = self
        self.viewModel.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private func isCanNext() -> Bool {
        if self.passwordTextField.text!.isEmpty {
            return false
        } else {
            return true
        }
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        self.nextButton.activeButton(isActive: self.isCanNext())
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func configCell(userInfo: UserInfo) {
        self.viewModel.userInfo = userInfo
        self.passwordTextField.font = UIFont.asset(.regular, fontSize: .body)
        self.passwordTextField.placeholder = Localization.DeletePageConfirm.password.text
        self.passwordTextField.placeholderColor = UIColor.Asset.gray
        self.passwordTextField.floatingLabelTextColor = UIColor.Asset.gray
        self.passwordTextField.floatingLabelActiveTextColor = UIColor.Asset.gray
        self.passwordTextField.floatingLabelFont = UIFont.asset(.regular, fontSize: .small)
        self.passwordTextField.textColor = UIColor.Asset.white
        self.passwordTextField.isSecureTextEntry = true

        let url = URL(string: self.viewModel.userInfo.images.avatar.thumbnail)
        self.avatarImage.kf.setImage(with: url, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
        self.displayNameLabel.text = self.viewModel.userInfo.displayName
        self.headlineLabel.text = Localization.DeletePageConfirm.subTitle.text
        self.subtitleLabel.text = Localization.DeletePageConfirm.subDetail.text
        self.pageLabel.text = Localization.DeletePageConfirm.page.text
        self.nextButton.setTitle(Localization.DeletePageConfirm.next.text, for: .normal)
    }

    @IBAction func showPasswordAction(_ sender: Any) {
        self.passwordTextField.isSecureTextEntry.toggle()
        if self.passwordTextField.isSecureTextEntry {
            self.showPasswordButton.setImage(UIImage.init(icon: .castcle(.show), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            self.showPasswordButton.setImage(UIImage.init(icon: .castcle(.show), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.lightBlue).withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }

    @IBAction func nextAction(_ sender: Any) {
        self.endEditing(true)
        if self.isCanNext() {
            CCLoading.shared.show(text: "Deleting")
            self.viewModel.pageRequest.password = self.passwordTextField.text!
            self.viewModel.deletePage()
        }
    }
}

extension ConfirmDeletePageTableViewCell: DeletePageViewModelDelegate {
    func didDeletePageFinish(success: Bool) {
        if success {
            self.viewModel.getAllMyPage()
        } else {
            CCLoading.shared.dismiss()
        }
    }

    func didGetAllPageFinish() {
        CCLoading.shared.dismiss()
        Utility.currentViewController().navigationController?.pushViewController(ProfileOpener.open(.deletePageSuccess), animated: true)
    }
}
