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
//  PageSyncSocialViewModel.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 9/3/2565 BE.
//

import Core
import Networking
import SwiftyJSON

public final class PageSyncSocialViewModel {
   
    var userRepository: UserRepository = UserRepositoryImpl()
    var pageRepository: PageRepository = PageRepositoryImpl()
    let tokenHelper: TokenHelper = TokenHelper()
    var state: State = .none
    var userInfo: UserInfo = UserInfo()
    var pageSocial: PageSocial = PageSocial()
    var syncSocialId: String = ""
    
    enum State {
        case getUserInfo
        case setAutoPost
        case cancelAutoPost
        case reconnectSyncSocial
        case disconnectSyncSocial
        case none
    }
    
    public init(userInfo: UserInfo = UserInfo()) {
        self.userInfo = userInfo
        self.tokenHelper.delegate = self
        if !self.userInfo.castcleId.isEmpty {
            self.mapPageSocialRequest()
            self.getUserInfo()
        }
    }
    
    private func mapPageSocialRequest() {
        self.syncSocialId = self.userInfo.syncSocial.id
        self.pageSocial.provider = ProviderCreatePage(rawValue: self.userInfo.syncSocial.provider) ?? .none
        self.pageSocial.socialId = self.userInfo.syncSocial.socialId
        self.pageSocial.userName = self.userInfo.syncSocial.userName
        self.pageSocial.displayName = self.userInfo.syncSocial.displayName
        self.pageSocial.avatar = self.userInfo.syncSocial.avatar
    }
    
    private func getUserInfo() {
        self.state = .getUserInfo
        self.userRepository.getUser(userId: self.userInfo.castcleId) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    self.userInfo = UserInfo(json: json)
                    self.mapPageSocialRequest()
                    self.didGetUserInfoFinish?()
                } catch {
                    self.didGetUserInfoFinish?()
                }
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.didGetUserInfoFinish?()
                }
            }
        }
    }
    
    public func setAutoPost() {
        self.state = .setAutoPost
        self.pageRepository.setAutoPost(syncSocialId: self.syncSocialId) { (success, response, isRefreshToken) in
            if success {
                self.didSetAutoPostFinish?()
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.didSetAutoPostFinish?()
                }
            }
        }
    }
    
    public func cancelAutoPost() {
        self.state = .cancelAutoPost
        self.pageRepository.cancelAutoPost(syncSocialId: self.syncSocialId) { (success, response, isRefreshToken) in
            if success {
                self.didCancelAutoPostFinish?()
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.didCancelAutoPostFinish?()
                }
            }
        }
    }
    
    public func reconnectSyncSocial() {
        self.state = .reconnectSyncSocial
        self.pageRepository.reconnectSyncSocial(syncSocialId: self.syncSocialId, pageSocial: self.pageSocial) { (success, response, isRefreshToken) in
            if success {
                self.didReconnectSyncSocialFinish?()
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.didReconnectSyncSocialFinish?()
                }
            }
        }
    }
    
    public func disconnectSyncSocial() {
        self.state = .disconnectSyncSocial
        self.pageRepository.disconnectSyncSocial(syncSocialId: self.syncSocialId) { (success, response, isRefreshToken) in
            if success {
                self.didDisconnectSyncSocialFinish?()
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.didDisconnectSyncSocialFinish?()
                }
            }
        }
    }
    
    var didGetUserInfoFinish: (() -> ())?
    var didSetAutoPostFinish: (() -> ())?
    var didCancelAutoPostFinish: (() -> ())?
    var didReconnectSyncSocialFinish: (() -> ())?
    var didDisconnectSyncSocialFinish: (() -> ())?
}

extension PageSyncSocialViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.state == .getUserInfo {
            self.getUserInfo()
        } else if self.state == .setAutoPost {
            self.setAutoPost()
        } else if self.state == .cancelAutoPost {
            self.cancelAutoPost()
        } else if self.state == .reconnectSyncSocial {
            self.reconnectSyncSocial()
        } else if self.state == .disconnectSyncSocial {
            self.disconnectSyncSocial()
        }
    }
}
