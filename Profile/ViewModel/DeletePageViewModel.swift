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
import Core
import Networking
import SwiftyJSON
import RealmSwift

public protocol DeletePageViewModelDelegate: AnyObject {
    func didDeletePageFinish(success: Bool)
    func didGetAllPageFinish()
}

public class DeletePageViewModel {

    public var delegate: DeletePageViewModelDelegate?

    var pageRepository: PageRepository = PageRepositoryImpl()
    var pageRequest: PageRequest = PageRequest()
    let tokenHelper: TokenHelper = TokenHelper()
    private var state: State = .none
    var userInfo: UserInfo = UserInfo()

    // MARK: - Input
    public init(userInfo: UserInfo) {
        self.userInfo = userInfo
        self.tokenHelper.delegate = self
    }

    public func deletePage() {
        self.state = .deletePage
        self.pageRepository.deletePage(pageId: self.userInfo.castcleId, pageRequest: self.pageRequest) { (success, _, isRefreshToken) in
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

    func getAllMyPage() {
        self.state = .getMyPage
        self.pageRepository.getMyPage { (success, response, isRefreshToken) in
            if success {
                self.state = .none
                do {
                    let realm = try Realm()
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let pages = json[JsonKey.payload.rawValue].arrayValue
                    let pageRealm = realm.objects(Page.self)
                    try realm.write {
                        realm.delete(pageRealm)
                    }
                    UserHelper.shared.updatePage(pages: pages)
                    self.delegate?.didGetAllPageFinish()
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.delegate?.didGetAllPageFinish()
                }
            }
        }
    }
}

extension DeletePageViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.state == .deletePage {
            self.deletePage()
        } else if self.state == .getMyPage {
            self.getAllMyPage()
        }
    }
}
