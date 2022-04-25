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
//  ContactPhoneViewController.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 22/4/2565 BE.
//

import UIKit
import Core

protocol ContactPhoneViewControllerDelegate {
    func didChangePhone(_ contactPhoneViewController: ContactPhoneViewController, phone: String, countryCode: String)
}

class ContactPhoneViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    public var delegate: ContactPhoneViewControllerDelegate?
    var viewModel = EditInfoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.hideKeyboardWhenTapped()
        self.setupNavBar()
        self.configureTableView()
    }
    
    func setupNavBar() {
        self.customNavigationBar(.secondary, title: "Contact Number")
    }
    
    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: ProfileNibVars.TableViewCell.contactPhone, bundle: ConfigBundle.profile), forCellReuseIdentifier: ProfileNibVars.TableViewCell.contactPhone)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileNibVars.TableViewCell.contactPhone, for: indexPath as IndexPath) as? ContactPhoneTableViewCell
        cell?.backgroundColor = UIColor.clear
        cell?.configCell(viewModel: self.viewModel)
        cell?.delegate = self
        return cell ?? ContactPhoneTableViewCell()
    }
}

extension ContactPhoneViewController: ContactPhoneTableViewCellDelegate {
    func didChangePhone(_ contactPhoneTableViewCell: ContactPhoneTableViewCell, phone: String, countryCode: String) {
        self.delegate?.didChangePhone(self, phone: phone, countryCode: countryCode)
    }
}
