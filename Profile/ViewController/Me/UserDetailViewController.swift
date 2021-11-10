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
//  UserDetailViewController.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 13/8/2564 BE.
//

import UIKit
import Core
import Networking
import Component
import Defaults

class UserDetailViewController: UIViewController, UIScrollViewDelegate, TPDataSource, TPProgressDelegate {

    @IBOutlet var emptyView: UIView!
    @IBOutlet var emptyTitleLabel: UILabel!
    @IBOutlet var emptyDetailLabel: UILabel!
    
    var headerVC: MeHeaderViewController?
    var bottomVC: UserInfoTabStripViewController!
    var viewModel = UserDetailViewModel(profileType: .unknow, castcleId: nil, displayName: "", page: nil)
    let refresh = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.emptyTitleLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.emptyTitleLabel.textColor = UIColor.Asset.white
        self.emptyDetailLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.emptyDetailLabel.textColor = UIColor.Asset.lightGray
        
        self.setupNavBar()
        if self.viewModel.profileType == .me {
            self.emptyView.isHidden = true
            self.configure(with: self, delegate: self)
        } else if self.viewModel.profileType != .unknow {
            self.emptyView.isHidden = true
        } else {
            self.emptyView.isHidden = false
        }
        
        self.viewModel.didGetUserInfoFinish = {
            self.configure(with: self, delegate: self)
        }
        
        self.viewModel.didGetPageInfoFinish = {
            self.configure(with: self, delegate: self)
        }
    }
    
    @objc func handleRefreshControl() {
        NotificationCenter.default.post(name: .getUserInfo, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Defaults[.screenId] = ScreenId.profileTimeline.rawValue
    }
    
    func setupNavBar() {
        if self.viewModel.profileType == .me {
            self.customNavigationBar(.secondary, title: UserManager.shared.displayName)
        } else if self.viewModel.profileType == .myPage || self.viewModel.profileType == .page {
            self.customNavigationBar(.secondary, title: self.viewModel.page.displayName)
        } else {
            self.customNavigationBar(.secondary, title: self.viewModel.displayName)
        }
    }
    
    //MARK: TPDataSource
    func headerViewController() -> UIViewController {
        let vc = ProfileOpener.open(.meHeader(MeHeaderViewModel(profileType: self.viewModel.profileType, pageInfo: self.viewModel.pageInfo, userInfo: self.viewModel.userInfo))) as? MeHeaderViewController
        vc?.delegate = self
        self.headerVC = vc
        return self.headerVC ?? MeHeaderViewController()
    }
    
    func bottomViewController() -> UIViewController & PagerAwareProtocol {
        self.bottomVC = ProfileOpener.open(.infoTab) as? UserInfoTabStripViewController
        self.bottomVC.profileType = self.viewModel.profileType
        self.bottomVC.page = self.viewModel.page
        self.bottomVC.castcleId = self.viewModel.castcleId
        return self.bottomVC ?? UserInfoTabStripViewController()
    }
    
    //stop scrolling header at this point
    func minHeaderHeight() -> CGFloat {
        return (topInset)
    }
    
    //MARK: TPProgressDelegate
    func tp_scrollView(_ scrollView: UIScrollView, didUpdate progress: CGFloat) {
    }
    
    func tp_scrollViewDidLoad(_ scrollView: UIScrollView) {
        self.refresh.tintColor = .white
        self.refresh.addTarget(self, action: #selector(self.handleRefreshControl), for: .valueChanged)
        
        let refreshView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        scrollView.addSubview(refreshView)
        refreshView.addSubview(refresh)
    }
}

extension UserDetailViewController: MeHeaderViewControllerDelegate {
    func didUpdateProfileFinish() {
        self.refresh.endRefreshing()
        NotificationCenter.default.post(name: .reloadMyContent, object: nil)
    }
}
