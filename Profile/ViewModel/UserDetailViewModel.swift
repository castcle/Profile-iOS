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
//  UserDetailViewModel.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 14/8/2564 BE.
//

import Foundation
import Core
import Networking
import SwiftyJSON

public enum ProfileType {
    case me
    case myPage
    case people
    case page
    case unknow
}

public final class UserDetailViewModel {
   
    var pageRepository: PageRepository = PageRepositoryImpl()
    var profileType: ProfileType = .unknow
    var page: PageInfo = PageInfo()
    var pageInfo: PageInfo = PageInfo()
    let tokenHelper: TokenHelper = TokenHelper()
    
    var stage: Stage = .none
    
    enum Stage {
        case getInfo
        case none
    }
    
    public init(profileType: ProfileType, page: PageInfo = PageInfo()) {
        self.profileType = profileType
        self.page = page
        self.tokenHelper.delegate = self
        
        if self.profileType == .myPage {
            self.getPageInfo()
        }
    }
    
    func getPageInfo() {
        self.stage = .getInfo
        self.pageRepository.getPageInfo(pageId: self.page.castcleId) { (success, response, isRefreshToken) in
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
    }
    
    var didGetPageInfoFinish: (() -> ())?
}

extension UserDetailViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.stage == .getInfo {
            self.getPageInfo()
        }
    }
}
