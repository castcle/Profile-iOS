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
//  DeletePageViewModel.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 25/10/2564 BE.
//

import Foundation
import Networking
import SwiftyJSON

public protocol DeletePageViewModelDelegate {
    func didDeletePageFinish(success: Bool)
}

public class DeletePageViewModel {
    
    public var delegate: DeletePageViewModelDelegate?
    
    var pageRepository: PageRepository = PageRepositoryImpl()
    var pageRequest: PageRequest = PageRequest()
    let tokenHelper: TokenHelper = TokenHelper()
    private var stage: Stage = .none
    var page: PageInfo = PageInfo()
    
    enum Stage {
        case deletePage
        case none
    }

    //MARK: Input
    public init(page: PageInfo) {
        self.page = page
        self.tokenHelper.delegate = self
    }
    
    public func deletePage() {
        self.stage = .deletePage
        self.pageRepository.deletePage(pageId: self.page.castcleId, pageRequest: self.pageRequest) { (success, response, isRefreshToken) in
            if success {
                self.delegate?.didDeletePageFinish(success: true)
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.delegate?.didDeletePageFinish(success: false)
                }
            }
        }
    }
}

extension DeletePageViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.stage == .deletePage {
            self.deletePage()
        }
    }
}
