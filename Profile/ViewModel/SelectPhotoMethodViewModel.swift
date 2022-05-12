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
//  SelectPhotoMethodViewModel.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 16/9/2564 BE.
//

import UIKit
import Core
import Networking
import Moya
import SwiftyJSON
import Defaults
import RealmSwift

public protocol SelectPhotoMethodViewModelDelegate: AnyObject {
    func didUpdateFinish(success: Bool)
    func didGetPageFinish()
}

public class SelectPhotoMethodViewModel {

    public var delegate: SelectPhotoMethodViewModelDelegate?
    var userRepository: UserRepository = UserRepositoryImpl()
    var pageRepository: PageRepository = PageRepositoryImpl()
    var userRequest: UserRequest = UserRequest()
    let tokenHelper: TokenHelper = TokenHelper()
    var avatar: UIImage?
    var authorType: AuthorType
    var state: State = .none
    var castcleId: String
    var isPage: Bool = false

    // MARK: - Input
    public init(authorType: AuthorType, castcleId: String = "") {
        self.authorType = authorType
        self.castcleId = castcleId
        self.tokenHelper.delegate = self
    }

    public func updateUserAvatar(isPage: Bool) {
        guard let image = self.avatar else { return }
        self.state = .updateUserAvatar
        self.userRequest.payload.images.avatar = image.toBase64() ?? ""
        self.userRepository.updateAvatar(userId: self.castcleId, userRequest: self.userRequest) { (success, response, isRefreshToken) in
            if success {
                if isPage {
                    self.delegate?.didUpdateFinish(success: true)
                } else {
                    do {
                        let rawJson = try response.mapJSON()
                        let json = JSON(rawJson)
                        let user = UserInfo(json: json)
                        UserHelper.shared.updateLocalProfile(user: user)
                        self.delegate?.didUpdateFinish(success: true)
                    } catch {}
                }
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.delegate?.didUpdateFinish(success: false)
                }
            }
        }
    }

    func getMyPage() {
        self.state = .getMyPage
        self.pageRepository.getMyPage { (success, response, isRefreshToken) in
            if success {
                self.state = .none
                do {
                    let realm = try Realm()
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let pages = json[JsonKey.payload.rawValue].arrayValue
                    let pageRealm = realm.objects(Page.self)
                    try realm.write {
                        realm.delete(pageRealm)
                    }
                    try realm.write {
                        pages.forEach { page in
                            let pageInfo = UserInfo(json: page)
                            let pageTemp = Page()
                            pageTemp.id = pageInfo.id
                            pageTemp.castcleId = pageInfo.castcleId
                            pageTemp.displayName = pageInfo.displayName
                            pageTemp.avatar = pageInfo.images.avatar.thumbnail
                            pageTemp.cover = pageInfo.images.cover.fullHd
                            pageTemp.overview = pageInfo.overview
                            pageTemp.official = pageInfo.verified.official
                            pageTemp.isSyncTwitter = !pageInfo.syncSocial.twitter.socialId.isEmpty
                            pageTemp.isSyncFacebook = !pageInfo.syncSocial.facebook.socialId.isEmpty
                            realm.add(pageTemp, update: .modified)
                        }
                    }
                    self.delegate?.didGetPageFinish()
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.delegate?.didGetPageFinish()
                }
            }
        }
    }
}

extension SelectPhotoMethodViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.state == .updateUserAvatar {
            self.updateUserAvatar(isPage: self.isPage)
        } else if self.state == .getMyPage {
            self.getMyPage()
        }
    }
}
