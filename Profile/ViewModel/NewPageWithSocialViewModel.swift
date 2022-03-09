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
//  NewPageWithSocialViewModel.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 4/2/2565 BE.
//

import Core
import Networking
import SwiftyJSON
import RealmSwift

public protocol NewPageWithSocialViewModelDelegate {
    func didCreatedPage(success: Bool)
}

public final class NewPageWithSocialViewModel {
   
    public var delegate: NewPageWithSocialViewModelDelegate?
    private var pageRepository: PageRepository = PageRepositoryImpl()
    var pageSocialRequest: PageSocialRequest = PageSocialRequest()
    var stage: Stage = .none
    let tokenHelper: TokenHelper = TokenHelper()
    private let realm = try! Realm()
    
    enum Stage {
        case createPageWithSocial
        case getPage
        case none
    }
    
    public init() {
        self.tokenHelper.delegate = self
    }
    
    func createPageWithSocial() {
        self.stage = .createPageWithSocial
        self.pageRepository.createPageWithSocial(pageSocialRequest: self.pageSocialRequest) { (success, response, isRefreshToken) in
            if success {
//                do {
//                    let rawJson = try response.mapJSON()
//                    let json = JSON(rawJson)
//                    print(json)
//                } catch {}
                self.getAllMyPage()
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.delegate?.didCreatedPage(success: false)
                }
            }
        }
    }
    
    func getAllMyPage() {
        self.stage = .getPage
        self.pageRepository.getMyPage() { (success, response, isRefreshToken) in
            if success {
                self.stage = .none
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let pages = json[AuthenticationApiKey.payload.rawValue].arrayValue
                    let pageRealm = self.realm.objects(Page.self)
                    try! self.realm.write {
                        self.realm.delete(pageRealm)
                    }
                    
                    pages.forEach { page in
                        let pageInfo = PageInfo(json: page)
                        try! self.realm.write {
                            let pageTemp = Page()
                            pageTemp.id = pageInfo.id
                            pageTemp.castcleId = pageInfo.castcleId
                            pageTemp.displayName = pageInfo.displayName
                            pageTemp.avatar = pageInfo.images.avatar.thumbnail
                            pageTemp.cover = pageInfo.images.cover.fullHd
                            pageTemp.overview = pageInfo.overview
                            pageTemp.official = pageInfo.verified.official
                            pageTemp.socialProvider = pageInfo.syncSocial.provider
                            pageTemp.socialActive = pageInfo.syncSocial.active
                            pageTemp.socialAutoPost = pageInfo.syncSocial.autoPost
                            self.realm.add(pageTemp, update: .modified)
                        }
                    }
                    self.delegate?.didCreatedPage(success: true)
                } catch {
                    self.delegate?.didCreatedPage(success: false)
                }
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.delegate?.didCreatedPage(success: false)
                }
            }
        }
    }
}

extension NewPageWithSocialViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.stage == .createPageWithSocial {
            self.createPageWithSocial()
        } else if self.stage == .getPage {
            self.getAllMyPage()
        }
    }
}
