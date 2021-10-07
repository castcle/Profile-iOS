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
//  Created by Tanakorn Phoochaliaw on 16/9/2564 BE.
//

import UIKit
import Core
import Networking
import Moya
import SwiftyJSON
import Defaults

public protocol SelectPhotoMethodViewModelDelegate {
    func didUpdatePageFinish(success: Bool)
}

public enum AvatarType {
    case user
    case page
}

public class SelectPhotoMethodViewModel {
    
    public var delegate: SelectPhotoMethodViewModelDelegate?
    var pageRepository: PageRepository = PageRepositoryImpl()
    var pageRequest: PageRequest = PageRequest()
    let tokenHelper: TokenHelper = TokenHelper()
    var avatar: UIImage?
    var avatarType: AvatarType
    var stage: Stage = .none
    var castcleId: String
    
    enum Stage {
        case updateAvatar
        case none
    }
    
    //MARK: Input
    public init(avatarType: AvatarType, pageRequest: PageRequest = PageRequest(), castcleId: String = "") {
        self.pageRequest = pageRequest
        self.avatarType = avatarType
        self.castcleId = castcleId
        self.tokenHelper.delegate = self
    }
    
    func updateAvatar() {
        if !self.castcleId.isEmpty, let image = self.avatar {
            self.pageRequest.avatar = image.toBase64() ?? ""
            self.pageRepository.updatePageAvatar(pageId: self.castcleId, pageRequest: self.pageRequest) { (success, response, isRefreshToken) in
                if success {
                    self.stage = .none
                    self.tokenHelper.refreshToken()
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
}

extension SelectPhotoMethodViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.stage == .updateAvatar {
            self.updateAvatar()
        }
    }
}
