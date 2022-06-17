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
import Moya

public protocol EditProfileViewModelDelegate: AnyObject {
    func didUpdateInfoFinish(success: Bool)
}

class EditProfileViewModel {

    public var delegate: EditProfileViewModelDelegate?
    var userRepository: UserRepository = UserRepositoryImpl()
    var userRequest: UserRequest = UserRequest()
    let tokenHelper: TokenHelper = TokenHelper()
    private var state: State = .none
    var avatar: UIImage?
    var cover: UIImage?
    var dobDate: Date?
    var castcleId: String = ""
    var isPage: Bool = false
    var userInfo: UserInfo = UserInfo()

    // MARK: - Input
    public init() {
        self.tokenHelper.delegate = self
    }

    public func updateProfile(isPage: Bool, castcleId: String) {
        self.state = .updateUserInfo
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
                        UserHelper.shared.updateLocalProfile(user: UserInfo(json: json))
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
        self.state = .updateUserAvatar
        self.isPage = isPage
        self.castcleId = castcleId
        self.userRequest.payload.images.avatar = image.toBase64() ?? ""
        self.userRepository.updateAvatar(userId: self.castcleId, userRequest: self.userRequest) { (success, response, isRefreshToken) in
            if success {
                self.updateLocalInfo(response: response, isAvatar: true)
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
        self.state = .updateUserCover
        self.isPage = isPage
        self.castcleId = castcleId
        self.userRequest.payload.images.cover = image.toBase64() ?? ""
        self.userRepository.updateCover(userId: self.castcleId, userRequest: self.userRequest) { (success, response, isRefreshToken) in
            if success {
                self.updateLocalInfo(response: response, isAvatar: false)
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.delegate?.didUpdateInfoFinish(success: false)
                }
            }
        }
    }

    private func updateLocalInfo(response: Response, isAvatar: Bool) {
        do {
            let realm = try Realm()
            let rawJson = try response.mapJSON()
            let json = JSON(rawJson)
            let user = UserInfo(json: json)
            if self.isPage {
                let pageRealm = realm.objects(Page.self).filter("castcleId == '\(user.castcleId)'").first
                if let page = pageRealm {
                    try realm.write {
                        page.avatar = user.images.avatar.thumbnail
                        page.cover = user.images.cover.fullHd
                        realm.add(page, update: .modified)
                    }
                }
            } else {
                UserHelper.shared.updateLocalProfile(user: user)
            }
            self.delegate?.didUpdateInfoFinish(success: true)
        } catch {}
    }
}

extension EditProfileViewModel: TokenHelperDelegate {
    func didRefreshTokenFinish() {
        if self.state == .updateUserInfo {
            self.updateProfile(isPage: self.isPage, castcleId: self.castcleId)
        } else if self.state == .updateUserAvatar {
            self.updateAvatar(isPage: self.isPage, castcleId: self.castcleId)
        } else if self.state == .updateUserCover {
            self.updateCover(isPage: self.isPage, castcleId: self.castcleId)
        }
    }
}
