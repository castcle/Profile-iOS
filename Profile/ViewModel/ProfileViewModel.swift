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
//  ProfileViewModel.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 3/1/2565 BE.
//

import Core
import Networking
import SwiftyJSON

public enum ProfileType {
    case me
    case myPage
    case people
    case page
    case unknow
}

public final class ProfileViewModel {
   
    var userRepository: UserRepository = UserRepositoryImpl()
    var pageRepository: PageRepository = PageRepositoryImpl()
    var profileType: ProfileType = .unknow
    var page: Page = Page()
    var pageInfo: PageInfo = PageInfo()
    var userInfo: User?
    var castcleId: String = ""
    var displayName: String = ""
    let tokenHelper: TokenHelper = TokenHelper()
    var profileLoaded: Bool = false
    
    var stage: Stage = .none
    
    enum Stage {
        case getMeInfo
        case getUserInfo
        case getPageInfo
        case none
    }
    
    public init(profileType: ProfileType, castcleId: String?, displayName: String, page: Page?) {
        self.profileType = profileType
        self.castcleId = castcleId ?? ""
        self.displayName = displayName
        self.tokenHelper.delegate = self
        
        if let page = page {
            self.page = page
        }

        if self.profileType == .me {
            self.getMeInfo()
        } else if self.profileType == .myPage || self.profileType == .page {
            self.getPageInfo()
        } else if self.profileType == .people {
            self.getUserInfo()
        }
    }
    
    func getMeInfo() {
        self.stage = .getMeInfo
        self.userRepository.getMe() { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let userHelper = UserHelper()
                    userHelper.updateLocalProfile(user: User(json: json))
                    self.didGetMeInfoFinish?()
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }
    
    func getUserInfo() {
        self.stage = .getUserInfo
        self.userRepository.getUser(userId: self.castcleId) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    self.userInfo = User(json: json)
                    self.didGetUserInfoFinish?()
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }
    
    func getPageInfo() {
        self.stage = .getPageInfo
        self.pageRepository.getPageInfo(pageId: self.page.castcleId) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    self.pageInfo = PageInfo(json: json)
                    self.didGetPageInfoFinish?()
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }
    
    var didGetMeInfoFinish: (() -> ())?
    var didGetUserInfoFinish: (() -> ())?
    var didGetPageInfoFinish: (() -> ())?
}

extension ProfileViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.stage == .getMeInfo {
            self.getMeInfo()
        } else if self.stage == .getUserInfo {
            self.getUserInfo()
        } else if self.stage == .getPageInfo {
            self.getPageInfo()
        }
    }
}
