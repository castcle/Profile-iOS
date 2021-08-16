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
//  Created by Tanakorn Phoochaliaw on 13/8/2564 BE.
//

import UIKit
import Core
import Component

class UserDetailViewController: UIViewController, UIScrollViewDelegate, TPDataSource, TPProgressDelegate {

    var headerVC: MeHeaderViewController?
    var bottomVC: UserInfoTabStripViewController!
    
    var viewModel = UserDetailViewModel(isMe: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.setupNavBar()
        self.tp_configure(with: self, delegate: self)
    }
    
    func setupNavBar() {
        if self.viewModel.isMe {
            self.customNavigationBar(.secondary, title: UserState.shared.name)
        } else {
            self.customNavigationBar(.secondary, title: "Alexandra Daddario")
        }
        
        var rightButton: [UIBarButtonItem] = []
        
        let icon = NavBarButtonType.menu.barButton
        icon.addTarget(self, action: #selector(menuAction), for: .touchUpInside)
        rightButton.append(UIBarButtonItem(customView: icon))

        self.navigationItem.rightBarButtonItems = rightButton
    }
    
    @objc private func menuAction() {
        print("Menu")
    }
    
    //MARK: TPDataSource
    func headerViewController() -> UIViewController {
        self.headerVC = ProfileOpener.open(.meHeader) as? MeHeaderViewController
        self.headerVC?.isMe = false
        return self.headerVC ?? MeHeaderViewController()
    }
    
    func bottomViewController() -> UIViewController & PagerAwareProtocol {
        self.bottomVC =  ProfileOpener.open(.infoTab) as? UserInfoTabStripViewController
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
    }

}
