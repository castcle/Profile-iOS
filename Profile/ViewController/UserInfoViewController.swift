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
//  Created by Castcle Co., Ltd. on 8/8/2564 BE.
//

import UIKit
import Core
import Networking
import Defaults

public class UserInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!

    enum UserInfoViewControllerSection: Int, CaseIterable {
        case info = 0
        case createAt
        case birthdate
        case email
        case contactNumber
        case headerLink
        case link
    }

    var viewModel = UserInfoViewModel(userInfo: UserInfo())

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.setupNavBar()
        self.configureTableView()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Defaults[.screenId] = ScreenId.viewProfile.rawValue
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        EngagementHelper().sendCastcleAnalytic(event: .onScreenView, screen: .viewProfile)
    }

    func setupNavBar() {
        self.customNavigationBar(.secondary, title: self.viewModel.userInfo.displayName)
    }

    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: ProfileNibVars.TableViewCell.meInfo, bundle: ConfigBundle.profile), forCellReuseIdentifier: ProfileNibVars.TableViewCell.meInfo)
        self.tableView.register(UINib(nibName: ProfileNibVars.TableViewCell.socialLink, bundle: ConfigBundle.profile), forCellReuseIdentifier: ProfileNibVars.TableViewCell.socialLink)
        self.tableView.register(UINib(nibName: ProfileNibVars.TableViewCell.infoHeader, bundle: ConfigBundle.profile), forCellReuseIdentifier: ProfileNibVars.TableViewCell.infoHeader)
        self.tableView.register(UINib(nibName: ProfileNibVars.TableViewCell.infoNormal, bundle: ConfigBundle.profile), forCellReuseIdentifier: ProfileNibVars.TableViewCell.infoNormal)
        self.tableView.register(UINib(nibName: ProfileNibVars.TableViewCell.infoWithIcon, bundle: ConfigBundle.profile), forCellReuseIdentifier: ProfileNibVars.TableViewCell.infoWithIcon)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return UserInfoViewControllerSection.allCases.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case UserInfoViewControllerSection.createAt.rawValue:
            return (self.viewModel.userInfo.type == .page ? 1 : 0)
        case UserInfoViewControllerSection.birthdate.rawValue:
            if self.viewModel.userInfo.type == .page {
                return 0
            } else {
                if self.viewModel.userInfo.dob.isEmpty {
                    return 0
                } else {
                    return 1
                }
            }
        case UserInfoViewControllerSection.email.rawValue:
            if self.viewModel.userInfo.type == .people {
                return 0
            } else {
                if self.viewModel.userInfo.contact.email.isEmpty {
                    return 0
                } else {
                    return 1
                }
            }
        case UserInfoViewControllerSection.contactNumber.rawValue:
            if self.viewModel.userInfo.type == .people {
                return 0
            } else {
                if self.viewModel.userInfo.contact.phone.isEmpty {
                    return 0
                } else {
                    return 1
                }
            }
        case UserInfoViewControllerSection.headerLink.rawValue:
            return (self.viewModel.socialLink.isEmpty ? 0 : 1)
        case UserInfoViewControllerSection.link.rawValue:
            return self.viewModel.socialLink.count
        default:
            return 1
        }
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case UserInfoViewControllerSection.info.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileNibVars.TableViewCell.meInfo, for: indexPath as IndexPath) as? UserInfoTableViewCell
            cell?.backgroundColor = UIColor.clear
            cell?.configCell(userInfo: self.viewModel.userInfo)
            return cell ?? UserInfoTableViewCell()
        case UserInfoViewControllerSection.createAt.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileNibVars.TableViewCell.infoNormal, for: indexPath as IndexPath) as? InfoNormalTableViewCell
            let createDate = Date.stringToDate(str: self.viewModel.userInfo.createdAt)
            cell?.backgroundColor = UIColor.clear
            cell?.configCell(title: "Page create", detail: createDate.dateToString())
            return cell ?? InfoNormalTableViewCell()
        case UserInfoViewControllerSection.birthdate.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileNibVars.TableViewCell.infoNormal, for: indexPath as IndexPath) as? InfoNormalTableViewCell
            let dobDate = Date.stringToDate(str: self.viewModel.userInfo.dob)
            cell?.backgroundColor = UIColor.clear
            cell?.configCell(title: "Date of birth", detail: dobDate.dateToString())
            return cell ?? InfoNormalTableViewCell()
        case UserInfoViewControllerSection.email.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileNibVars.TableViewCell.infoNormal, for: indexPath as IndexPath) as? InfoNormalTableViewCell
            cell?.backgroundColor = UIColor.clear
            cell?.configCell(title: "Email", detail: self.viewModel.userInfo.contact.email)
            return cell ?? InfoNormalTableViewCell()
        case UserInfoViewControllerSection.contactNumber.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileNibVars.TableViewCell.infoNormal, for: indexPath as IndexPath) as? InfoNormalTableViewCell
            let contactNumber = "(\(self.viewModel.userInfo.contact.countryCode.isEmpty ? "+66" : self.viewModel.userInfo.contact.countryCode)) \(self.viewModel.userInfo.contact.phone)"
            cell?.backgroundColor = UIColor.clear
            cell?.configCell(title: "Contact number", detail: contactNumber)
            return cell ?? InfoNormalTableViewCell()
        case UserInfoViewControllerSection.headerLink.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileNibVars.TableViewCell.infoHeader, for: indexPath as IndexPath) as? InfoHeaderTableViewCell
            cell?.backgroundColor = UIColor.clear
            cell?.configCell(title: "Social media links")
            return cell ?? InfoHeaderTableViewCell()
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
