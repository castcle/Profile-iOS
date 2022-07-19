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
//  FacebookPageListViewController.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 7/4/2565 BE.
//

import UIKit
import Core
import Networking

protocol FacebookPageListViewControllerDelegate: AnyObject {
    func didSelectFacebookPage(_ facebookPageListViewController: FacebookPageListViewController, page: FacebookPage)
}

class FacebookPageListViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    public var delegate: FacebookPageListViewControllerDelegate?
    var facebookPage: [FacebookPage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.setupNavBar()
        self.configureTableView()
    }

    func setupNavBar() {
        self.customNavigationBar(.secondary, title: "Facebook Pages")
    }

    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: ProfileNibVars.TableViewCell.facebookPage, bundle: ConfigBundle.profile), forCellReuseIdentifier: ProfileNibVars.TableViewCell.facebookPage)
        self.tableView.register(UINib(nibName: ProfileNibVars.TableViewCell.facebookPageEmpty, bundle: ConfigBundle.profile), forCellReuseIdentifier: ProfileNibVars.TableViewCell.facebookPageEmpty)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }
}

extension FacebookPageListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.facebookPage.isEmpty ? 1 : self.facebookPage.count)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.facebookPage.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileNibVars.TableViewCell.facebookPageEmpty, for: indexPath as IndexPath) as? FacebookPageEmptyTableViewCell
            cell?.backgroundColor = UIColor.clear
            return cell ?? FacebookPageEmptyTableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileNibVars.TableViewCell.facebookPage, for: indexPath as IndexPath) as? FacebookPageTableViewCell
            cell?.backgroundColor = UIColor.Asset.cellBackground
            cell?.configCell(page: self.facebookPage[indexPath.row])
            return cell ?? FacebookPageTableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !self.facebookPage.isEmpty {
            self.navigationController?.popViewController(animated: true)
            self.delegate?.didSelectFacebookPage(self, page: self.facebookPage[indexPath.row])
        }
    }
}
