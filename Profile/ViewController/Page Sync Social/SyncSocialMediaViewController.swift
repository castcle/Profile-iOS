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
//  SyncSocialMediaViewController.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 4/4/2565 BE.
//

import UIKit
import Core
import Component
import Networking
import Swifter
import SafariServices
import AuthenticationServices
import FBSDKLoginKit
import Defaults

class SyncSocialMediaViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    var viewModel = SyncSocialMediaViewModel(castcleId: "")
    var swifter: Swifter!
    var accToken: Credential.OAuthAccessToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.setupNavBar()
        self.configureTableView()

        self.viewModel.didGetUserInfoFinish = {
            self.tableView.reloadData()
            CCLoading.shared.dismiss()
        }

        self.viewModel.didDuplicate = {
            CCLoading.shared.dismiss()
            Utility.currentViewController().present(ComponentOpener.open(.acceptSyncSocialPopup(AcceptSyncSocialPopupViewModel(socialType: self.viewModel.socialType, pageSocial: self.viewModel.pageSocial, userInfo: self.viewModel.userInfo))), animated: true)
        }

        self.viewModel.didError = {
            CCLoading.shared.dismiss()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Defaults[.screenId] = ScreenId.syncSocial.rawValue
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        EngagementHelper().sendCastcleAnalytic(event: .onScreenView, screen: .syncSocial)
        self.sendAnalytics()
        if !self.viewModel.castcleId.isEmpty {
            CCLoading.shared.show(text: "Loading")
            self.viewModel.getInfo(isDuplicate: false)
        }
    }

    func setupNavBar() {
        self.customNavigationBar(.secondary, title: "Sync Social Media")
    }

    private func sendAnalytics() {
        let item = Analytic()
        item.accountId = UserManager.shared.accountId
        item.userId = UserManager.shared.id
        TrackingAnalyticHelper.shared.sendTrackingAnalytic(eventType: .viewSyncSocial, item: item)
    }

    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: ProfileNibVars.TableViewCell.socialAccount, bundle: ConfigBundle.profile), forCellReuseIdentifier: ProfileNibVars.TableViewCell.socialAccount)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }

    func syncFacebook() {
        SocialHelper().authenFacebook(from: self) {
            CCLoading.shared.show(text: "Loading")
            self.getPages()
        }
    }

    func syncTwitter() {
        self.swifter = Swifter(consumerKey: TwitterConstants.key, consumerSecret: TwitterConstants.secretKey)
        self.swifter.authorize(withProvider: self, callbackURL: URL(string: TwitterConstants.callbackUrl)!) { accessToken, _ in
            CCLoading.shared.show(text: "Syncing")
            self.accToken = accessToken
            self.getUserProfileTwitter()
        } failure: { error in
            print("ERROR: \(error.localizedDescription)")
        }
    }

    func getPages() {
        if AccessToken.current != nil {
            var request: GraphRequest?
            let accessToken = AccessToken.current?.tokenString
            let userId = AccessToken.current?.userID ?? ""
            let params = ["access_token": accessToken ?? ""]
            request = GraphRequest(graphPath: "/\(userId)/accounts?fields=name,about,username,access_token,cover", parameters: params, httpMethod: .get)
            request?.start { (_, result, error) in
                CCLoading.shared.dismiss()
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                let json = JSON.init(result ?? "")
                self.viewModel.facebookPage = (json["data"].array ?? []).map { FacebookPage(json: $0) }
                let viewController = ProfileOpener.open(.facebookPageList(self.viewModel.facebookPage)) as? FacebookPageListViewController
                viewController?.delegate = self
                Utility.currentViewController().navigationController?.pushViewController(viewController ?? FacebookPageListViewController(), animated: true)
            }
        }
    }
}

extension SyncSocialMediaViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.socials.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileNibVars.TableViewCell.socialAccount, for: indexPath as IndexPath) as? SocialAccountTableViewCell
        cell?.backgroundColor = UIColor.clear
        if self.viewModel.socials[indexPath.row] == .facebook {
            cell?.configCell(socialType: .facebook, isSync: self.viewModel.isSyncFacebook)
        } else if self.viewModel.socials[indexPath.row] == .twitter {
            cell?.configCell(socialType: .twitter, isSync: self.viewModel.isSyncTwitter)
        } else {
            cell?.configCell(socialType: .unknow, isSync: false)
        }
        return cell ?? SocialAccountTableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.viewModel.socials[indexPath.row] == .facebook {
            if self.viewModel.isSyncFacebook {
                self.navigationController?.pushViewController(ProfileOpener.open(.pageSyncSocial(PageSyncSocialViewModel(userInfo: self.viewModel.userInfo, socialType: .facebook))), animated: true)
            } else {
                self.viewModel.socialType = .facebook
                self.syncFacebook()
            }
        } else if self.viewModel.socials[indexPath.row] == .twitter {
            if self.viewModel.isSyncTwitter {
                self.navigationController?.pushViewController(ProfileOpener.open(.pageSyncSocial(PageSyncSocialViewModel(userInfo: self.viewModel.userInfo, socialType: .twitter))), animated: true)
            } else {
                self.viewModel.socialType = .twitter
                self.syncTwitter()
            }
        }
    }
}

extension SyncSocialMediaViewController: SFSafariViewControllerDelegate, ASWebAuthenticationPresentationContextProviding {
    func getUserProfileTwitter() {
        self.swifter.verifyAccountCredentials(includeEntities: false, skipStatus: false, includeEmail: true, success: { json in
            self.viewModel.pageSocial = SocialHelper().mappingTwitterInfoToPageSocial(json: json)
            self.viewModel.syncSocial()
        })
    }

    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }

    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension SyncSocialMediaViewController: FacebookPageListViewControllerDelegate {
    func didSelectFacebookPage(_ facebookPageListViewController: FacebookPageListViewController, page: FacebookPage) {
        var pageSocial: PageSocial = PageSocial()
        pageSocial.provider = .facebook
        pageSocial.socialId = page.id
        pageSocial.userName = page.userName
        pageSocial.displayName = page.name
        pageSocial.overview = page.about
        pageSocial.avatar = page.avatar
        pageSocial.cover = page.cover
        pageSocial.authToken = page.accessToken

        CCLoading.shared.show(text: "Syncing")
        self.viewModel.pageSocial = pageSocial
        self.viewModel.syncSocial()
    }
}
