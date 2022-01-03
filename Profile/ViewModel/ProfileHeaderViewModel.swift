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
//  ProfileHeaderViewModel.swift
//  Profile
//
//  Created by Tanakorn Phoochaliaw on 3/1/2565 BE.
//

import Core
import Component
import Networking
import SwiftyJSON

public final class ProfileHeaderViewModel {
   
    var userRepository: UserRepository = UserRepositoryImpl()
    var pageRepository: PageRepository = PageRepositoryImpl()
    var reportRepository: ReportRepository = ReportRepositoryImpl()
    var profileType: ProfileType = .unknow
    var isFollow: Bool = false
    var pageInfo: PageInfo = PageInfo()
    var userInfo: User?
    var stage: Stage = .none
    let tokenHelper: TokenHelper = TokenHelper()
    private var userRequest: UserRequest = UserRequest()
    var castcleId: String = ""
    var userId: String = ""
    
    enum Stage {
        case getUserInfo
        case getPageInfo
        case followUser
        case unfollowUser
        case reportUser
        case blockUser
        case none
    }
    
    public init(profileType: ProfileType, pageInfo: PageInfo = PageInfo(), userInfo: User?) {
        self.profileType = profileType
        self.pageInfo = pageInfo
        self.userInfo = userInfo
        
        if self.profileType == .people {
            self.isFollow = self.userInfo?.followed ?? false
        } else if self.profileType == .page {
            self.isFollow = self.pageInfo.followed
        } else {
            self.isFollow = false
        }
        
        self.tokenHelper.delegate = self
    }
    
    func getUserInfo() {
        self.stage = .getUserInfo
        self.userRepository.getUser(userId: self.userInfo?.castcleId ?? "") { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    self.userInfo = User(json: json)
                    self.didGetInfoFinish?()
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
        self.pageRepository.getPageInfo(pageId: self.pageInfo.castcleId) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    self.pageInfo = PageInfo(json: json)
                    self.didGetInfoFinish?()
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }
    
    func followUser() {
        self.stage = .followUser
        let userId: String = UserManager.shared.rawCastcleId
        if self.profileType == .people {
            self.userRequest.targetCastcleId = self.userInfo?.castcleId ?? ""
        } else {
            self.userRequest.targetCastcleId = self.pageInfo.castcleId
        }
        self.userRepository.follow(userId: userId, userRequest: self.userRequest) { (success, response, isRefreshToken) in
            if !success {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }
    
    func unfollowUser() {
        self.stage = .unfollowUser
        let userId: String = UserManager.shared.rawCastcleId
        if self.profileType == .people {
            self.userRequest.targetCastcleId = self.userInfo?.castcleId ?? ""
        } else {
            self.userRequest.targetCastcleId = self.pageInfo.castcleId
        }
        self.userRepository.unfollow(userId: userId, userRequest: self.userRequest) { (success, response, isRefreshToken) in
            if !success {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }
    
    func reportUser(castcleId: String, userId: String) {
        self.stage = .reportUser
        self.castcleId = castcleId
        self.userId = userId
        self.reportRepository.reportUser(userId: self.userId) { (success, response, isRefreshToken) in
            if !success {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            } else {
                Utility.currentViewController().navigationController?.pushViewController(ComponentOpener.open(.reportSuccess(false, self.castcleId)), animated: true)
            }
        }
    }
    
    func blockUser(castcleId: String, userId: String) {
        self.stage = .blockUser
        self.castcleId = castcleId
        self.userId = userId
        self.reportRepository.blockUser(userId: self.userId) { (success, response, isRefreshToken) in
            if !success {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }
    
    func reloadInfo() {
        if self.profileType == .myPage || self.profileType == .page {
            self.getPageInfo()
        } else if self.profileType == .people {
            self.getUserInfo()
        } else if self.stage == .followUser {
            self.followUser()
        } else if self.stage == .unfollowUser {
            self.unfollowUser()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.didGetInfoFinish?()
            }
        }
    }
    
    var didGetInfoFinish: (() -> ())?
}

extension ProfileHeaderViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.stage == .getUserInfo {
            self.getUserInfo()
        } else if self.stage == .getPageInfo {
            self.getPageInfo()
        } else if self.stage == .followUser {
            self.followUser()
        } else if self.stage == .unfollowUser {
            self.unfollowUser()
        } else if self.stage == .reportUser {
            self.reportUser(castcleId: self.castcleId, userId: self.userId)
        } else if self.stage == .blockUser {
            self.blockUser(castcleId: self.castcleId, userId: self.userId)
        }
    }
}
