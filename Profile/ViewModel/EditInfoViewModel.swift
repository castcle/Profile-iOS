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
//  EditInfoViewModel.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 21/3/2565 BE.
//

import UIKit
import Core
import Networking
import SwiftyJSON

public protocol EditInfoViewModelDelegate: AnyObject {
    func didGetInfoFinish(success: Bool)
    func didUpdateInfoFinish(success: Bool)
}

public class EditInfoViewModel {
    public var delegate: EditInfoViewModelDelegate?
    var userRepository: UserRepository = UserRepositoryImpl()
    var userRequest: UserRequest = UserRequest()
    let tokenHelper: TokenHelper = TokenHelper()
    var profileType: ProfileType = .unknow
    var userInfo: UserInfo = UserInfo()
    var avatar: UIImage?
    var cover: UIImage?
    var dobDate: Date?
    var castcleId: String = ""
    var isPage: Bool = false
    var state: State = .none

    public init(profileType: ProfileType = .unknow, userInfo: UserInfo = UserInfo()) {
        self.tokenHelper.delegate = self
        self.profileType = profileType
        self.userInfo = userInfo
    }

    func getMeInfo() {
        self.state = .getMe
        self.userRepository.getMe { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    UserHelper.shared.updateLocalProfile(user: UserInfo(json: json))
                    self.delegate?.didGetInfoFinish(success: true)
                } catch {
                    self.delegate?.didGetInfoFinish(success: false)
                }
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.delegate?.didGetInfoFinish(success: false)
                }
            }
        }
    }

    func getUserInfo() {
        self.state = .getUserInfo
        self.userRepository.getUser(userId: self.userInfo.castcleId) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    self.userInfo = UserInfo(json: json)
                    self.delegate?.didGetInfoFinish(success: true)
                } catch {
                    self.delegate?.didGetInfoFinish(success: false)
                }
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.delegate?.didGetInfoFinish(success: false)
                }
            }
        }
    }

    public func updateProfile(isPage: Bool, castcleId: String) {
        self.state = .updateUserInfo
        self.isPage = isPage
        self.castcleId = castcleId
        if let dob = self.dobDate {
            self.userRequest.payload.dob = dob.dateToStringSever()
        }
        if let avatarImage = self.avatar {
            self.userRequest.payload.images.avatar = avatarImage.toBase64() ?? ""
        }
        if let coverImage = self.cover {
            self.userRequest.payload.images.cover = coverImage.toBase64() ?? ""
        }
        self.userRepository.updateInfo(userId: self.castcleId, userRequest: self.userRequest) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    self.userInfo = UserInfo(json: json)
                    if isPage {
                        UserHelper.shared.updateSinglePage(page: self.userInfo)
                    } else {
                        UserHelper.shared.updateLocalProfile(user: self.userInfo)
                    }
                    self.delegate?.didUpdateInfoFinish(success: true)
                } catch {
                    self.delegate?.didUpdateInfoFinish(success: false)
                }
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.delegate?.didUpdateInfoFinish(success: false)
                }
            }
        }
    }

    func mappingData() {
        if self.profileType == .mine {
            self.mappingMineInfo()
        } else {
            self.mappingPageInfo()
        }
    }

    private func mappingMineInfo() {
        self.userRequest.payload.overview = UserManager.shared.overview
        self.userRequest.payload.links.facebook = UserManager.shared.facebookLink
        self.userRequest.payload.links.twitter = UserManager.shared.twitterLink
        self.userRequest.payload.links.youtube = UserManager.shared.youtubeLink
        self.userRequest.payload.links.medium = UserManager.shared.mediumLink
        self.userRequest.payload.links.website = UserManager.shared.websiteLink
    }

    private func mappingPageInfo() {
        
    }

    func isCanUpdateInfo() -> Bool {
        if self.profileType == .mine {
            return self.isMineInfoUpdate()
        } else if self.profileType == .user {
            return false
        } else {
            return false
        }
    }

    private func isMineInfoUpdate() -> Bool {
        if self.avatar != nil {
            return true
        } else if self.cover != nil {
            return true
        } else if self.dobDate != nil {
            return true
        } else if !self.userRequest.payload.castcleId.isEmpty && (self.userRequest.payload.castcleId != UserManager.shared.castcleId) {
            return true
        } else if !self.userRequest.payload.displayName.isEmpty && (self.userRequest.payload.displayName != UserManager.shared.displayName) {
            return true
        } else if self.userRequest.payload.overview != UserManager.shared.overview {
            return true
        } else if self.userRequest.payload.links.facebook != UserManager.shared.facebookLink {
            return true
        } else if self.userRequest.payload.links.twitter != UserManager.shared.twitterLink {
            return true
        } else if self.userRequest.payload.links.youtube != UserManager.shared.youtubeLink {
            return true
        } else if self.userRequest.payload.links.medium != UserManager.shared.mediumLink {
            return true
        } else if self.userRequest.payload.links.website != UserManager.shared.websiteLink {
            return true
        } else {
            return false
        }
    }
}

extension EditInfoViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.state == .updateUserInfo {
            self.updateProfile(isPage: self.isPage, castcleId: self.castcleId)
        } else if self.state == .getMe {
            self.getMeInfo()
        } else if self.state == .getUserInfo {
            self.getUserInfo()
        }
    }
}
