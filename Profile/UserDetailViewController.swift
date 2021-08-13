//
//  UserDetailViewController.swift
//  Profile
//
//  Created by Tanakorn Phoochaliaw on 13/8/2564 BE.
//

import UIKit
import Component

class UserDetailViewController: UIViewController, UIScrollViewDelegate, TPDataSource, TPProgressDelegate {

    var headerVC: MeHeaderViewController?
    var bottomVC: UserInfoTabStripViewController!
    
    var isMe = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.setupNavBar()
        self.tp_configure(with: self, delegate: self)
    }
    
    func setupNavBar() {
        if self.isMe {
            self.customNavigationBar(.secondary, title: "Tommy Cruise")
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
