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
//  Created by Tanakorn Phoochaliaw on 6/8/2564 BE.
//

import UIKit
import Core
import Component
import IGListKit
import Defaults

class AboutInfoViewController: UIViewController {

    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        return view
    }()
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    enum AboutType: String {
        case about
        case social
    }
    
    var viewModel = AboutInfoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.hideKeyboardWhenTapped()
        self.setupNavBar()
        
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.backgroundColor = UIColor.clear
        self.view.addSubview(self.collectionView)
        self.adapter.collectionView = self.collectionView
        self.adapter.dataSource = self
        
        self.viewModel.clearData()
        self.viewModel.didMappingFinish = {
            self.adapter.performUpdates(animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.collectionView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.mappingData()
        Defaults[.screenId] = ""
    }
    
    func setupNavBar() {
        self.customNavigationBar(.secondary, title: "", secondaryBackType: .root)
    }
}

// MARK: - ListAdapterDataSource
extension AboutInfoViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var items: [ListDiffable] = [AboutType.about.rawValue] as [ListDiffable]
        items.append(AboutType.social.rawValue as ListDiffable)
        
        self.viewModel.socialLinkShelf.socialLinks.forEach { socialLink in
            items.append(socialLink as ListDiffable)
        }
        
        items.append(self.viewModel.isSkip as ListDiffable)
        return items
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is SocialLink {
            return SocialSectionController()
        } else if object is Bool {
            return ComplateButtonSectionController()
        } else {
            if (object as! String) == AboutType.social.rawValue {
                return SocialLinkSectionController()
            } else {
                let aboutSection = AboutSectionController()
                aboutSection.delegate = self
                return aboutSection
            }
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension AboutInfoViewController: AboutSectionControllerDelegate {
    func didUpdateData(isUpdate: Bool) {
        if isUpdate {
            if self.viewModel.isSkip == true {
                self.viewModel.isSkip = false
                self.adapter.performUpdates(animated: true)
            }
        } else {
            if self.viewModel.isSkip == false {
                self.viewModel.isSkip = true
                self.adapter.performUpdates(animated: true)
            }
        }
    }
}
