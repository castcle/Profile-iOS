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
//  UpdateUserImageViewModel.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 10/5/2565 BE.
//

import UIKit
import Core
import Networking
import SwiftyJSON

public protocol UpdateUserImageViewModelDelegate: AnyObject {
    func didUpdateInfoFinish(success: Bool)
}

public class UpdateUserImageViewModel {
    public var delegate: UpdateUserImageViewModelDelegate?
    var userRepository: UserRepository = UserRepositoryImpl()
    var userRequest: UserRequest = UserRequest()
    let tokenHelper: TokenHelper = TokenHelper()
    var avatar: UIImage?
    var cover: UIImage?
    var state: State = .none

    public init() {
        self.tokenHelper.delegate = self
    }

    public func updateProfile() {
        self.state = .updateUserInfo
        if let avatarImage = self.avatar {
            self.userRequest.payload.images.avatar = avatarImage.toBase64() ?? ""
        }
        if let coverImage = self.cover {
            self.userRequest.payload.images.cover = coverImage.toBase64() ?? ""
        }
        self.userRepository.updateInfo(userId: UserManager.shared.rawCastcleId, userRequest: self.userRequest) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    UserHelper.shared.updateLocalProfile(user: UserInfo(json: json))
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
}

extension UpdateUserImageViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.state == .updateUserInfo {
            self.updateProfile()
        }
    }
}
