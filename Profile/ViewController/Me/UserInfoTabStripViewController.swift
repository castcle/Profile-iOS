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
//  UserInfoTabStripViewController.swift
//  Profile
//
//  Created by Tanakorn Phoochaliaw on 13/8/2564 BE.
//

import UIKit
import Core
import Component
import XLPagerTabStrip

class UserInfoTabStripViewController: ButtonBarPagerTabStripViewController, PagerAwareProtocol {

    //MARK: PagerAwareProtocol
    var pageDelegate: BottomPageDelegate?
    
    var currentViewController: UIViewController?{
        return viewControllers[currentIndex]
    }
    
    var pagerTabHeight: CGFloat?{
        return 60
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        settings.style.buttonBarBackgroundColor = UIColor.Asset.darkGraphiteBlue
        settings.style.buttonBarItemBackgroundColor = UIColor.Asset.darkGraphiteBlue
        settings.style.selectedBarBackgroundColor = UIColor.Asset.lightBlue
        settings.style.buttonBarItemTitleColor = UIColor.Asset.lightBlue
        settings.style.selectedBarHeight = 4
        settings.style.buttonBarItemFont = UIFont.asset(.medium, fontSize: .body)
        settings.style.buttonBarHeight = 60.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        self.changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            oldCell?.label.textColor = UIColor.Asset.white
            newCell?.label.textColor = UIColor.Asset.lightBlue
        }
    }
    

    // MARK: - PagerTabStripDataSource
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let vc = ProfileOpener.open(.userFeed(UserFeedViewModel(userFeedType: .all))) as? UserFeedViewController
        vc?.pageIndex = 0
        vc?.pageTitle = "All"
        let child_1 = vc ?? UserFeedViewController()
        
        let vc1 = ProfileOpener.open(.userFeed(UserFeedViewModel(userFeedType: .post))) as? UserFeedViewController
        vc1?.pageIndex = 1
        vc1?.pageTitle = "Post"
        let child_2 = vc1 ?? UserFeedViewController()

        let vc2 = ProfileOpener.open(.userFeed(UserFeedViewModel(userFeedType: .blog))) as? UserFeedViewController
        vc2?.pageIndex = 2
        vc2?.pageTitle = "Blog"
        let child_3 = vc2 ?? UserFeedViewController()

        let vc3 = ProfileOpener.open(.userFeed(UserFeedViewModel(userFeedType: .photo))) as? UserFeedViewController
        vc3?.pageIndex = 3
        vc3?.pageTitle = "Photo"
        let child_4 = vc3 ?? UserFeedViewController()

        return [child_1, child_2, child_3, child_4]
    }

    override func reloadPagerTabStripView() {
        self.pagerBehaviour = .progressive(skipIntermediateViewControllers: arc4random() % 2 == 0, elasticIndicatorLimit: arc4random() % 2 == 0 )
        super.reloadPagerTabStripView()
    }
    
    override func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int, withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool) {
        super.updateIndicator(for: viewController, fromIndex: fromIndex, toIndex: toIndex, withProgressPercentage: progressPercentage, indexWasChanged: indexWasChanged)
        
        guard indexWasChanged == true else { return }

        //IMPORTANT!!!: call the following to let the master scroll controller know which view to control in the bottom section
        self.pageDelegate?.pageViewController(self.currentViewController, didSelectPageAt: toIndex)

    }
}
