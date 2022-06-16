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
//  UpdateUserInfoViewController.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 10/5/2565 BE.
//

import UIKit
import Core
import Defaults

class UpdateUserInfoViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    private var isProcess: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.setupNavBar()
        self.hideKeyboardWhenTapped()
        self.configureTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Defaults[.screenId] = ""
    }

    func setupNavBar() {
        self.customNavigationBar(.primary, title: "New User Profile")

        var rightButton: [UIBarButtonItem] = []
        let icon = UIButton()
        icon.setTitle(Localization.ChooseProfileImage.skip.text, for: .normal)
        icon.titleLabel?.font = UIFont.asset(.regular, fontSize: .body)
        icon.setTitleColor(UIColor.Asset.lightBlue, for: .normal)
        icon.addTarget(self, action: #selector(skipAction), for: .touchUpInside)
        rightButton.append(UIBarButtonItem(customView: icon))
        self.navigationItem.rightBarButtonItems = rightButton
    }

    @objc private func skipAction() {
        if !self.isProcess {
            Utility.currentViewController().view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }

    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: ProfileNibVars.TableViewCell.updateUserInfo, bundle: ConfigBundle.profile), forCellReuseIdentifier: ProfileNibVars.TableViewCell.updateUserInfo)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }
}

extension UpdateUserInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileNibVars.TableViewCell.updateUserInfo, for: indexPath as IndexPath) as? UpdateUserInfoTableViewCell
        cell?.backgroundColor = UIColor.clear
        cell?.delegate = self
        return cell ?? UpdateUserInfoTableViewCell()
    }
}

extension UpdateUserInfoViewController: UpdateUserInfoTableViewCellDelegate {
    func didUpdateInfo(isProcess: Bool) {
        self.isProcess = isProcess
    }
}
