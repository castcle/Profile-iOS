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
//  UserBlockedViewModel.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 28/1/2565 BE.
//

import Core
import Networking
import SwiftyJSON

public protocol UserBlockedViewModelDelegate {
    func didUnblocked()
}

public final class UserBlockedViewModel {
   
    public var delegate: UserBlockedViewModelDelegate?
    var reportRepository: ReportRepository = ReportRepositoryImpl()
    var state: State = .none
    let tokenHelper: TokenHelper = TokenHelper()
    var castcleId: String = ""
    
    public init() {
        self.tokenHelper.delegate = self
    }
    
    func unblockUser(castcleId: String) {
        self.state = .unblockUser
        self.castcleId = castcleId
        self.reportRepository.unblockUser(userId: UserManager.shared.rawCastcleId, targetCastcleId: self.castcleId) { (success, response, isRefreshToken) in
            if success {
                self.delegate?.didUnblocked()
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }
}

extension UserBlockedViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.state == .unblockUser {
            self.unblockUser(castcleId: self.castcleId)
        }
    }
}
