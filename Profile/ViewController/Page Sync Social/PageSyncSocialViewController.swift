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
//  PageSyncSocialViewController.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 9/3/2565 BE.
//

import UIKit
import Core
import Defaults
import JGProgressHUD

class PageSyncSocialViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var viewModel = PageSyncSocialViewModel()
    let hud = JGProgressHUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.setupNavBar()
        self.configureTableView()
        self.hud.show(in: self.view)
        
        self.viewModel.didGetUserInfoFinish = {
            self.hud.dismiss()
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Defaults[.screenId] = ""
        self.hud.textLabel.text = "Loading"
    }
    
    func setupNavBar() {
        self.customNavigationBar(.secondary, title: "Sync with \(self.viewModel.userInfo.syncSocial.provider.capitalized)")
    }
    
    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: ProfileNibVars.TableViewCell.pageSyncSocial, bundle: ConfigBundle.profile), forCellReuseIdentifier: ProfileNibVars.TableViewCell.pageSyncSocial)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }
}

extension PageSyncSocialViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileNibVars.TableViewCell.pageSyncSocial, for: indexPath as IndexPath) as? PageSyncSocialTableViewCell
        cell?.backgroundColor = UIColor.clear
        cell?.configCell(userInfo: self.viewModel.userInfo)
        cell?.delegate = self
        return cell ?? PageSyncSocialTableViewCell()
    }
}

extension PageSyncSocialViewController: PageSyncSocialTableViewCellDelegate {
    func didConnect(_ pageSyncSocialTableViewCell: PageSyncSocialTableViewCell, isActive: Bool) {
        self.viewModel.userInfo.syncSocial.active = isActive
        self.tableView.reloadData()
    }
    
    func didAutoPost(_ pageSyncSocialTableViewCell: PageSyncSocialTableViewCell, isAutoPost: Bool) {
        self.viewModel.userInfo.syncSocial.autoPost = isAutoPost
    }
}
