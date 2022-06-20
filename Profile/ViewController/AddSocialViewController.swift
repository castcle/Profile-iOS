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
//  AddSocialViewController.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 6/8/2564 BE.
//

import UIKit
import Core
import IGListKit
import Defaults

class AddSocialViewController: UIViewController {

    let addSocialcollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        return view
    }()

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()

    enum AddSocialType: Int {
        case social = 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.hideKeyboardWhenTapped()
        self.addSocialcollectionView.alwaysBounceVertical = true
        self.addSocialcollectionView.showsHorizontalScrollIndicator = false
        self.addSocialcollectionView.showsVerticalScrollIndicator = false
        self.addSocialcollectionView.backgroundColor = UIColor.clear
        self.view.addSubview(self.addSocialcollectionView)
        self.adapter.collectionView = self.addSocialcollectionView
        self.adapter.dataSource = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.addSocialcollectionView.frame = view.bounds
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Defaults[.screenId] = ""
        self.setupNavBar()
    }

    func setupNavBar() {
        self.customNavigationBar(.secondary, title: Localization.AddSocial.title.text)
        var rightButton: [UIBarButtonItem] = []
        let icon = UIButton()
        icon.setTitle(Localization.AddSocial.apply.text, for: .normal)
        icon.titleLabel?.font = UIFont.asset(.bold, fontSize: .head4)
        icon.setTitleColor(UIColor.Asset.lightBlue, for: .normal)
        icon.addTarget(self, action: #selector(applyAction), for: .touchUpInside)
        rightButton.append(UIBarButtonItem(customView: icon))

        self.navigationItem.rightBarButtonItems = rightButton
    }

    @objc private func applyAction() {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - ListAdapterDataSource
extension AddSocialViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        let items: [ListDiffable] = [AddSocialType.social.rawValue] as [ListDiffable]
        return items
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return AddSocialSectionController()
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
