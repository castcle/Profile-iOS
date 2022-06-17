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
//  UserFollowViewModel.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 28/2/2565 BE.
//

import Core
import Networking
import SwiftyJSON
import Moya

public final class UserFollowViewModel {

    var userRepository: UserRepository = UserRepositoryImpl()
    let tokenHelper: TokenHelper = TokenHelper()
    var castcleId: String = ""
    var followType: FollowType = .none
    var userFollowRequest: UserFollowRequest = UserFollowRequest()
    var users: [UserInfo] = []
    var meta: Meta = Meta()
    var state: LoadState = .loading

    public init(followType: FollowType = .none, castcleId: String = "") {
        self.followType = followType
        self.castcleId = castcleId
        self.tokenHelper.delegate = self
        self.userFollowRequest.maxResults = 25
        self.loadData()
    }

    public func reloadData() {
        self.users = []
        self.meta = Meta()
        self.loadData()
    }

    func loadData() {
        if self.followType == .follower && !self.castcleId.isEmpty {
            self.getFollower()
        } else if self.followType == .following && !self.castcleId.isEmpty {
            self.getFollowing()
        }
    }

    private func getFollower() {
        self.userRepository.getUserFollower(userId: self.castcleId, userFollowRequest: self.userFollowRequest) { (success, response, isRefreshToken) in
            self.handleRespond(success: success, response: response, isRefreshToken: isRefreshToken)
        }
    }

    private func getFollowing() {
        self.userRepository.getUserFollowing(userId: self.castcleId, userFollowRequest: self.userFollowRequest) { (success, response, isRefreshToken) in
            self.handleRespond(success: success, response: response, isRefreshToken: isRefreshToken)
        }
    }

    private func handleRespond(success: Bool, response: Response, isRefreshToken: Bool) {
        if success {
            do {
                let rawJson = try response.mapJSON()
                let json = JSON(rawJson)
                let userData = (json[JsonKey.payload.rawValue].arrayValue).map { UserInfo(json: $0) }
                self.meta = Meta(json: JSON(json[JsonKey.meta.rawValue].dictionaryValue))
                self.users.append(contentsOf: userData)
                self.didLoadFollowUserFinish?()
            } catch {
                self.didLoadFollowUserFinish?()
            }
        } else {
            if isRefreshToken {
                self.tokenHelper.refreshToken()
            } else {
                self.didLoadFollowUserFinish?()
            }
        }
    }

    var didLoadFollowUserFinish: (() -> Void)?
}

extension UserFollowViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.followType == .follower {
            self.getFollower()
        } else if self.followType == .following {
            self.getFollowing()
        }
    }
}
