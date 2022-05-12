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
//  CreatePageDisplayNameViewModel.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 16/9/2564 BE.
//

import Core
import Networking
import Moya
import SwiftyJSON
import Defaults
import RealmSwift

public protocol CreatePageDisplayNameViewModelDelegate: AnyObject {
    func didCheckCastcleIdExistsFinish()
    func didSuggestCastcleIdFinish(suggestCastcleId: String)
    func didCreatePageFinish(success: Bool, castcleId: String)
    func didGetAllPageFinish(castcleId: String)
}

class CreatePageDisplayNameViewModel {

    public var delegate: CreatePageDisplayNameViewModelDelegate?
    var authenticationRepository: AuthenticationRepository
    var authenRequest: AuthenRequest = AuthenRequest()
    var pageRepository: PageRepository = PageRepositoryImpl()
    var pageRequest: PageRequest
    var isCastcleIdExist: Bool = true
    let tokenHelper: TokenHelper = TokenHelper()
    private var state: State = .none

    // MARK: - Input
    public init(authenRequest: AuthenRequest = AuthenRequest(), pageRequest: PageRequest = PageRequest(), authenticationRepository: AuthenticationRepository = AuthenticationRepositoryImpl()) {
        self.authenRequest = authenRequest
        self.pageRequest = pageRequest
        self.authenticationRepository = authenticationRepository
        self.tokenHelper.delegate = self
    }

    public func suggestCastcleId() {
        self.state = .suggestCastcleId
        self.authenticationRepository.suggestCastcleId(authenRequest: self.authenRequest) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let payload = JSON(json[JsonKey.payload.rawValue].dictionaryValue)
                    let suggestCastcleId = payload[JsonKey.suggestCastcleId.rawValue].stringValue
                    self.delegate?.didSuggestCastcleIdFinish(suggestCastcleId: suggestCastcleId)
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }

    public func checkCastcleIdExists() {
        self.state = .checkCastcleIdExists
        self.authenticationRepository.checkCastcleId(authenRequest: self.authenRequest) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let payload = JSON(json[JsonKey.payload.rawValue].dictionaryValue)
                    let exist = payload[JsonKey.exist.rawValue].boolValue
                    self.isCastcleIdExist = exist
                    self.delegate?.didCheckCastcleIdExistsFinish()
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.delegate?.didCheckCastcleIdExistsFinish()
                }
            }
        }
    }

    public func createPage() {
        self.state = .createPage
        self.pageRepository.createPage(pageRequest: self.pageRequest) { (success, _, isRefreshToken) in
            if success {
                self.state = .none
                self.delegate?.didCreatePageFinish(success: true, castcleId: self.pageRequest.castcleId)
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.delegate?.didCreatePageFinish(success: false, castcleId: "")
                }
            }
        }
    }

    func getAllMyPage(castcleId: String) {
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
                    UserHelper.shared.updatePage(pages: pages)
                    self.delegate?.didGetAllPageFinish(castcleId: castcleId)
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.delegate?.didGetAllPageFinish(castcleId: castcleId)
                }
            }
        }
    }
}

extension CreatePageDisplayNameViewModel: TokenHelperDelegate {
    func didRefreshTokenFinish() {
        if self.state == .suggestCastcleId {
            self.suggestCastcleId()
        } else if self.state == .checkCastcleIdExists {
            self.checkCastcleIdExists()
        } else if self.state == .createPage {
            self.createPage()
        } else if self.state == .getMyPage {
            self.getAllMyPage(castcleId: self.pageRequest.castcleId)
        }
    }
}
