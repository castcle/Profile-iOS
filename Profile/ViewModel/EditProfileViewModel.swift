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
import Networking
import SwiftyJSON

public protocol EditProfileViewModelDelegate {
    func didUpdateProfileFinish(success: Bool)
    func didUpdatePageFinish(success: Bool)
}

class EditProfileViewModel {
    
    public var delegate: EditProfileViewModelDelegate?
    
    var userRepository: UserRepository = UserRepositoryImpl()
    var pageRepository: PageRepository = PageRepositoryImpl()
    var userRequest: UserRequest = UserRequest()
    var pageRequest: PageRequest = PageRequest()
    let tokenHelper: TokenHelper = TokenHelper()
    private var stage: Stage = .none
    var avatar: UIImage? = nil
    var cover: UIImage? = nil
    var dobDate: Date? = nil
    var castcleId: String = ""
    var pageInfo: PageInfo = PageInfo()
    
    enum Stage {
        case updateProfile
        case updateAvatar
        case updateCover
        case updatePageInfo
        case updatePageAvatar
        case updatePageCover
        case getInfo
        case none
    }

    //MARK: Input
    public init(userRequest: UserRequest = UserRequest()) {
        self.userRequest = userRequest
        self.tokenHelper.delegate = self
    }
    
    public func updateProfile() {
        self.stage = .updateProfile
        if let dob = self.dobDate {
            self.userRequest.payload.dob = dob.dateToStringSever()
        }
        self.userRepository.updateMe(userRequest: self.userRequest) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let userHelper = UserHelper()
                    userHelper.updateLocalProfile(user: User(json: json))
                    self.delegate?.didUpdateProfileFinish(success: true)
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.delegate?.didUpdateProfileFinish(success: false)
                }
            }
        }
    }
    
    public func updateAvatar() {
        guard let image = self.avatar else { return }
        self.stage = .updateAvatar
        self.userRequest.payload.images.avatar = image.toBase64() ?? ""
        self.userRepository.updateMeAvatar(userRequest: self.userRequest) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let userHelper = UserHelper()
                    let user = User(json: json)
                    userHelper.updateLocalProfile(user: user)
                    self.delegate?.didUpdateProfileFinish(success: true)
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.delegate?.didUpdateProfileFinish(success: false)
                }
            }
        }
    }
    
    public func updateCover() {
        guard let image = self.cover else { return }
        self.stage = .updateCover
        self.userRequest.payload.images.cover = image.toBase64() ?? ""
        self.userRepository.updateMeCover(userRequest: self.userRequest) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let userHelper = UserHelper()
                    let user = User(json: json)
                    userHelper.updateLocalProfile(user: user)
                    self.delegate?.didUpdateProfileFinish(success: true)
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.delegate?.didUpdateProfileFinish(success: false)
                }
            }
        }
    }
    
    func updatePageInfo(castcleId: String) {
        self.castcleId = castcleId
        if !self.castcleId.isEmpty {
            self.stage = .updatePageInfo
            self.pageRepository.updatePageInfo(pageId: self.castcleId, pageRequest: self.pageRequest) { (success, response, isRefreshToken) in
                if success {
                    self.stage = .none
                    self.delegate?.didUpdatePageFinish(success: true)
                } else {
                    if isRefreshToken {
                        self.tokenHelper.refreshToken()
                    } else {
                        self.delegate?.didUpdatePageFinish(success: false)
                    }
                }
            }
        } else {
            self.delegate?.didUpdatePageFinish(success: false)
        }
    }
    
    func updatePageAvatar(castcleId: String) {
        self.castcleId = castcleId
        if !self.castcleId.isEmpty, let image = self.avatar {
            self.stage = .updatePageAvatar
            self.pageRequest.avatar = image.toBase64() ?? ""
            self.pageRepository.updatePageAvatar(pageId: self.castcleId, pageRequest: self.pageRequest) { (success, response, isRefreshToken) in
                if success {
                    self.stage = .none
                    self.delegate?.didUpdatePageFinish(success: true)
                } else {
                    if isRefreshToken {
                        self.tokenHelper.refreshToken()
                    } else {
                        self.delegate?.didUpdatePageFinish(success: false)
                    }
                }
            }
        } else {
            self.delegate?.didUpdatePageFinish(success: false)
        }
    }
    
    func updatePageCover(castcleId: String) {
        self.castcleId = castcleId
        if !self.castcleId.isEmpty, let image = self.cover {
            self.stage = .updatePageCover
            self.pageRequest.cover = image.toBase64() ?? ""
            self.pageRepository.updatePageCover(pageId: self.castcleId, pageRequest: self.pageRequest) { (success, response, isRefreshToken) in
                if success {
                    self.stage = .none
                    self.delegate?.didUpdatePageFinish(success: true)
                } else {
                    if isRefreshToken {
                        self.tokenHelper.refreshToken()
                    } else {
                        self.delegate?.didUpdatePageFinish(success: false)
                    }
                }
            }
        } else {
            self.delegate?.didUpdatePageFinish(success: false)
        }
    }
    
    func getPageInfo(castcleId: String) {
        self.castcleId = castcleId
        if !self.castcleId.isEmpty {
            self.stage = .getInfo
            self.pageRepository.getPageInfo(pageId: self.castcleId) { (success, response, isRefreshToken) in
                if success {
                    do {
                        let rawJson = try response.mapJSON()
                        let json = JSON(rawJson)
                        self.pageInfo = PageInfo(json: json)
                        self.didGetPageInfoFinish?()
                    } catch {
                        
                    }
                } else {
                    if isRefreshToken {
                        self.tokenHelper.refreshToken()
                    }
                }
            }
        } else {
            self.delegate?.didUpdatePageFinish(success: false)
        }
    }
    
    var didGetPageInfoFinish: (() -> ())?
}

extension EditProfileViewModel: TokenHelperDelegate {
    func didRefreshTokenFinish() {
        if self.stage == .updateProfile {
            self.updateProfile()
        } else if self.stage == .updateAvatar {
            self.updateAvatar()
        } else if self.stage == .updateCover {
            self.updateCover()
        } else if self.stage == .updatePageInfo {
            self.updatePageInfo(castcleId: self.castcleId)
        } else if self.stage == .updatePageAvatar {
            self.updatePageAvatar(castcleId: self.castcleId)
        } else if self.stage == .updatePageCover {
            self.updatePageCover(castcleId: self.castcleId)
        } else if self.stage == .getInfo {
            self.getPageInfo(castcleId: self.castcleId)
        }
    }
}
