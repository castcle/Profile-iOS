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
//  SyncSocialMediaViewModel.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 4/4/2565 BE.
//

import Core
import Networking
import SwiftyJSON

public final class SyncSocialMediaViewModel {

    private let userRepository: UserRepository = UserRepositoryImpl()
    var pageSocial: PageSocial = PageSocial()
    let socials: [SocialType] = [.facebook, .twitter]
    var userInfo: UserInfo = UserInfo()
    var facebookPage: [FacebookPage] = []
    let tokenHelper: TokenHelper = TokenHelper()
    var castcleId: String = ""
    var socialType: SocialType = .unknow
    private var isDuplicate: Bool = false
    var state: State = .none
    var isSyncTwitter: Bool = false
    var isSyncFacebook: Bool = false

    public init(castcleId: String) {
        self.tokenHelper.delegate = self
        self.castcleId = castcleId
    }

    func getInfo(isDuplicate: Bool) {
        self.state = .getUserInfo
        self.isDuplicate = isDuplicate
        self.userRepository.getUser(userId: self.castcleId) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    self.userInfo = UserInfo(json: json)
                    self.checkIsSyncTwitter(user: self.userInfo)
                    self.checkIsSyncFacebook(user: self.userInfo)
                    self.checkIsDuplicate(user: self.userInfo)
                } catch {
                    self.didError?()
                }
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.didError?()
                }
            }
        }
    }

    private func checkIsSyncTwitter(user: UserInfo) {
        if !self.userInfo.syncSocial.twitter.socialId.isEmpty {
            self.isSyncTwitter = true
        } else {
            self.isSyncTwitter = false
        }
    }

    private func checkIsSyncFacebook(user: UserInfo) {
        if !self.userInfo.syncSocial.facebook.socialId.isEmpty {
            self.isSyncFacebook = true
        } else {
            self.isSyncFacebook = false
        }
    }

    private func checkIsDuplicate(user: UserInfo) {
        if self.isDuplicate {
            self.didDuplicate?()
        } else {
            self.didGetUserInfoFinish?()
        }
    }

    func syncSocial() {
        self.state = .syncSocial
        self.userRepository.syncSocial(userId: self.userInfo.castcleId, pageSocial: self.pageSocial) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let duplicate: Bool = json["duplicate"].boolValue
                    self.getInfo(isDuplicate: duplicate)
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.didError?()
                }
            }
        }
    }

    var didGetUserInfoFinish: (() -> Void)?
    var didDuplicate: (() -> Void)?
    var didError: (() -> Void)?
}

extension SyncSocialMediaViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.state == .getUserInfo {
            self.getInfo(isDuplicate: self.isDuplicate)
        } else if self.state == .syncSocial {
            self.syncSocial()
        }
    }
}
