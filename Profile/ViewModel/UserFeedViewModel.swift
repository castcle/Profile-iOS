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
//  UserFeedViewModel.swift
//  Profile
//
//  Created by Tanakorn Phoochaliaw on 13/8/2564 BE.
//

import Foundation
import Networking
import SwiftyJSON

public enum UserFeedType: String {
    case all
    case post
    case blog
    case photo
    case unknow
}

public protocol UserFeedViewModelDelegate {
    func didGetContentFinish(success: Bool)
}

public final class UserFeedViewModel {
   
    public var delegate: UserFeedViewModelDelegate?
    private var feedRepository: FeedRepository = FeedRepositoryImpl()
    private var contentRepository: ContentRepository = ContentRepositoryImpl()
    var contentRequest: ContentRequest = ContentRequest()
    var contents: [Content] = []
    var pagination: Pagination = Pagination()
    var userFeedType: UserFeedType = .all
    let tokenHelper: TokenHelper = TokenHelper()

    //MARK: Input
    public func getMyContents() {
        self.contentRepository.getMeContents(contentRequest: self.contentRequest) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let shelf = ContentShelf(json: json)
                    self.contents.append(contentsOf: shelf.contents)
                    self.pagination = shelf.pagination
                    self.delegate?.didGetContentFinish(success: true)
                } catch {
                    self.delegate?.didGetContentFinish(success: false)
                }
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.delegate?.didGetContentFinish(success: false)
                }
            }
        }
    }
    
    public init(userFeedType: UserFeedType) {
        self.userFeedType = userFeedType
        self.tokenHelper.delegate = self
        self.contents = []
        if self.userFeedType == .all {
            self.contentRequest.type = .unknow
            self.getMyContents()
        } else if self.userFeedType == .post {
            self.contentRequest.type = .short
            self.getMyContents()
        } else if self.userFeedType == .blog {
            self.contentRequest.type = .blog
            self.getMyContents()
        } else if self.userFeedType == .photo {
            self.contentRequest.type = .image
            self.getMyContents()
        }
    }
}

extension UserFeedViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        self.getMyContents()
    }
}
