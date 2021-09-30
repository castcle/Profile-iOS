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
//  UserFeedViewController.swift
//  Profile
//
//  Created by Tanakorn Phoochaliaw on 13/8/2564 BE.
//

import UIKit
import Core
import Networking
import Post
import Component
import Authen
import XLPagerTabStrip
import IGListKit

class UserFeedViewController: UIViewController {

    var pageIndex: Int = 0
    var pageTitle: String?
    
    @IBOutlet var tableView: UITableView!
    
    var viewModel = UserFeedViewModel(userFeedType: .unknow)
    
    enum FeedSection: Int, CaseIterable {
        case header = 0
        case content
        case footer
    }
    
    enum FeedCellType {
        case header
        case content
        case footer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.viewModel.delegate = self
        self.configureTableView()
        
        self.viewModel.didLoadFeedgsFinish = {
            UIView.transition(with: self.tableView, duration: 0.35, options: .transitionCrossDissolve, animations: {
                self.tableView.reloadData()
            })
        }
    }
    
    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: ComponentNibVars.TableViewCell.headerFeed, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.headerFeed)
        self.tableView.register(UINib(nibName: ComponentNibVars.TableViewCell.footerFeed, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.footerFeed)
        self.tableView.register(UINib(nibName: ComponentNibVars.TableViewCell.postText, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.postText)
        self.tableView.register(UINib(nibName: ComponentNibVars.TableViewCell.postTextLink, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.postTextLink)
        self.tableView.register(UINib(nibName: ComponentNibVars.TableViewCell.imageX1, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.imageX1)
        self.tableView.register(UINib(nibName: ComponentNibVars.TableViewCell.imageX2, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.imageX2)
        self.tableView.register(UINib(nibName: ComponentNibVars.TableViewCell.imageX3, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.imageX3)
        self.tableView.register(UINib(nibName: ComponentNibVars.TableViewCell.imageXMore, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.imageXMore)
        self.tableView.register(UINib(nibName: ComponentNibVars.TableViewCell.blog, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.blog)
        self.tableView.register(UINib(nibName: ComponentNibVars.TableViewCell.blogNoImage, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.blogNoImage)
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }
}

extension UserFeedViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.contents.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FeedSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let content = self.viewModel.contents[indexPath.section]
        switch indexPath.row {
        case FeedSection.header.rawValue:
            return self.renderFeedCell(content: content, cellType: .header, tableView: tableView, indexPath: indexPath)
        case FeedSection.footer.rawValue:
            return self.renderFeedCell(content: content, cellType: .footer, tableView: tableView, indexPath: indexPath)
        default:
            return self.renderFeedCell(content: content, cellType: .content, tableView: tableView, indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 5))
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    func renderFeedCell(content: Content, cellType: FeedCellType, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch cellType {
        case .header:
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.headerFeed, for: indexPath as IndexPath) as? HeaderTableViewCell
            cell?.backgroundColor = UIColor.Asset.darkGray
            cell?.delegate = self
            cell?.content = content
            return cell ?? HeaderTableViewCell()
        case .footer:
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.footerFeed, for: indexPath as IndexPath) as? FooterTableViewCell
            cell?.backgroundColor = UIColor.Asset.darkGray
            cell?.delegate = self
            cell?.content = content
            return cell ?? FooterTableViewCell()
        default:
            return FeedCellHelper().renderFeedCell(content: content, tableView: self.tableView, indexPath: indexPath)
        }
    }
}

extension UserFeedViewController: HeaderTableViewCellDelegate {
    func didRemoveSuccess(_ headerTableViewCell: HeaderTableViewCell) {
        if let indexPath = self.tableView.indexPath(for: headerTableViewCell) {
            self.viewModel.contents.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
    }
    
    func didTabProfile(_ headerTableViewCell: HeaderTableViewCell) {
        Utility.currentViewController().navigationController?.pushViewController(ProfileOpener.open(.userDetail(UserDetailViewModel(isMe: false))), animated: true)
    }
    
    func didAuthen(_ headerTableViewCell: HeaderTableViewCell) {
        Utility.currentViewController().presentPanModal(AuthenOpener.open(.signUpMethod) as! SignUpMethodViewController)
    }
}

extension UserFeedViewController: FooterTableViewCellDelegate {
    func didTabComment(_ footerTableViewCell: FooterTableViewCell, content: Content) {
        let commentNavi: UINavigationController = UINavigationController(rootViewController: ComponentOpener.open(.comment(CommentViewModel(content: content))))
        commentNavi.modalPresentationStyle = .fullScreen
        commentNavi.modalTransitionStyle = .crossDissolve
        Utility.currentViewController().present(commentNavi, animated: true)
    }
    
    func didTabQuoteCast(_ footerTableViewCell: FooterTableViewCell, content: Content, page: Page) {
        let vc = PostOpener.open(.post(PostViewModel(postType: .quoteCast, content: content, page: page)))
        vc.modalPresentationStyle = .fullScreen
        Utility.currentViewController().present(vc, animated: true, completion: nil)
    }
    
    func didAuthen(_ footerTableViewCell: FooterTableViewCell) {
        Utility.currentViewController().presentPanModal(AuthenOpener.open(.signUpMethod) as! SignUpMethodViewController)
    }
}

extension UserFeedViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo.init(title: pageTitle ?? "Tab \(pageIndex)")
    }
}

extension UserFeedViewController: UserFeedViewModelDelegate {
    func didGetContentFinish(success: Bool) {
        if success {
            UIView.transition(with: self.tableView, duration: 0.35, options: .transitionCrossDissolve, animations: {
                self.tableView.reloadData()
            })
        }
    }
}
