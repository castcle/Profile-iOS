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
    var syncDetail: SyncDetail = SyncDetail()
    var pageSocial: PageSocial = PageSocial()
    var syncSocialId: String = ""
    var socialType: SocialType = .unknow

    public init(userInfo: UserInfo = UserInfo(), socialType: SocialType = .unknow) {
        self.userInfo = userInfo
        self.socialType = socialType
        self.tokenHelper.delegate = self
        if !self.userInfo.castcleId.isEmpty {
            self.mappingSyncDetail()
            self.getUserInfo()
        }
    }

    private func mappingSyncDetail() {
        if self.socialType == .facebook {
            self.syncDetail = self.userInfo.syncSocial.facebook
        } else if self.socialType == .twitter {
            self.syncDetail = self.userInfo.syncSocial.twitter
        }
        self.mapPageSocialRequest()
    }

    private func mapPageSocialRequest() {
        self.syncSocialId = self.syncDetail.id
        self.pageSocial.provider = self.syncDetail.provider
        self.pageSocial.socialId = self.syncDetail.socialId
        self.pageSocial.userName = self.syncDetail.userName
        self.pageSocial.displayName = self.syncDetail.displayName
        self.pageSocial.avatar = self.syncDetail.avatar
    }

    private func getUserInfo() {
        self.state = .getUserInfo
        self.userRepository.getUser(userId: self.userInfo.castcleId) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    self.userInfo = UserInfo(json: json)
                    self.mappingSyncDetail()
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
        self.pageRepository.setAutoPost(castcleId: self.userInfo.castcleId, syncSocialId: self.syncSocialId) { (success, _, isRefreshToken) in
            if success {
                self.didSetAutoPostFinish?()
                self.sendAnalytics(isActive: true)
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
        self.pageRepository.cancelAutoPost(castcleId: self.userInfo.castcleId, syncSocialId: self.syncSocialId) { (success, _, isRefreshToken) in
            if success {
                self.didCancelAutoPostFinish?()
                self.sendAnalytics(isActive: false)
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.didCancelAutoPostFinish?()
                }
            }
        }
    }

    var didGetUserInfoFinish: (() -> Void)?
    var didSetAutoPostFinish: (() -> Void)?
    var didCancelAutoPostFinish: (() -> Void)?

    private func sendAnalytics(isActive: Bool) {
        let item = Analytic()
        item.accountId = UserManager.shared.accountId
        item.userId = UserManager.shared.id
        item.active = (isActive ? "on" : "off")
        TrackingAnalyticHelper.shared.sendTrackingAnalytic(eventType: .autoPostSyncSocial, item: item)
    }
}

extension PageSyncSocialViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.state == .getUserInfo {
            self.getUserInfo()
        } else if self.state == .setAutoPost {
            self.setAutoPost()
        } else if self.state == .cancelAutoPost {
            self.cancelAutoPost()
        } else if self.state == .disconnectSyncSocial {
//            self.disconnectSyncSocial()
        }
    }
}
