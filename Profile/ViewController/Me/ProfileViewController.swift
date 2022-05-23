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
//  ProfileViewController.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 31/12/2564 BE.
//

import UIKit
import Core
import Component
import Networking
import Authen
import Farming
import Defaults

class ProfileViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    var profileViewModel = ProfileViewModel(profileType: .unknow, castcleId: "", displayName: "")
    var profileFeedViewModel = ProfileFeedViewModel(profileContentType: .unknow, profileType: .unknow, castcleId: "")

    enum ProfileViewControllerSection: Int, CaseIterable {
        case header = 0
        case munu
    }

    enum PeofileHeaderRaw: Int, CaseIterable {
        case info = 0
        case post
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.configureTableView()
        self.tableView.isScrollEnabled = false
        self.tableView.coreRefresh.addHeadRefresh(animator: FastAnimator()) { [weak self] in
            guard let self = self else { return }
            if self.profileViewModel.isBlocked {
                self.tableView.coreRefresh.endHeaderRefresh()
            } else {
                self.tableView.coreRefresh.resetNoMore()
                self.tableView.isScrollEnabled = false
                self.profileViewModel.loadState = .loading
                self.tableView.reloadData()
                self.profileViewModel.getProfile()
                self.profileFeedViewModel.resetContent()
            }
        }

        self.tableView.coreRefresh.addFootRefresh(animator: NormalFooterAnimator()) {
            if self.profileViewModel.isBlocked {
                self.tableView.coreRefresh.noticeNoMoreData()
            } else {
                if self.profileFeedViewModel.feedCanLoad {
                    self.profileFeedViewModel.getContents()
                } else {
                    self.tableView.coreRefresh.noticeNoMoreData()
                }
            }
        }

        self.profileFeedViewModel.delegate = self
        self.profileFeedViewModel.getContents()

        self.profileViewModel.didGetMeInfoFinish = {
            self.profileViewModel.loadState = .loaded
            self.tableView.coreRefresh.endHeaderRefresh()
            self.tableView.isScrollEnabled = true
            UIView.transition(with: self.view, duration: 0.35, options: .transitionCrossDissolve, animations: {
                self.tableView.reloadData()
            })
        }

        self.profileViewModel.didGetUserInfoFinish = {
            self.profileViewModel.loadState = .loaded
            self.tableView.coreRefresh.endHeaderRefresh()
            self.tableView.isScrollEnabled = true
            UIView.transition(with: self.view, duration: 0.35, options: .transitionCrossDissolve, animations: {
                self.tableView.reloadData()
            })
        }

        self.profileViewModel.didGetUserInfoFalse = {
            self.profileViewModel.loadState = .error
            self.tableView.coreRefresh.endHeaderRefresh()
            self.tableView.isScrollEnabled = false
            self.customNavigationBar(.secondary, title: "Error")
            UIView.transition(with: self.view, duration: 0.35, options: .transitionCrossDissolve, animations: {
                self.tableView.reloadData()
            })
        }

        NotificationCenter.default.addObserver(self, selector: #selector(self.getContent(notification:)), name: .getMyContent, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavBar()
        if self.profileViewModel.profileType == .mine {
            Defaults[.screenId] = ScreenId.profileTimeline.rawValue
        } else {
            if self.profileViewModel.userInfo.type == .people {
                Defaults[.screenId] = ScreenId.profileTimeline.rawValue
            } else {
                Defaults[.screenId] = ScreenId.pageTimeline.rawValue
            }
        }
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.profileViewModel.profileType == .mine {
            EngagementHelper().sendCastcleAnalytic(event: .onScreenView, screen: .profileTimeline)
        } else {
            if self.profileViewModel.userInfo.type == .people {
                EngagementHelper().sendCastcleAnalytic(event: .onScreenView, screen: .profileTimeline)
            } else {
                EngagementHelper().sendCastcleAnalytic(event: .onScreenView, screen: .pageTimeline)
            }
        }
    }

    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: ProfileNibVars.TableViewCell.profileHeader, bundle: ConfigBundle.profile), forCellReuseIdentifier: ProfileNibVars.TableViewCell.profileHeader)
        self.tableView.register(UINib(nibName: ProfileNibVars.TableViewCell.feedHeader, bundle: ConfigBundle.profile), forCellReuseIdentifier: ProfileNibVars.TableViewCell.feedHeader)
        self.tableView.register(UINib(nibName: ProfileNibVars.TableViewCell.profileHeaderSkeleton, bundle: ConfigBundle.profile), forCellReuseIdentifier: ProfileNibVars.TableViewCell.profileHeaderSkeleton)
        self.tableView.register(UINib(nibName: ProfileNibVars.TableViewCell.profilePost, bundle: ConfigBundle.profile), forCellReuseIdentifier: ProfileNibVars.TableViewCell.profilePost)
        self.tableView.register(UINib(nibName: ProfileNibVars.TableViewCell.headerBlocked, bundle: ConfigBundle.profile), forCellReuseIdentifier: ProfileNibVars.TableViewCell.headerBlocked)
        self.tableView.register(UINib(nibName: ProfileNibVars.TableViewCell.blockedUser, bundle: ConfigBundle.profile), forCellReuseIdentifier: ProfileNibVars.TableViewCell.blockedUser)
        self.tableView.register(UINib(nibName: ProfileNibVars.TableViewCell.userNotFound, bundle: ConfigBundle.profile), forCellReuseIdentifier: ProfileNibVars.TableViewCell.userNotFound)
        self.tableView.registerFeedCell()
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }

    func setupNavBar() {
        if self.profileViewModel.profileType == .mine {
            self.customNavigationBar(.secondary, title: UserManager.shared.displayName)
        } else {
            self.customNavigationBar(.secondary, title: self.profileViewModel.displayName)
        }
    }

    @objc func getContent(notification: NSNotification) {
        self.profileFeedViewModel.resetContent()
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.profileViewModel.loadState == .error {
            return 1
        } else {
            if self.profileFeedViewModel.feedLoaded {
                if self.profileViewModel.isBlocked {
                    return 3
                } else {
                    return 2 + self.profileFeedViewModel.displayContents.count
                }
            } else {
                return 10
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == ProfileViewControllerSection.header.rawValue {
            if self.profileViewModel.loadState == .loaded && (self.profileViewModel.profileType == .mine || self.profileViewModel.isMyPage) {
                return 2
            } else {
                return 1
            }
        } else if section == ProfileViewControllerSection.munu.rawValue {
            return 0
        } else {
            if self.profileViewModel.loadState == .error {
                return 0
            } else {
                if self.profileFeedViewModel.feedLoaded {
                    if self.profileViewModel.isBlocked {
                        return 1
                    } else {
                        let content = self.profileFeedViewModel.displayContents[section - 2]
                        if content.referencedCasts.type == .recasted || content.referencedCasts.type == .quoted {
                            return 4
                        } else {
                            return 3
                        }
                    }
                } else {
                    return 1
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == PeofileHeaderRaw.info.rawValue {
                if self.profileViewModel.loadState == .error {
                    let cell = tableView.dequeueReusableCell(withIdentifier: ProfileNibVars.TableViewCell.userNotFound, for: indexPath as IndexPath) as? UserNotFoundTableViewCell
                    cell?.backgroundColor = UIColor.clear
                    return cell ?? UserNotFoundTableViewCell()
                } else if self.profileViewModel.loadState == .loaded {
                    if self.profileViewModel.isBlocked {
                        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileNibVars.TableViewCell.headerBlocked, for: indexPath as IndexPath) as? HeaderBlockedTableViewCell
                        cell?.backgroundColor = UIColor.Asset.darkGray
                        cell?.configCell(userInfo: self.profileViewModel.userInfo)
                        return cell ?? HeaderBlockedTableViewCell()
                    } else {
                        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileNibVars.TableViewCell.profileHeader, for: indexPath as IndexPath) as? ProfileHeaderTableViewCell
                        cell?.delegate = self
                        cell?.backgroundColor = UIColor.Asset.darkGray
                        cell?.configCell(viewModel: ProfileHeaderViewModel(profileType: self.profileViewModel.profileType, userInfo: self.profileViewModel.userInfo))
                        return cell ?? ProfileHeaderTableViewCell()
                    }
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: ProfileNibVars.TableViewCell.profileHeaderSkeleton, for: indexPath as IndexPath) as? ProfileHeaderSkeletonTableViewCell
                    cell?.backgroundColor = UIColor.Asset.darkGray
                    return cell ?? ProfileHeaderSkeletonTableViewCell()
                }
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileNibVars.TableViewCell.profilePost, for: indexPath as IndexPath) as? ProfilePostTableViewCell
                cell?.backgroundColor = UIColor.Asset.darkGray
                cell?.configCell(profileType: self.profileViewModel.profileType, userInfo: self.profileViewModel.userInfo)
                return cell ?? ProfilePostTableViewCell()
            }
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileNibVars.TableViewCell.feedHeader, for: indexPath as IndexPath) as? FeedHeaderTableViewCell
            cell?.delegate = self
            cell?.backgroundColor = UIColor.Asset.darkGraphiteBlue
            cell?.configCell(profileContentType: self.profileFeedViewModel.profileContentType)
            return cell ?? FeedHeaderTableViewCell()
        } else {
            if self.profileFeedViewModel.feedLoaded {
                if self.profileViewModel.isBlocked {
                    let cell = tableView.dequeueReusableCell(withIdentifier: ProfileNibVars.TableViewCell.blockedUser, for: indexPath as IndexPath) as? BlockedUserTableViewCell
                    cell?.delegate = self
                    cell?.backgroundColor = UIColor.Asset.darkGraphiteBlue
                    cell?.configCell(castcleId: self.profileViewModel.castcleIdBlock)
                    return cell ?? BlockedUserTableViewCell()
                } else {
                    let content = self.profileFeedViewModel.displayContents[indexPath.section - 2]
                    if content.referencedCasts.type == .recasted {
                        if indexPath.row == 0 {
                            return self.renderFeedCell(content: content, cellType: .activity, tableView: tableView, indexPath: indexPath)
                        } else if indexPath.row == 1 {
                            return self.renderFeedCell(content: content, cellType: .header, tableView: tableView, indexPath: indexPath)
                        } else if indexPath.row == 2 {
                            return self.renderFeedCell(content: content, cellType: .content, tableView: tableView, indexPath: indexPath)
                        } else {
                            return self.renderFeedCell(content: content, cellType: .footer, tableView: tableView, indexPath: indexPath)
                        }
                    } else if content.referencedCasts.type == .quoted {
                        if indexPath.row == 0 {
                            return self.renderFeedCell(content: content, cellType: .header, tableView: tableView, indexPath: indexPath)
                        } else if indexPath.row == 1 {
                            return self.renderFeedCell(content: content, cellType: .content, tableView: tableView, indexPath: indexPath)
                        } else if indexPath.row == 2 {
                            return self.renderFeedCell(content: content, cellType: .quote, tableView: tableView, indexPath: indexPath)
                        } else {
                            return self.renderFeedCell(content: content, cellType: .footer, tableView: tableView, indexPath: indexPath)
                        }
                    } else {
                        if indexPath.row == 0 {
                            return self.renderFeedCell(content: content, cellType: .header, tableView: tableView, indexPath: indexPath)
                        } else if indexPath.row == 1 {
                            return self.renderFeedCell(content: content, cellType: .content, tableView: tableView, indexPath: indexPath)
                        } else {
                            return self.renderFeedCell(content: content, cellType: .footer, tableView: tableView, indexPath: indexPath)
                        }
                    }
                }
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.skeleton, for: indexPath as IndexPath) as? SkeletonFeedTableViewCell
                cell?.backgroundColor = UIColor.Asset.darkGray
                cell?.configCell()
                return cell ?? SkeletonFeedTableViewCell()
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 0
        } else {
            return 5
        }
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
            return UIView()
        } else {
            let footerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 5))
            footerView.backgroundColor = UIColor.clear
            return footerView
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section >= 2 {
            var originalContent = Content()
            let content = self.profileFeedViewModel.displayContents[indexPath.section - 2]
            if content.referencedCasts.type == .recasted || content.referencedCasts.type == .quoted {
                if let tempContent = ContentHelper.shared.getContentRef(id: content.referencedCasts.id) {
                    originalContent = tempContent
                }
            }

            if content.referencedCasts.type == .recasted {
                if originalContent.type == .long && indexPath.row == 2 {
                    self.profileFeedViewModel.displayContents[indexPath.section - 2].isOriginalExpand.toggle()
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            } else {
                if content.type == .long && indexPath.row == 1 {
                    self.profileFeedViewModel.displayContents[indexPath.section - 2].isExpand.toggle()
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }

    func renderFeedCell(content: Content, cellType: FeedCellType, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        var originalContent = Content()
        if content.referencedCasts.type == .recasted || content.referencedCasts.type == .quoted {
            if let tempContent = ContentHelper.shared.getContentRef(id: content.referencedCasts.id) {
                originalContent = tempContent
            }
        }

        switch cellType {
        case .activity:
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.activityHeader, for: indexPath as IndexPath) as? ActivityHeaderTableViewCell
            cell?.backgroundColor = UIColor.Asset.darkGray
            cell?.cellConfig(content: content)
            return cell ?? ActivityHeaderTableViewCell()
        case .header:
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.headerFeed, for: indexPath as IndexPath) as? HeaderTableViewCell
            cell?.backgroundColor = UIColor.Asset.darkGray
            cell?.delegate = self
            if content.referencedCasts.type == .recasted {
                cell?.configCell(feedType: .content, content: originalContent, isDefaultContent: false)
            } else {
                cell?.configCell(feedType: .content, content: content, isDefaultContent: false)
            }
            return cell ?? HeaderTableViewCell()
        case .footer:
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.footerFeed, for: indexPath as IndexPath) as? FooterTableViewCell
            cell?.backgroundColor = UIColor.Asset.darkGray
            cell?.delegate = self
            if content.referencedCasts.type == .recasted {
                cell?.content = originalContent
            } else {
                cell?.content = content
            }
            return cell ?? FooterTableViewCell()
        case .quote:
            return FeedCellHelper().renderQuoteCastCell(content: originalContent, tableView: self.tableView, indexPath: indexPath, isRenderForFeed: true)
        default:
            if content.referencedCasts.type == .recasted {
                if originalContent.type == .long && !content.isOriginalExpand {
                    return FeedCellHelper().renderLongCastCell(content: originalContent, tableView: self.tableView, indexPath: indexPath)
                } else {
                    return FeedCellHelper().renderFeedCell(content: originalContent, tableView: self.tableView, indexPath: indexPath)
                }
            } else {
                if content.type == .long && !content.isExpand {
                    return FeedCellHelper().renderLongCastCell(content: content, tableView: self.tableView, indexPath: indexPath)
                } else {
                    return FeedCellHelper().renderFeedCell(content: content, tableView: self.tableView, indexPath: indexPath)
                }
            }
        }
    }
}

extension ProfileViewController: ProfileHeaderTableViewCellDelegate {
    func didUpdateProfileSuccess(_ profileHeaderTableViewCell: ProfileHeaderTableViewCell) {
        self.tableView.reloadData()
    }

    func didAuthen(_ profileHeaderTableViewCell: ProfileHeaderTableViewCell) {
        NotificationCenter.default.post(name: .openSignInDelegate, object: nil, userInfo: nil)
    }

    func didBlocked(_ profileHeaderTableViewCell: ProfileHeaderTableViewCell) {
        self.profileViewModel.userInfo.blocked = true
        self.tableView.reloadData()
    }
}

extension ProfileViewController: HeaderTableViewCellDelegate {
    func didRemoveSuccess(_ headerTableViewCell: HeaderTableViewCell) {
        if let indexPath = self.tableView.indexPath(for: headerTableViewCell) {
            UIView.transition(with: self.tableView, duration: 0.35, options: .transitionCrossDissolve, animations: {
                self.profileFeedViewModel.removeContentAt(index: indexPath.section - 2)
                self.tableView.reloadData()
            })
        }
    }

    func didTabProfile(_ headerTableViewCell: HeaderTableViewCell, author: Author) {
        ProfileOpener.openProfileDetail(author.castcleId, displayName: author.displayName)
    }

    func didAuthen(_ headerTableViewCell: HeaderTableViewCell) {
        NotificationCenter.default.post(name: .openSignInDelegate, object: nil, userInfo: nil)
    }

    func didReportSuccess(_ headerTableViewCell: HeaderTableViewCell) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            Utility.currentViewController().navigationController?.pushViewController(ComponentOpener.open(.reportSuccess(true, "")), animated: true)
        }

        if let indexPath = self.tableView.indexPath(for: headerTableViewCell) {
            UIView.transition(with: self.tableView, duration: 0.35, options: .transitionCrossDissolve, animations: {
                self.profileFeedViewModel.removeContentAt(index: indexPath.section - 2)
                self.tableView.reloadData()
            })
        }
    }
}

extension ProfileViewController: FooterTableViewCellDelegate {
    func didTabComment(_ footerTableViewCell: FooterTableViewCell, content: Content) {
        Utility.currentViewController().navigationController?.pushViewController(ComponentOpener.open(.comment(CommentViewModel(contentId: content.id))), animated: true)
    }

    func didTabQuoteCast(_ footerTableViewCell: FooterTableViewCell, content: Content, page: Page) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let viewController = PostOpener.open(.post(PostViewModel(postType: .quoteCast, content: content, page: page)))
            viewController.modalPresentationStyle = .fullScreen
            Utility.currentViewController().present(viewController, animated: true, completion: nil)
        }
    }

    func didAuthen(_ footerTableViewCell: FooterTableViewCell) {
        NotificationCenter.default.post(name: .openSignInDelegate, object: nil, userInfo: nil)
    }

    func didViewFarmmingHistory(_ footerTableViewCell: FooterTableViewCell) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            Utility.currentViewController().navigationController?.pushViewController(FarmingOpener.open(.contentFarming), animated: true)
        }
    }
}

extension ProfileViewController: FeedHeaderTableViewCellDelegate {
    func didSelectTab(_ feedHeaderTableViewCell: FeedHeaderTableViewCell, profileContentType: ProfileContentType) {
        if profileContentType != self.profileFeedViewModel.profileContentType {
            self.profileFeedViewModel.profileContentType = profileContentType
            self.tableView.coreRefresh.resetNoMore()
            if self.profileFeedViewModel.feedLoaded {
                self.tableView.reloadData()
            } else {
                self.profileFeedViewModel.getContents()
                self.tableView.reloadData()
            }
        }
    }
}

extension ProfileViewController: BlockedUserTableViewCellDelegate {
    func didUnblocked(_ blockedUserTableViewCell: BlockedUserTableViewCell) {
        if self.profileViewModel.profileType != .mine && !self.profileViewModel.isMyPage {
            self.profileViewModel.userInfo.blocked = false
            self.tableView.reloadData()
        }
    }
}

extension ProfileViewController: ProfileFeedViewModelDelegate {
    func didGetContentFinish(success: Bool) {
        if success {
            self.tableView.coreRefresh.endLoadingMore()
            self.tableView.reloadData()
        }
    }
}
