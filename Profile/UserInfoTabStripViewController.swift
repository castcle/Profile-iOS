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

        delegate = self
        
        self.changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            oldCell?.label.textColor = UIColor.Asset.white
            newCell?.label.textColor = UIColor.Asset.lightBlue
        }
    }
    

    // MARK: - PagerTabStripDataSource
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let vc = ProfileOpener.open(.list) as? ListViewController
        vc?.pageIndex = 0
        vc?.pageTitle = "All"
        let child_1 = vc ?? ListViewController()
        
        let vc1 = ProfileOpener.open(.list) as? ListViewController
        vc1?.pageIndex = 1
        vc1?.pageTitle = "Post"
        let child_2 = vc1 ?? ListViewController()
        
        let vc2 = ProfileOpener.open(.list) as? ListViewController
        vc2?.pageIndex = 2
        vc2?.pageTitle = "Blog"
        let child_3 = vc2 ?? ListViewController()
        
        let vc3 = ProfileOpener.open(.list) as? ListViewController
        vc3?.pageIndex = 3
        vc3?.pageTitle = "Photo"
        let child_4 = vc3 ?? ListViewController()

        return [child_1, child_2, child_3, child_4]
    }

    override func reloadPagerTabStripView() {
        pagerBehaviour = .progressive(skipIntermediateViewControllers: arc4random() % 2 == 0, elasticIndicatorLimit: arc4random() % 2 == 0 )
        super.reloadPagerTabStripView()
    }
    
    override func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int, withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool) {
        super.updateIndicator(for: viewController, fromIndex: fromIndex, toIndex: toIndex, withProgressPercentage: progressPercentage, indexWasChanged: indexWasChanged)
        
        guard indexWasChanged == true else { return }

        //IMPORTANT!!!: call the following to let the master scroll controller know which view to control in the bottom section
        self.pageDelegate?.tp_pageViewController(self.currentViewController, didSelectPageAt: toIndex)

    }
}
