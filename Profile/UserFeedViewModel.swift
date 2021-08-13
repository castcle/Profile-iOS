//
//  UserFeedViewModel.swift
//  Profile
//
//  Created by Tanakorn Phoochaliaw on 13/8/2564 BE.
//

import Foundation
import Networking

final class UserFeedViewModel  {
   
    //MARK: Private
    private var feedRepository: FeedRepository
    var feedShelf: FeedShelf = FeedShelf()
    var contentType: ContentType?

    //MARK: Input
    public func getFeeds() {
        self.feedRepository.getFeeds(featureSlug: "Test", circleSlug: "Test") { (success, feedShelf) in
            if success {
                self.feedShelf = feedShelf
            }
            self.didLoadFeedgsFinish?()
        }
    }
    
    //MARK: Output
    var didLoadFeedgsFinish: (() -> ())?
    
    public init(feedRepository: FeedRepository = FeedRepositoryImpl(), contentType: ContentType) {
        self.feedRepository = feedRepository
        self.contentType = contentType
        self.getFeeds()
    }
}
