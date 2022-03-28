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
import Networking
import SwiftyJSON

public protocol EditInfoViewModelDelegate {
    func didGetInfoFinish(success: Bool)
    func didUpdateInfoFinish(success: Bool)
}

class EditInfoViewModel {
    public var delegate: EditInfoViewModelDelegate?
    var userRepository: UserRepository = UserRepositoryImpl()
    var userRequest: UserRequest = UserRequest()
    let tokenHelper: TokenHelper = TokenHelper()
    var profileType: ProfileType = .unknow
    var userInfo: UserInfo = UserInfo()
    var avatar: UIImage? = nil
    var cover: UIImage? = nil
    var dobDate: Date? = nil
    var castcleId: String = ""
    var isPage: Bool = false
    var state: State = .none
    
    enum State {
        case getMeInfo
        case getUserInfo
        case updateUserInfo
        case none
    }
    
    public init(profileType: ProfileType = .unknow, userInfo: UserInfo = UserInfo()) {
        self.tokenHelper.delegate = self
        self.profileType = profileType
        self.userInfo = userInfo
    }
    
    func getMeInfo() {
        self.state = .getMeInfo
        self.userRepository.getMe() { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let userHelper = UserHelper()
                    userHelper.updateLocalProfile(user: UserInfo(json: json))
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
        self.userRepository.getUser(userId: self.castcleId) { (success, response, isRefreshToken) in
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
                if isPage {
                    self.delegate?.didUpdateInfoFinish(success: true)
                } else {
                    do {
                        let rawJson = try response.mapJSON()
                        let json = JSON(rawJson)
                        let userHelper = UserHelper()
                        userHelper.updateLocalProfile(user: UserInfo(json: json))
                        self.delegate?.didUpdateInfoFinish(success: true)
                    } catch {
                        self.delegate?.didUpdateInfoFinish(success: false)
                    }
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
}

extension EditInfoViewModel: TokenHelperDelegate {
    func didRefreshTokenFinish() {
        if self.state == .updateUserInfo {
            self.updateProfile(isPage: self.isPage, castcleId: self.castcleId)
        } else if self.state == .getMeInfo {
            self.getMeInfo()
        } else if self.state == .getUserInfo {
            self.getUserInfo()
        }
    }
}
