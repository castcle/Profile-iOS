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
//  DeletePageViewController.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 18/10/2564 BE.
//

import UIKit
import Core
import Networking
import Defaults
import Kingfisher

class DeletePageViewController: UIViewController {

    @IBOutlet var headlineLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var confirmLabel: UILabel!
    @IBOutlet var displayNameLabel: UILabel!
    @IBOutlet var pageLabel: UILabel!
    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var line1View: UIView!
    @IBOutlet var line2View: UIView!
    
    var viewModel = DeletePageViewModel(page: PageInfo())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.setupNavBar()
        self.headlineLabel.font = UIFont.asset(.regular, fontSize: .title)
        self.headlineLabel.textColor = UIColor.Asset.white
        self.subtitleLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.subtitleLabel.textColor = UIColor.Asset.white
        self.confirmLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.confirmLabel.textColor = UIColor.Asset.white
        self.displayNameLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.displayNameLabel.textColor = UIColor.Asset.white
        self.pageLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.pageLabel.textColor = UIColor.Asset.white
        self.avatarImage.circle(color: UIColor.Asset.white)
        self.line1View.backgroundColor = UIColor.Asset.black
        self.line2View.backgroundColor = UIColor.Asset.black
        self.deleteButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .body)
        self.deleteButton.setTitleColor(UIColor.Asset.white, for: .normal)
        self.deleteButton.capsule(color: UIColor.Asset.lightBlue, borderWidth: 1, borderColor: UIColor.Asset.lightBlue)
        
        let url = URL(string: self.viewModel.page.images.avatar.thumbnail)
        self.avatarImage.kf.setImage(with: url, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
        self.displayNameLabel.text = self.viewModel.page.displayName
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Defaults[.screenId] = ""
    }
    
    func setupNavBar() {
        self.customNavigationBar(.secondary, title: "Delete page")
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        Utility.currentViewController().navigationController?.pushViewController(ProfileOpener.open(.confirmDeletePage(DeletePageViewModel(page: self.viewModel.page))), animated: true)
    }
}
