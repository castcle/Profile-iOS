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

class ProfileViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var profileViewModel = ProfileViewModel(profileType: .unknow, castcleId: nil, displayName: "", page: nil)
    var profileFeedViewModel = ProfileFeedViewModel(profileContentType: .unknow, profileType: .unknow, castcleId: "")
    
    enum FeedCellType {
        case activity
        case header
        case content
        case quote
        case footer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.configureTableView()
        self.setupNavBar()
        
        self.profileFeedViewModel.delegate = self
        self.profileFeedViewModel.getContents()
        
        self.profileViewModel.didGetMeInfoFinish = {
            self.tableView.reloadData()
        }

        self.profileViewModel.didGetUserInfoFinish = {
            self.tableView.reloadData()
        }

        self.profileViewModel.didGetPageInfoFinish = {
            self.tableView.reloadData()
        }
    }
    
    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: ProfileNibVars.TableViewCell.profileHeader, bundle: ConfigBundle.profile), forCellReuseIdentifier: ProfileNibVars.TableViewCell.profileHeader)
        self.tableView.register(UINib(nibName: ProfileNibVars.TableViewCell.feedHeader, bundle: ConfigBundle.profile), forCellReuseIdentifier: ProfileNibVars.TableViewCell.feedHeader)
        self.tableView.registerFeedCell()
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }
    
    func setupNavBar() {
        if self.profileViewModel.profileType == .me {
            self.customNavigationBar(.secondary, title: UserManager.shared.displayName)
        } else if self.profileViewModel.profileType == .myPage || self.profileViewModel.profileType == .page {
            self.customNavigationBar(.secondary, title: self.profileViewModel.page.displayName)
        } else {
            self.customNavigationBar(.secondary, title: self.profileViewModel.displayName)
        }
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
//        if self.viewModel.state == .loading {
//            return 1
//        } else {
//            if UserManager.shared.isLogin {
//                if section == 0 {
//                    return 1
//                } else {
//                    let content = self.viewModel.feeds[section - 1].payload
//                    if content.participate.recasted || content.participate.quoted {
//                        return 4
//                    } else {
//                        return 3
//                    }
//                }
//            } else {
//                let content = self.viewModel.feeds[section].payload
//                if content.participate.recasted || content.participate.quoted {
//                    return 4
//                } else {
//                    return 3
//                }
//            }
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileNibVars.TableViewCell.profileHeader, for: indexPath as IndexPath) as? ProfileHeaderTableViewCell
            cell?.delegate = self
            cell?.backgroundColor = UIColor.Asset.darkGray
            cell?.configCell(viewModel: ProfileHeaderViewModel(profileType: self.profileViewModel.profileType, pageInfo: self.profileViewModel.pageInfo, userInfo: self.profileViewModel.userInfo))
            return cell ?? ProfileHeaderTableViewCell()
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileNibVars.TableViewCell.feedHeader, for: indexPath as IndexPath) as? FeedHeaderTableViewCell
            cell?.delegate = self
            cell?.backgroundColor = UIColor.Asset.darkGraphiteBlue
            cell?.configCell(profileContentType: self.profileFeedViewModel.profileContentType)
            return cell ?? FeedHeaderTableViewCell()
        } else {
            return UITableViewCell()
        }
//        if self.viewModel.state == .loading {
//            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.skeleton, for: indexPath as IndexPath) as? SkeletonFeedTableViewCell
//            cell?.backgroundColor = UIColor.Asset.darkGray
//            cell?.configCell()
//            return cell ?? SkeletonFeedTableViewCell()
//        } else {
//            if UserManager.shared.isLogin {
//                if indexPath.section == 0 {
//                    let cell = tableView.dequeueReusableCell(withIdentifier: FeedNibVars.TableViewCell.post, for: indexPath as IndexPath) as? NewPostTableViewCell
//                    cell?.backgroundColor = UIColor.Asset.darkGray
//                    cell?.configCell()
//                    return cell ?? NewPostTableViewCell()
//                } else {
//                    let content = self.viewModel.feeds[indexPath.section - 1].payload
//                    if content.participate.recasted {
//                        if indexPath.row == 0 {
//                            return self.renderFeedCell(content: content, cellType: .activity, tableView: tableView, indexPath: indexPath)
//                        } else if indexPath.row == 1 {
//                            return self.renderFeedCell(content: content, cellType: .header, tableView: tableView, indexPath: indexPath)
//                        } else if indexPath.row == 2 {
//                            return self.renderFeedCell(content: content, cellType: .content, tableView: tableView, indexPath: indexPath)
//                        } else {
//                            return self.renderFeedCell(content: content, cellType: .footer, tableView: tableView, indexPath: indexPath)
//                        }
//                    } else if content.participate.quoted {
//                        if indexPath.row == 0 {
//                            return self.renderFeedCell(content: content, cellType: .header, tableView: tableView, indexPath: indexPath)
//                        } else if indexPath.row == 1 {
//                            return self.renderFeedCell(content: content, cellType: .content, tableView: tableView, indexPath: indexPath)
//                        } else if indexPath.row == 2 {
//                            return self.renderFeedCell(content: content, cellType: .quote, tableView: tableView, indexPath: indexPath)
//                        } else {
//                            return self.renderFeedCell(content: content, cellType: .footer, tableView: tableView, indexPath: indexPath)
//                        }
//                    } else {
//                        if indexPath.row == 0 {
//                            return self.renderFeedCell(content: content, cellType: .header, tableView: tableView, indexPath: indexPath)
//                        } else if indexPath.row == 1 {
//                            return self.renderFeedCell(content: content, cellType: .content, tableView: tableView, indexPath: indexPath)
//                        } else {
//                            return self.renderFeedCell(content: content, cellType: .footer, tableView: tableView, indexPath: indexPath)
//                        }
//                    }
//                }
//            } else {
//                let content = self.viewModel.feeds[indexPath.section].payload
//                if content.participate.recasted {
//                    if indexPath.row == 0 {
//                        return self.renderFeedCell(content: content, cellType: .activity, tableView: tableView, indexPath: indexPath)
//                    } else if indexPath.row == 1 {
//                        return self.renderFeedCell(content: content, cellType: .header, tableView: tableView, indexPath: indexPath)
//                    } else if indexPath.row == 2 {
//                        return self.renderFeedCell(content: content, cellType: .content, tableView: tableView, indexPath: indexPath)
//                    } else {
//                        return self.renderFeedCell(content: content, cellType: .footer, tableView: tableView, indexPath: indexPath)
//                    }
//                } else if content.participate.quoted {
//                    if indexPath.row == 0 {
//                        return self.renderFeedCell(content: content, cellType: .header, tableView: tableView, indexPath: indexPath)
//                    } else if indexPath.row == 1 {
//                        return self.renderFeedCell(content: content, cellType: .content, tableView: tableView, indexPath: indexPath)
//                    } else if indexPath.row == 2 {
//                        return self.renderFeedCell(content: content, cellType: .quote, tableView: tableView, indexPath: indexPath)
//                    } else {
//                        return self.renderFeedCell(content: content, cellType: .footer, tableView: tableView, indexPath: indexPath)
//                    }
//                } else {
//                    if indexPath.row == 0 {
//                        return self.renderFeedCell(content: content, cellType: .header, tableView: tableView, indexPath: indexPath)
//                    } else if indexPath.row == 1 {
//                        return self.renderFeedCell(content: content, cellType: .content, tableView: tableView, indexPath: indexPath)
//                    } else {
//                        return self.renderFeedCell(content: content, cellType: .footer, tableView: tableView, indexPath: indexPath)
//                    }
//                }
//            }
//        }
    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 5
//    }
//
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let footerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 5))
//        footerView.backgroundColor = UIColor.clear
//        return footerView
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if UserManager.shared.isLogin {
//            let content = self.viewModel.feeds[indexPath.section - 1].payload
//            if content.participate.recasted {
//                if content.type == .long && indexPath.row == 2 {
//                    self.viewModel.feeds[indexPath.section - 1].payload.isExpand.toggle()
//                    tableView.reloadRows(at: [indexPath], with: .automatic)
//                }
//            } else if content.participate.quoted {
//                if content.type == .long && indexPath.row == 1 {
//                    self.viewModel.feeds[indexPath.section - 1].payload.isExpand.toggle()
//                    tableView.reloadRows(at: [indexPath], with: .automatic)
//                }
//            } else {
//                if content.type == .long && indexPath.row == 1 {
//                    self.viewModel.feeds[indexPath.section - 1].payload.isExpand.toggle()
//                    tableView.reloadRows(at: [indexPath], with: .automatic)
//                }
//            }
//        } else {
//            let content = self.viewModel.feeds[indexPath.section].payload
//            if content.participate.recasted {
//                if content.type == .long && indexPath.row == 2 {
//                    self.viewModel.feeds[indexPath.section].payload.isExpand.toggle()
//                    tableView.reloadRows(at: [indexPath], with: .automatic)
//                }
//            } else if content.participate.quoted {
//                if content.type == .long && indexPath.row == 1 {
//                    self.viewModel.feeds[indexPath.section].payload.isExpand.toggle()
//                    tableView.reloadRows(at: [indexPath], with: .automatic)
//                }
//            } else {
//                if content.type == .long && indexPath.row == 1 {
//                    self.viewModel.feeds[indexPath.section].payload.isExpand.toggle()
//                    tableView.reloadRows(at: [indexPath], with: .automatic)
//                }
//            }
//        }
    }
    
    func renderFeedCell(content: Content, cellType: FeedCellType, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        var originalContent = Content()
        if content.participate.recasted || content.participate.quoted {
            // Original Post
//            originalContent = ContentHelper().originalPostToContent(originalPost: content.originalPost)
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
            if content.participate.recasted {
                cell?.content = originalContent
            } else {
                cell?.content = content
            }
            return cell ?? HeaderTableViewCell()
        case .footer:
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.footerFeed, for: indexPath as IndexPath) as? FooterTableViewCell
            cell?.backgroundColor = UIColor.Asset.darkGray
            cell?.delegate = self
            if content.participate.recasted {
                cell?.content = originalContent
            } else {
                cell?.content = content
            }
            return cell ?? FooterTableViewCell()
        case .quote:
            return FeedCellHelper().renderQuoteCastCell(content: originalContent, tableView: self.tableView, indexPath: indexPath, isRenderForFeed: true)
        default:
            if content.participate.recasted {
                return FeedCellHelper().renderFeedCell(content: originalContent, tableView: self.tableView, indexPath: indexPath)
            } else {
                return FeedCellHelper().renderFeedCell(content: content, tableView: self.tableView, indexPath: indexPath)
            }
        }
    }
}

extension ProfileViewController: ProfileHeaderTableViewCellDelegate {
    func didUpdateProfileSuccess(_ profileHeaderTableViewCell: ProfileHeaderTableViewCell) {
        //
    }
}

extension ProfileViewController: HeaderTableViewCellDelegate {
    func didRemoveSuccess(_ headerTableViewCell: HeaderTableViewCell) {
//        if let indexPath = self.tableView.indexPath(for: headerTableViewCell) {
//            self.viewModel.feeds.remove(at: indexPath.section)
//            self.tableView.reloadData()
//        }
    }
    
    func didTabProfile(_ headerTableViewCell: HeaderTableViewCell, author: Author) {
//        if author.type == .page {
//            ProfileOpener.openProfileDetail(author.type, castcleId: nil, displayName: "", page: Page().initCustom(id: author.id, displayName: author.displayName, castcleId: author.castcleId, avatar: author.avatar.thumbnail, cover: ""))
//        } else {
//            ProfileOpener.openProfileDetail(author.type, castcleId: author.castcleId, displayName: author.displayName, page: nil)
//        }
    }
    
    func didAuthen(_ headerTableViewCell: HeaderTableViewCell) {
//        Utility.currentViewController().presentPanModal(AuthenOpener.open(.signUpMethod) as! SignUpMethodViewController)
    }
    
    func didReportSuccess(_ headerTableViewCell: HeaderTableViewCell) {
//        if let indexPath = self.tableView.indexPath(for: headerTableViewCell) {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                Utility.currentViewController().navigationController?.pushViewController(ComponentOpener.open(.reportSuccess(true, "")), animated: true)
//            }
//
//            UIView.transition(with: self.tableView, duration: 0.35, options: .transitionCrossDissolve, animations: {
//                self.viewModel.feeds.remove(at: indexPath.section)
//                self.tableView.reloadData()
//            })
//        }
    }
}

extension ProfileViewController: FooterTableViewCellDelegate {
    func didTabComment(_ footerTableViewCell: FooterTableViewCell, content: Content) {
//        Utility.currentViewController().navigationController?.pushViewController(ComponentOpener.open(.comment(CommentViewModel(content: content))), animated: true)
    }
    
    func didTabQuoteCast(_ footerTableViewCell: FooterTableViewCell, content: Content, page: Page) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1 ) {
//            let vc = PostOpener.open(.post(PostViewModel(postType: .quoteCast, content: content, page: page)))
//            vc.modalPresentationStyle = .fullScreen
//            Utility.currentViewController().present(vc, animated: true, completion: nil)
//        }
    }
    
    func didAuthen(_ footerTableViewCell: FooterTableViewCell) {
//        Utility.currentViewController().presentPanModal(AuthenOpener.open(.signUpMethod) as! SignUpMethodViewController)
    }
}

extension ProfileViewController: FeedHeaderTableViewCellDelegate {
    func didSelectTab(_ feedHeaderTableViewCell: FeedHeaderTableViewCell, profileContentType: ProfileContentType) {
    }
}

extension ProfileViewController: ProfileFeedViewModelDelegate {
    func didGetContentFinish(success: Bool) {
        if success {
            if self.profileFeedViewModel.profileContentType == .all {
                self.profileFeedViewModel.displayContents = self.profileFeedViewModel.allContents
            } else if self.profileFeedViewModel.profileContentType == .post {
                self.profileFeedViewModel.displayContents = self.profileFeedViewModel.postContents
            } else if self.profileFeedViewModel.profileContentType == .blog {
                self.profileFeedViewModel.displayContents = self.profileFeedViewModel.blogContents
            } else if self.profileFeedViewModel.profileContentType == .photo {
                self.profileFeedViewModel.displayContents = self.profileFeedViewModel.photoContents
            }
        }
    }
}
