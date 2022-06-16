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
import JGProgressHUD
import Defaults

class SyncSocialMediaViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    var viewModel = SyncSocialMediaViewModel(castcleId: "")
    var swifter: Swifter!
    var accToken: Credential.OAuthAccessToken?
    let hud = JGProgressHUD()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.setupNavBar()
        self.configureTableView()

        self.viewModel.didGetUserInfoFinish = {
            self.tableView.reloadData()
            self.hud.dismiss()
        }

        self.viewModel.didDuplicate = {
            self.hud.dismiss()
            Utility.currentViewController().present(ComponentOpener.open(.acceptSyncSocialPopup(AcceptSyncSocialPopupViewModel(socialType: self.viewModel.socialType, pageSocial: self.viewModel.pageSocial, userInfo: self.viewModel.userInfo))), animated: true)
        }

        self.viewModel.didError = {
            self.hud.dismiss()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Defaults[.screenId] = ""
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !self.viewModel.castcleId.isEmpty {
            self.hud.textLabel.text = "Loading"
            self.hud.show(in: self.view)
            self.viewModel.getInfo(isDuplicate: false)
        }
    }

    func setupNavBar() {
        self.customNavigationBar(.secondary, title: "Sync Social Media")
    }

    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: ProfileNibVars.TableViewCell.socialAccount, bundle: ConfigBundle.profile), forCellReuseIdentifier: ProfileNibVars.TableViewCell.socialAccount)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }

    func syncFacebook() {
        let loginManager = LoginManager()
        if AccessToken.current != nil {
            loginManager.logOut()
        }
        loginManager.logIn(permissions: ["public_profile", "email", "pages_show_list", "pages_manage_metadata"], from: self) { (result, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let result = result, !result.isCancelled else {
                print("User cancelled login")
                return
            }
            self.hud.show(in: self.view)
            self.getPages()
        }
    }

    func syncTwitter() {
        self.swifter = Swifter(consumerKey: TwitterConstants.key, consumerSecret: TwitterConstants.secretKey)
        self.swifter.authorize(withProvider: self, callbackURL: URL(string: TwitterConstants.callbackUrl)!) { accessToken, _ in
            self.hud.textLabel.text = "Syncing"
            self.hud.show(in: self.view)
            self.accToken = accessToken
            self.getUserProfile()
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
                self.hud.dismiss()
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
    func getUserProfile() {
        self.swifter.verifyAccountCredentials(includeEntities: false, skipStatus: false, includeEmail: true, success: { json in
            let twitterId: String = json["id_str"].string ?? ""
            let twitterName: String = json["name"].string ?? ""
            let twitterProfilePic: String = json["profile_image_url_https"].string?.replacingOccurrences(of: "_normal", with: "", options: .literal, range: nil) ?? ""
            let twitterScreenName: String = json["screen_name"].string ?? ""
            let twitterDescription: String = json["description"].string ?? ""
            let twitterCover: String = json["profile_banner_url"].string ?? ""

            var pageSocial: PageSocial = PageSocial()
            pageSocial.provider = .twitter
            pageSocial.socialId = twitterId
            pageSocial.userName = twitterScreenName
            pageSocial.displayName = twitterName
            pageSocial.overview = twitterDescription
            pageSocial.avatar = twitterProfilePic
            pageSocial.cover = twitterCover

            self.viewModel.pageSocial = pageSocial
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

        self.hud.textLabel.text = "Syncing"
        self.hud.show(in: self.view)
        self.viewModel.pageSocial = pageSocial
        self.viewModel.syncSocial()
    }
}
