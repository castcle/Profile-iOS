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
//  SelectPhotoMethodViewModel.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 16/9/2564 BE.
//

import UIKit
import Core
import Networking
import Moya
import SwiftyJSON
import Defaults
import RealmSwift

public protocol SelectPhotoMethodViewModelDelegate {
    func didUpdateUserFinish(success: Bool)
    func didUpdatePageFinish(success: Bool)
    func didGetPageFinish()
}

public enum AvatarType {
    case user
    case page
}

public class SelectPhotoMethodViewModel {
    
    public var delegate: SelectPhotoMethodViewModelDelegate?
    var userRepository: UserRepository = UserRepositoryImpl()
    var pageRepository: PageRepository = PageRepositoryImpl()
    var userRequest: UserRequest = UserRequest()
    var pageRequest: PageRequest = PageRequest()
    let tokenHelper: TokenHelper = TokenHelper()
    var avatar: UIImage?
    var avatarType: AvatarType
    var stage: Stage = .none
    var castcleId: String
    private let realm = try! Realm()
    
    enum Stage {
        case updateUserAvatar
        case updatePageAvatar
        case getMyPage
        case none
    }
    
    //MARK: Input
    public init(avatarType: AvatarType, pageRequest: PageRequest = PageRequest(), castcleId: String = "") {
        self.pageRequest = pageRequest
        self.avatarType = avatarType
        self.castcleId = castcleId
        self.tokenHelper.delegate = self
    }
    
    public func updateUserAvatar() {
        guard let image = self.avatar else { return }
        self.stage = .updateUserAvatar
        self.userRequest.payload.images.avatar = image.toBase64() ?? ""
        self.userRepository.updateMeAvatar(userRequest: self.userRequest) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let userHelper = UserHelper()
                    let user = User(json: json)
                    userHelper.updateLocalProfile(user: user)
                    self.delegate?.didUpdateUserFinish(success: true)
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.delegate?.didUpdateUserFinish(success: false)
                }
            }
        }
    }
    
    func updatePageAvatar() {
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
    
    func getMyPage() {
        self.stage = .getMyPage
        self.pageRepository.getMyPage() { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let pageList = json[AuthenticationApiKey.payload.rawValue].arrayValue
                    let pageLocal = self.realm.objects(PageLocal.self)
                    try! self.realm.write {
                        self.realm.delete(pageLocal)
                    }
                    
                    pageList.forEach { page in
                        let pageInfo = PageInfo(json: page)
                        try! self.realm.write {
                            let pageLocal = PageLocal()
                            pageLocal.id = pageInfo.id
                            pageLocal.castcleId = pageInfo.castcleId
                            pageLocal.displayName = pageInfo.displayName
                            pageLocal.image = pageInfo.image.avatar.fullHd
                            self.realm.add(pageLocal, update: .modified)
                        }
                        
                    }
                    self.delegate?.didGetPageFinish()
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.delegate?.didGetPageFinish()
                }
            }
        }
    }
}

extension SelectPhotoMethodViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.stage == .updatePageAvatar {
            self.updatePageAvatar()
        } else if self.stage == .updateUserAvatar {
            self.updateUserAvatar()
        } else if self.stage == .getMyPage {
            self.getMyPage()
        }
    }
}
