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
//  UserInfoViewController.swift
//  Profile
//
//  Created by Tanakorn Phoochaliaw on 8/8/2564 BE.
//

import UIKit
import Core
import Defaults

class UserInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    enum UserInfoViewControllerSection: Int, CaseIterable {
        case info = 0
        case link
    }
    
    var viewModel = UserInfoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.setupNavBar()
        self.configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Defaults[.screenId] = ""
    }
    
    func setupNavBar() {
        self.customNavigationBar(.secondary, title: "Alexandra Daddario's Profile")
    }
    
    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: ProfileNibVars.TableViewCell.meInfo, bundle: ConfigBundle.profile), forCellReuseIdentifier: ProfileNibVars.TableViewCell.meInfo)
        self.tableView.register(UINib(nibName: ProfileNibVars.TableViewCell.socialLink, bundle: ConfigBundle.profile), forCellReuseIdentifier: ProfileNibVars.TableViewCell.socialLink)
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return UserInfoViewControllerSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case UserInfoViewControllerSection.link.rawValue:
            return self.viewModel.socialLink.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case UserInfoViewControllerSection.info.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileNibVars.TableViewCell.meInfo, for: indexPath as IndexPath) as? UserInfoTableViewCell
            cell?.backgroundColor = UIColor.clear
            return cell ?? UserInfoTableViewCell()
        case UserInfoViewControllerSection.link.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileNibVars.TableViewCell.socialLink, for: indexPath as IndexPath) as? SocialLinkTableViewCell
            cell?.backgroundColor = UIColor.clear
            cell?.socialLink = self.viewModel.socialLink[indexPath.row]
            return cell ?? SocialLinkTableViewCell()
        default:
            return UITableViewCell()
        }
    }
}
