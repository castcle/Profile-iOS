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
//  NewPageWithSocialViewController.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 26/1/2565 BE.
//

import UIKit
import Core
import Networking
import Defaults
import Swifter
import SafariServices
import AuthenticationServices
import FBSDKLoginKit
import JGProgressHUD

class NewPageWithSocialViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    var swifter: Swifter!
    var accToken: Credential.OAuthAccessToken?
    let hud = JGProgressHUD()
    var viewModel = NewPageWithSocialViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.setupNavBar()
        self.configureTableView()
        self.hud.textLabel.text = "Creating"
        self.viewModel.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Defaults[.screenId] = ""
    }

    func setupNavBar() {
        self.customNavigationBar(.secondary, title: "New Page")
    }

    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: ProfileNibVars.TableViewCell.newPageWithSocial, bundle: ConfigBundle.profile), forCellReuseIdentifier: ProfileNibVars.TableViewCell.newPageWithSocial)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }

    func getPages() {
        if AccessToken.current != nil {
            var request: GraphRequest?
            let accessToken = AccessToken.current?.tokenString
            let userId = AccessToken.current?.userID ?? ""
            let params = ["access_token": accessToken ?? ""]
            request = GraphRequest(graphPath: "/\(userId)/accounts?fields=name,about,username,access_token,cover", parameters: params, httpMethod: .get)
            request?.start { (_, result, error) in
                guard error == nil else {
                    self.hud.dismiss()
                    print(error!.localizedDescription)
                    return
                }
                let json = JSON.init(result ?? "")
                let data: [FacebookPage] = (json["data"].array ?? []).map { FacebookPage(json: $0) }
                self.viewModel.pageSocialRequest.payload = []
                data.forEach { page in
                    var pageSocial: PageSocial = PageSocial()
                    pageSocial.provider = .facebook
                    pageSocial.socialId = page.id
                    pageSocial.userName = page.userName
                    pageSocial.displayName = page.name
                    pageSocial.overview = page.about
                    pageSocial.authToken = page.accessToken
                    pageSocial.avatar = "https://graph.facebook.com/\(page.id)/picture?type=large&access_token=\(accessToken ?? "")"
                    pageSocial.cover = page.cover
                    self.viewModel.pageSocialRequest.payload.append(pageSocial)
                }
                self.viewModel.createPageWithSocial()
            }
        }
    }
}

extension NewPageWithSocialViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileNibVars.TableViewCell.newPageWithSocial, for: indexPath as IndexPath) as? NewPageWithSocialTableViewCell
        cell?.backgroundColor = UIColor.clear
        cell?.configCell()
        cell?.delegate = self
        return cell ?? NewPageWithSocialTableViewCell()
    }
}

extension NewPageWithSocialViewController: NewPageWithSocialTableViewCellDelegate {
    func didSyncFacebook(_ newPageWithSocialTableViewCell: NewPageWithSocialTableViewCell) {
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

    func didSyncTwitter(_ newPageWithSocialTableViewCell: NewPageWithSocialTableViewCell) {
        self.swifter = Swifter(consumerKey: TwitterConstants.key, consumerSecret: TwitterConstants.secretKey)
        self.swifter.authorize(withProvider: self, callbackURL: URL(string: TwitterConstants.callbackUrl)!) { accessToken, _ in
            self.hud.show(in: self.view)
            self.accToken = accessToken
            self.getUserProfile()
        } failure: { error in
            print("ERROR: \(error.localizedDescription)")
        }
    }
}

extension NewPageWithSocialViewController: SFSafariViewControllerDelegate, ASWebAuthenticationPresentationContextProviding {
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
            self.viewModel.pageSocialRequest.payload.append(pageSocial)
            self.viewModel.createPageWithSocial()
        })
    }

    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }

    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension NewPageWithSocialViewController: NewPageWithSocialViewModelDelegate {
    func didCreatedPage(success: Bool) {
        self.hud.dismiss()
        if success {
            self.navigationController!.popViewController(animated: true)
        }
    }
}
