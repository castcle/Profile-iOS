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

public enum UserFeedType: String {
    case all
    case post
    case blog
    case photo
}

public final class UserFeedViewModel  {
   
    //MARK: Private
    private var feedRepository: FeedRepository
    var feedShelf: FeedShelf = FeedShelf()
    var userFeedType: UserFeedType = .all

    //MARK: Input
    public func getFeeds() {
        self.feedRepository.getFeeds(featureSlug: "Test", circleSlug: "Test") { (success, feedShelf) in
            if success {
                switch self.userFeedType {
                case .post:
                    self.feedShelf.feeds = feedShelf.feeds.filter {$0.feedPayload.type == .short}
                case .blog:
                    self.feedShelf.feeds = feedShelf.feeds.filter {$0.feedPayload.type == .blog}
                case .photo:
                    self.feedShelf.feeds = feedShelf.feeds.filter {$0.feedPayload.type == .image}
                default:
                    self.feedShelf = feedShelf
                }
            }
            self.didLoadFeedgsFinish?()
        }
    }
    
    //MARK: Output
    var didLoadFeedgsFinish: (() -> ())?
    
    public init(feedRepository: FeedRepository = FeedRepositoryImpl(), userFeedType: UserFeedType) {
        self.feedRepository = feedRepository
        self.userFeedType = userFeedType
        self.getFeeds()
    }
}
