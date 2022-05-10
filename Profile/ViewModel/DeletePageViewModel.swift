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
//  DeletePageViewModel.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 25/10/2564 BE.
//

import Foundation
import Core
import Networking
import SwiftyJSON
import RealmSwift

public protocol DeletePageViewModelDelegate {
    func didDeletePageFinish(success: Bool)
    func didGetAllPageFinish()
}

public class DeletePageViewModel {
    
    public var delegate: DeletePageViewModelDelegate?
    
    var pageRepository: PageRepository = PageRepositoryImpl()
    var pageRequest: PageRequest = PageRequest()
    let tokenHelper: TokenHelper = TokenHelper()
    private var state: State = .none
    var userInfo: UserInfo = UserInfo()
    private let realm = try! Realm()

    //MARK: Input
    public init(userInfo: UserInfo) {
        self.userInfo = userInfo
        self.tokenHelper.delegate = self
    }
    
    public func deletePage() {
        self.state = .deletePage
        self.pageRepository.deletePage(pageId: self.userInfo.castcleId, pageRequest: self.pageRequest) { (success, response, isRefreshToken) in
            if success {
                self.delegate?.didDeletePageFinish(success: true)
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.delegate?.didDeletePageFinish(success: false)
                }
            }
        }
    }
    
    func getAllMyPage() {
        self.state = .getMyPage
        self.pageRepository.getMyPage() { (success, response, isRefreshToken) in
            if success {
                self.state = .none
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let pages = json[JsonKey.payload.rawValue].arrayValue
                    let pageRealm = self.realm.objects(Page.self)
                    try! self.realm.write {
                        self.realm.delete(pageRealm)
                    }
                    
                    pages.forEach { page in
                        let pageInfo = UserInfo(json: page)
                        try! self.realm.write {
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
                            self.realm.add(pageTemp, update: .modified)
                        }
                    }
                    self.delegate?.didGetAllPageFinish()
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.delegate?.didGetAllPageFinish()
                }
            }
        }
    }
}

extension DeletePageViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.state == .deletePage {
            self.deletePage()
        } else if self.state == .getMyPage {
            self.getAllMyPage()
        }
    }
}
