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
//  AboutInfoViewController.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 6/8/2564 BE.
//

import UIKit
import Core
import Component
import IGListKit
import Defaults

class AboutInfoViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    enum AboutInfoViewControllerSection: Int, CaseIterable {
        case overview = 0
        case dob
        case addSocial
        case social
        case submit
    }
    
    var viewModel = AboutInfoViewModel(avatarType: .user)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.hideKeyboardWhenTapped()
        self.setupNavBar()
        self.configureTableView()
        
        self.viewModel.clearData()
        self.viewModel.didMappingFinish = {
            self.updateIsSkip()
            self.tableView.reloadData()
        }
        
        self.viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.mappingData()
        Defaults[.screenId] = ""
    }
    
    func setupNavBar() {
        self.customNavigationBar(.primary, title: "", textColor: UIColor.Asset.white)
        let leftIcon = NavBarButtonType.back.barButton
        leftIcon.addTarget(self, action: #selector(leftButtonAction), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftIcon)
    }
    
    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: ProfileNibVars.TableViewCell.about, bundle: ConfigBundle.profile), forCellReuseIdentifier: ProfileNibVars.TableViewCell.about)
        self.tableView.register(UINib(nibName: ProfileNibVars.TableViewCell.dob, bundle: ConfigBundle.profile), forCellReuseIdentifier: ProfileNibVars.TableViewCell.dob)
        self.tableView.register(UINib(nibName: ProfileNibVars.TableViewCell.addLink, bundle: ConfigBundle.profile), forCellReuseIdentifier: ProfileNibVars.TableViewCell.addLink)
        self.tableView.register(UINib(nibName: ProfileNibVars.TableViewCell.social, bundle: ConfigBundle.profile), forCellReuseIdentifier: ProfileNibVars.TableViewCell.social)
        self.tableView.register(UINib(nibName: ProfileNibVars.TableViewCell.complate, bundle: ConfigBundle.profile), forCellReuseIdentifier: ProfileNibVars.TableViewCell.complate)
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }
    
    private func updateIsSkip() {
        if self.viewModel.avatarType == .page {
            if !self.viewModel.socialLinkShelf.socialLinks.isEmpty || !self.viewModel.overView.isEmpty {
                self.viewModel.isSkip = false
            } else {
                self.viewModel.isSkip = true
            }
        } else {
            if !self.viewModel.socialLinkShelf.socialLinks.isEmpty || !self.viewModel.overView.isEmpty || !self.viewModel.dobDisplay.isEmpty {
                self.viewModel.isSkip = false
            } else {
                self.viewModel.isSkip = true
            }
        }
    }
    
    private func reloadButton() {
        self.tableView.reloadSections(IndexSet(integer: AboutInfoViewControllerSection.submit.rawValue), with: .none)
    }
    
    @objc private func leftButtonAction() {
        if self.viewModel.avatarType == .user {
            Utility.currentViewController().navigationController?.popToRootViewController(animated: true)
        } else {
            let viewControllers: [UIViewController] = Utility.currentViewController().navigationController!.viewControllers as [UIViewController]
            Utility.currentViewController().navigationController!.popToViewController(viewControllers[viewControllers.count - 5], animated: true)
        }
    }
}

extension AboutInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return AboutInfoViewControllerSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case AboutInfoViewControllerSection.dob.rawValue:
            return (self.viewModel.avatarType == .page ? 0 : 1)
        case AboutInfoViewControllerSection.social.rawValue:
            return self.viewModel.socialLinkShelf.socialLinks.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case AboutInfoViewControllerSection.overview.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileNibVars.TableViewCell.about, for: indexPath as IndexPath) as? AboutTableViewCell
            cell?.backgroundColor = UIColor.clear
            cell?.delegate = self
            return cell ?? AboutTableViewCell()
        case AboutInfoViewControllerSection.dob.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileNibVars.TableViewCell.dob, for: indexPath as IndexPath) as? DobTableViewCell
            cell?.backgroundColor = UIColor.clear
            cell?.delegate = self
            return cell ?? DobTableViewCell()
        case AboutInfoViewControllerSection.addSocial.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileNibVars.TableViewCell.addLink, for: indexPath as IndexPath) as? AddLinkTableViewCell
            cell?.backgroundColor = UIColor.clear
            return cell ?? AddLinkTableViewCell()
        case AboutInfoViewControllerSection.social.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileNibVars.TableViewCell.social, for: indexPath as IndexPath) as? SocialTableViewCell
            cell?.backgroundColor = UIColor.clear
            cell?.socialLink = self.viewModel.socialLinkShelf.socialLinks[indexPath.row]
            return cell ?? SocialTableViewCell()
        case AboutInfoViewControllerSection.submit.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileNibVars.TableViewCell.complate, for: indexPath as IndexPath) as? ComplateTableViewCell
            cell?.backgroundColor = UIColor.clear
            cell?.delegate = self
            cell?.configCell(isSkip: self.viewModel.isSkip)
            return cell ?? ComplateTableViewCell()
        default:
            return UITableViewCell()
        }
    }
}

extension AboutInfoViewController: AboutTableViewCellDelegate {
    func didUpdateData(_ aboutTableViewCell: AboutTableViewCell, overview: String) {
        self.viewModel.overView = overview
        self.updateIsSkip()
        self.reloadButton()
    }
}

extension AboutInfoViewController: DobTableViewCellDelegate {
    func didUpdateData(_ dobTableViewCell: DobTableViewCell, date: Date, displayDate: String) {
        self.viewModel.dobDate = date
        self.viewModel.dobDisplay = displayDate
        self.updateIsSkip()
        self.reloadButton()
    }
}

extension AboutInfoViewController: ComplateTableViewCellDelegate {
    func didDone(_ complateTableViewCell: ComplateTableViewCell, skip: Bool) {
        if self.viewModel.avatarType == .user {
            if skip {
                Utility.currentViewController().navigationController?.popToRootViewController(animated: true)
            } else {
                self.viewModel.updateUserInfo()
            }
        } else {
            if skip {
                let viewControllers: [UIViewController] = Utility.currentViewController().navigationController!.viewControllers as [UIViewController]
                Utility.currentViewController().navigationController!.popToViewController(viewControllers[viewControllers.count - 5], animated: true)
            } else {
                self.viewModel.updatePageInfo()
            }
        }
    }
}

extension AboutInfoViewController: AboutInfoViewModelDelegate {
    func didUpdateUserInfoFinish(success: Bool) {
        if success {
            Utility.currentViewController().navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func didUpdatePageInfoFinish(success: Bool) {
        if success {
            let viewControllers: [UIViewController] = Utility.currentViewController().navigationController!.viewControllers as [UIViewController]
            Utility.currentViewController().navigationController!.popToViewController(viewControllers[viewControllers.count - 5], animated: true)
        }
    }
}
