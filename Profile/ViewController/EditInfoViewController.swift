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
//  EditInfoViewController.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 8/8/2564 BE.
//

import UIKit
import Core
import Component
import Networking
import Defaults
import JGProgressHUD

protocol EditInfoViewControllerDelegate: AnyObject {
    func didUpdateInfo(_ view: EditInfoViewController, userInfo: UserInfo)
}

class EditInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!

    var delegate: EditInfoViewControllerDelegate?
    var viewModel = EditInfoViewModel()
    let hud = JGProgressHUD()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.hideKeyboardWhenTapped()
        self.setupNavBar()
        self.configureTableView()
        self.viewModel.delegate = self
        if self.viewModel.profileType == .mine {
            self.hud.show(in: self.view)
            self.viewModel.getMeInfo()
        } else if self.viewModel.profileType == .user {
            self.hud.show(in: self.view)
            self.viewModel.getUserInfo()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Defaults[.screenId] = ScreenId.viewProfile.rawValue
        self.hud.textLabel.text = "Loading"
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        EngagementHelper().sendCastcleAnalytic(event: .onScreenView, screen: .viewProfile)
    }

    func setupNavBar() {
        if self.viewModel.profileType == .mine {
            self.customNavigationBar(.secondary, title: "Edit Profile")
        } else if self.viewModel.profileType == .user {
            self.customNavigationBar(.secondary, title: "Edit Page")
        }
    }

    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: ProfileNibVars.TableViewCell.editInfo, bundle: ConfigBundle.profile), forCellReuseIdentifier: ProfileNibVars.TableViewCell.editInfo)
        self.tableView.register(UINib(nibName: ProfileNibVars.TableViewCell.editPageInfo, bundle: ConfigBundle.profile), forCellReuseIdentifier: ProfileNibVars.TableViewCell.editPageInfo)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.viewModel.profileType == .mine {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileNibVars.TableViewCell.editInfo, for: indexPath as IndexPath) as? EditInfoTableViewCell
            cell?.backgroundColor = UIColor.clear
            cell?.configCell()
            cell?.delegate = self
            return cell ?? EditInfoTableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileNibVars.TableViewCell.editPageInfo, for: indexPath as IndexPath) as? EditPageInfoTableViewCell
            cell?.backgroundColor = UIColor.clear
            cell?.configCell(userInfo: self.viewModel.userInfo)
            cell?.delegate = self
            return cell ?? EditPageInfoTableViewCell()
        }
    }
}

extension EditInfoViewController: EditInfoViewModelDelegate {
    func didGetInfoFinish(success: Bool) {
        self.hud.dismiss()
        self.tableView.reloadData()
    }

    func didUpdateInfoFinish(success: Bool) {
        // Not use
    }
}

extension EditInfoViewController: EditInfoTableViewCellDelegate {
    func didUpdateUserInfo(_ cell: EditInfoTableViewCell, userInfo: UserInfo) {
        self.delegate?.didUpdateInfo(self, userInfo: userInfo)
    }
}

extension EditInfoViewController: EditPageInfoTableViewCellDelegate {
    func didUpdatePageInfo(_ cell: EditPageInfoTableViewCell, userInfo: UserInfo) {
        self.delegate?.didUpdateInfo(self, userInfo: userInfo)
    }
}
