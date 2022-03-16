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
import RealmSwift

public enum ProfileType {
    case me
    case user
    case unknow
}

public final class ProfileViewModel {
    var userRepository: UserRepository = UserRepositoryImpl()
    var profileType: ProfileType = .unknow
    var userInfo: UserInfo = UserInfo()
    var castcleId: String = ""
    var displayName: String = ""
    let tokenHelper: TokenHelper = TokenHelper()
    var loadState: LoadState = .loading
    var isMyPage: Bool = false
    var state: State = .none
    
    enum LoadState {
        case loading
        case loaded
        case error
    }
    
    enum State {
        case getMeInfo
        case getUserInfo
        case none
    }
    
    var isBlocked: Bool {
        if self.profileType == .user {
            return self.userInfo.blocked
        } else {
            return false
        }
    }
    
    var castcleIdBlock: String {
        if self.profileType == .user {
            return self.userInfo.castcleId
        } else {
            return ""
        }
    }
    
    public init(profileType: ProfileType, castcleId: String, displayName: String) {
        self.profileType = profileType
        self.castcleId = castcleId
        self.displayName = displayName
        let realm = try! Realm()
        if realm.objects(Page.self).filter("castcleId = '\(castcleId)'").first != nil {
            self.isMyPage = true
        } else {
            self.isMyPage = false
        }
        self.tokenHelper.delegate = self
        self.getProfile()
    }
    
    func getProfile() {
        if self.profileType == .me {
            self.getMeInfo()
        } else if self.profileType == .user {
            self.getUserInfo()
        }
    }
    
    private func getMeInfo() {
        self.state = .getMeInfo
        self.userRepository.getMe() { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let userHelper = UserHelper()
                    userHelper.updateLocalProfile(user: UserInfo(json: json))
                    self.didGetMeInfoFinish?()
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }
    
    private func getUserInfo() {
        self.state = .getUserInfo
        self.userRepository.getUser(userId: self.castcleId) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    self.userInfo = UserInfo(json: json)
                    self.didGetUserInfoFinish?()
                } catch {
                    self.didGetUserInfoFalse?()
                }
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.didGetUserInfoFalse?()
                }
            }
        }
    }
    
    var didGetMeInfoFinish: (() -> ())?
    var didGetUserInfoFinish: (() -> ())?
    var didGetUserInfoFalse: (() -> ())?
}

extension ProfileViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.state == .getMeInfo {
            self.getMeInfo()
        } else if self.state == .getUserInfo {
            self.getUserInfo()
        }
    }
}
