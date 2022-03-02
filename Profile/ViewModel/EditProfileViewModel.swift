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
//  EditProfileViewModel.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 14/9/2564 BE.
//

import UIKit
import Core
import Networking
import SwiftyJSON
import RealmSwift

public protocol EditProfileViewModelDelegate {
    func didUpdateInfoFinish(success: Bool)
}

class EditProfileViewModel {
    
    public var delegate: EditProfileViewModelDelegate?
    var userRepository: UserRepository = UserRepositoryImpl()
    var userRequest: UserRequest = UserRequest()
    let tokenHelper: TokenHelper = TokenHelper()
    private var stage: Stage = .none
    var avatar: UIImage? = nil
    var cover: UIImage? = nil
    var dobDate: Date? = nil
    var castcleId: String = ""
    var isPage: Bool = false
    var userInfo: UserInfo = UserInfo()
    private let realm = try! Realm()
    
    enum Stage {
        case updateProfile
        case updateAvatar
        case updateCover
        case getInfo
        case none
    }

    //MARK: Input
    public init(userRequest: UserRequest = UserRequest()) {
        self.userRequest = userRequest
        self.tokenHelper.delegate = self
    }
    
    public func updateProfile(isPage: Bool, castcleId: String) {
        self.stage = .updateProfile
        self.isPage = isPage
        self.castcleId = castcleId
        if let dob = self.dobDate {
            self.userRequest.payload.dob = dob.dateToStringSever()
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
                    } catch {}
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
    
    public func updateAvatar(isPage: Bool, castcleId: String) {
        guard let image = self.avatar else { return }
        self.stage = .updateAvatar
        self.isPage = isPage
        self.castcleId = castcleId
        self.userRequest.payload.images.avatar = image.toBase64() ?? ""
        self.userRepository.updateAvatar(userId: self.castcleId, userRequest: self.userRequest) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let userHelper = UserHelper()
                    let user = UserInfo(json: json)
                    if isPage {
                        let pageRealm = self.realm.objects(Page.self).filter("castcleId == '\(user.castcleId)'").first
                        if let page = pageRealm {
                            try! self.realm.write {
                                page.avatar = user.images.avatar.thumbnail
                                self.realm.add(page, update: .modified)
                            }
                        }
                    } else {
                        userHelper.updateLocalProfile(user: user)
                    }
                    self.delegate?.didUpdateInfoFinish(success: true)
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.delegate?.didUpdateInfoFinish(success: false)
                }
            }
        }
    }
    
    public func updateCover(isPage: Bool, castcleId: String) {
        guard let image = self.cover else { return }
        self.stage = .updateCover
        self.isPage = isPage
        self.castcleId = castcleId
        self.userRequest.payload.images.cover = image.toBase64() ?? ""
        self.userRepository.updateCover(userId: self.castcleId, userRequest: self.userRequest) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let userHelper = UserHelper()
                    let user = UserInfo(json: json)
                    if self.isPage {
                        let pageRealm = self.realm.objects(Page.self).filter("castcleId == '\(user.castcleId)'").first
                        if let page = pageRealm {
                            try! self.realm.write {
                                page.cover = user.images.cover.fullHd
                                self.realm.add(page, update: .modified)
                            }
                        }
                    } else {
                        userHelper.updateLocalProfile(user: user)
                    }
                    self.delegate?.didUpdateInfoFinish(success: true)
                } catch {}
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

extension EditProfileViewModel: TokenHelperDelegate {
    func didRefreshTokenFinish() {
        if self.stage == .updateProfile {
            self.updateProfile(isPage: self.isPage, castcleId: self.castcleId)
        } else if self.stage == .updateAvatar {
            self.updateAvatar(isPage: self.isPage, castcleId: self.castcleId)
        } else if self.stage == .updateCover {
            self.updateCover(isPage: self.isPage, castcleId: self.castcleId)
        }
    }
}
