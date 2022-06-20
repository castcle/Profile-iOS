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
//  SocialHelper.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 20/6/2565 BE.
//

import UIKit
import Networking
import Swifter
import FBSDKLoginKit

class SocialHelper {

    func mappingTwitterInfoToPageSocial(json: JSON) -> PageSocial {
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
        return pageSocial
    }

    func authenFacebook(from: UIViewController, _ completion: @escaping () -> Void) {
        let loginManager = LoginManager()
        if AccessToken.current != nil {
            loginManager.logOut()
        }
        loginManager.logIn(permissions: ["public_profile", "email", "pages_show_list", "pages_manage_metadata"], from: from) { (result, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let result = result, !result.isCancelled else {
                print("User cancelled login")
                return
            }
            completion()
        }
    }
}
