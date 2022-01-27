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
    
    struct FBPage {
        var id: String = ""
        var name: String = ""
        
        init(json: JSON) {
            self.id = json["id"].string ?? ""
            self.name = json["name"].string ?? ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.setupNavBar()
        self.configureTableView()
        self.hud.textLabel.text = "Creating"
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
        if let _ = AccessToken.current {
            var request: GraphRequest?
            let accessToken = AccessToken.current?.tokenString
            let userId = AccessToken.current?.userID ?? ""
            let params = ["access_token" : accessToken ?? ""]
            request = GraphRequest(graphPath: "/\(userId)/accounts?fields=name", parameters: params, httpMethod: .get)
            request?.start() { (connection, result, error) in
                self.hud.dismiss()
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                let json = JSON.init(result ?? "")
                let data: [FBPage] = (json["data"].array ?? []).map { FBPage(json: $0) }
                
                var srr = ""
                data.forEach { page in
                    if srr.isEmpty {
                        srr = "Id: \(page.id) Name: \(page.name)"
                    } else {
                        srr = "\(srr)\nId: \(page.id) Name: \(page.name)"
                    }
                }
                
                let alert = UIAlertController(title: "", message: srr, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
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
        if let _ = AccessToken.current {
            loginManager.logOut()
        }
        loginManager.logIn(permissions: ["public_profile", "email", "pages_show_list"], from: self) { (result, error) in
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
        self.swifter.authorize(withProvider: self, callbackURL: URL(string: TwitterConstants.callbackUrl)!) { accessToken, response in
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
            self.hud.dismiss()
            let twitterId: String = json["id_str"].string ?? ""
            let twitterName: String = json["name"].string ?? ""
            let twitterProfilePic: String = json["profile_image_url_https"].string?.replacingOccurrences(of: "_normal", with: "", options: .literal, range: nil) ?? ""
            
            let alert = UIAlertController(title: "", message: "Id: \(twitterId) Name: \(twitterName) Image: \(twitterProfilePic)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }) { error in
            self.hud.dismiss()
            print("ERROR: \(error.localizedDescription)")
        }
    }
    
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window!
    }
}
