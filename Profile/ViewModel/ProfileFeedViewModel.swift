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
//  ProfileFeedViewModel.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 4/1/2565 BE.
//

import Core
import Networking
import SwiftyJSON

public enum ProfileContentType: String {
    case all
    case post
    case blog
    case photo
    case unknow
}

public protocol ProfileFeedViewModelDelegate {
    func didGetContentFinish(success: Bool)
}

public final class ProfileFeedViewModel {
   
    public var delegate: ProfileFeedViewModelDelegate?
    private var contentRepository: ContentRepository = ContentRepositoryImpl()
    private var pageRepository: PageRepository = PageRepositoryImpl()
    private var userRepository: UserRepository = UserRepositoryImpl()
    var contentRequest: ContentRequest = ContentRequest()
    var allContents: [Content] = []
    var postContents: [Content] = []
    var blogContents: [Content] = []
    var photoContents: [Content] = []
    var allMeta: Meta = Meta()
    var postMeta: Meta = Meta()
    var blogMeta: Meta = Meta()
    var photoMeta: Meta = Meta()
    var profileContentType: ProfileContentType = .all
    var profileType: ProfileType = .unknow
    let tokenHelper: TokenHelper = TokenHelper()
    var page: Page = Page()
    var castcleId: String = ""
    var allLoaded: Bool = false
    var postLoaded: Bool = false
    var blogLoaded: Bool = false
    var photoLoaded: Bool = false
    var allCanLoad: Bool = true
    var postCanLoad: Bool = true
    var blogCanLoad: Bool = true
    var photoCanLoad: Bool = true
    
    var displayContents: [Content] {
        if self.profileContentType == .post {
            return self.postContents
        } else if self.profileContentType == .blog {
            return self.blogContents
        } else if self.profileContentType == .photo {
            return self.photoContents
        } else {
            return self.allContents
        }
    }
    
    var feedLoaded: Bool {
        if self.profileContentType == .post {
            return self.postLoaded
        } else if self.profileContentType == .blog {
            return self.blogLoaded
        } else if self.profileContentType == .photo {
            return self.photoCanLoad
        } else {
            return self.allLoaded
        }
    }
    
    var feedCanLoad: Bool {
        if self.profileContentType == .post {
            return self.postCanLoad
        } else if self.profileContentType == .blog {
            return self.blogCanLoad
        } else if self.profileContentType == .photo {
            return self.photoLoaded
        } else {
            return self.allCanLoad
        }
    }

    //MARK: Input
    public func getContents() {
        if self.profileContentType == .all {
            self.contentRequest.type = .unknow
            self.contentRequest.maxResults = self.allMeta.resultCount
            self.contentRequest.untilId = self.allMeta.oldestId
        } else if self.profileContentType == .post {
            self.contentRequest.type = .short
            self.contentRequest.maxResults = self.postMeta.resultCount
            self.contentRequest.untilId = self.postMeta.oldestId
        } else if self.profileContentType == .blog {
            self.contentRequest.type = .blog
            self.contentRequest.maxResults = self.blogMeta.resultCount
            self.contentRequest.untilId = self.blogMeta.oldestId
        } else if self.profileContentType == .photo {
            self.contentRequest.type = .image
            self.contentRequest.maxResults = self.photoMeta.resultCount
            self.contentRequest.untilId = self.photoMeta.oldestId
        }
        
        if self.profileType == .me {
            self.contentRepository.getMeContents(contentRequest: self.contentRequest) { (success, response, isRefreshToken) in
                if success {
                    do {
                        let rawJson = try response.mapJSON()
                        let json = JSON(rawJson)
                        let shelf = ContentShelf(json: json)
                        if self.profileContentType == .all {
                            if shelf.meta.resultCount < self.contentRequest.maxResults {
                                self.allCanLoad = false
                            }
                            self.allContents.append(contentsOf: shelf.contents)
                            self.allMeta = shelf.meta
                            self.allMeta.resultCount = 25
                            self.allLoaded = true
                        } else if self.profileContentType == .post {
                            if shelf.meta.resultCount < self.contentRequest.maxResults {
                                self.postCanLoad = false
                            }
                            self.postContents.append(contentsOf: shelf.contents)
                            self.postMeta = shelf.meta
                            self.postMeta.resultCount = 25
                            self.postLoaded = true
                        } else if self.profileContentType == .blog {
                            if shelf.meta.resultCount < self.contentRequest.maxResults {
                                self.blogCanLoad = false
                            }
                            self.blogContents.append(contentsOf: shelf.contents)
                            self.blogMeta = shelf.meta
                            self.blogMeta.resultCount = 25
                            self.blogLoaded = true
                        } else if self.profileContentType == .photo {
                            if shelf.meta.resultCount < self.contentRequest.maxResults {
                                self.photoCanLoad = false
                            }
                            self.photoContents.append(contentsOf: shelf.contents)
                            self.photoMeta = shelf.meta
                            self.photoMeta.resultCount = 25
                            self.photoLoaded = true
                        }
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
        } else if self.profileType == .myPage || self.profileType == .page {
            self.pageRepository.getPageContent(pageId: self.page.castcleId, contentRequest: self.contentRequest) { (success, response, isRefreshToken) in
                if success {
                    do {
                        let rawJson = try response.mapJSON()
                        let json = JSON(rawJson)
                        let shelf = ContentShelf(json: json)
                        if self.profileContentType == .all {
                            if shelf.meta.resultCount < self.contentRequest.maxResults {
                                self.allCanLoad = false
                            }
                            self.allContents.append(contentsOf: shelf.contents)
                            self.allMeta = shelf.meta
                            self.allMeta.resultCount = 25
                            self.allLoaded = true
                        } else if self.profileContentType == .post {
                            if shelf.meta.resultCount < self.contentRequest.maxResults {
                                self.postCanLoad = false
                            }
                            self.postContents.append(contentsOf: shelf.contents)
                            self.postMeta = shelf.meta
                            self.postMeta.resultCount = 25
                            self.postLoaded = true
                        } else if self.profileContentType == .blog {
                            if shelf.meta.resultCount < self.contentRequest.maxResults {
                                self.blogCanLoad = false
                            }
                            self.blogContents.append(contentsOf: shelf.contents)
                            self.blogMeta = shelf.meta
                            self.blogMeta.resultCount = 25
                            self.blogLoaded = true
                        } else if self.profileContentType == .photo {
                            if shelf.meta.resultCount < self.contentRequest.maxResults {
                                self.photoCanLoad = false
                            }
                            self.photoContents.append(contentsOf: shelf.contents)
                            self.photoMeta = shelf.meta
                            self.photoMeta.resultCount = 25
                            self.photoLoaded = true
                        }
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
        } else {
            self.userRepository.getUserContents(userId: self.castcleId, contentRequest: self.contentRequest) { (success, response, isRefreshToken) in
                if success {
                    do {
                        let rawJson = try response.mapJSON()
                        let json = JSON(rawJson)
                        let shelf = ContentShelf(json: json)
                        if self.profileContentType == .all {
                            if shelf.meta.resultCount < self.contentRequest.maxResults {
                                self.allCanLoad = false
                            }
                            self.allContents.append(contentsOf: shelf.contents)
                            self.allMeta = shelf.meta
                            self.allMeta.resultCount = 25
                            self.allLoaded = true
                        } else if self.profileContentType == .post {
                            if shelf.meta.resultCount < self.contentRequest.maxResults {
                                self.postCanLoad = false
                            }
                            self.postContents.append(contentsOf: shelf.contents)
                            self.postMeta = shelf.meta
                            self.postMeta.resultCount = 25
                            self.postLoaded = true
                        } else if self.profileContentType == .blog {
                            if shelf.meta.resultCount < self.contentRequest.maxResults {
                                self.blogCanLoad = false
                            }
                            self.blogContents.append(contentsOf: shelf.contents)
                            self.blogMeta = shelf.meta
                            self.blogMeta.resultCount = 25
                            self.blogLoaded = true
                        } else if self.profileContentType == .photo {
                            if shelf.meta.resultCount < self.contentRequest.maxResults {
                                self.photoCanLoad = false
                            }
                            self.photoContents.append(contentsOf: shelf.contents)
                            self.photoMeta = shelf.meta
                            self.photoMeta.resultCount = 25
                            self.photoLoaded = true
                        }
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
    }

    public init(profileContentType: ProfileContentType, profileType: ProfileType, page: Page = Page(), castcleId: String) {
        self.profileContentType = profileContentType
        self.tokenHelper.delegate = self
        self.allContents = []
        self.postContents = []
        self.blogContents = []
        self.photoContents = []
        self.profileType = profileType
        self.page = page
        self.castcleId = castcleId
        self.allMeta = Meta()
        self.postMeta = Meta()
        self.blogMeta = Meta()
        self.photoMeta = Meta()
        self.contentRequest = ContentRequest()
    }

    public func resetContent() {
        self.allContents = []
        self.postContents = []
        self.blogContents = []
        self.photoContents = []
        self.allMeta = Meta()
        self.postMeta = Meta()
        self.blogMeta = Meta()
        self.photoMeta = Meta()
        self.contentRequest = ContentRequest()
        self.allLoaded = false
        self.postLoaded = false
        self.blogLoaded = false
        self.photoLoaded = false
        self.allCanLoad = true
        self.postCanLoad = true
        self.blogCanLoad = true
        self.photoCanLoad = true
        self.getContents()
    }
    
    func removeContentAt(index: Int) {
        if self.profileContentType == .all {
            self.allContents.remove(at: index)
        } else if self.profileContentType == .post {
            self.postContents.remove(at: index)
        } else if self.profileContentType == .blog {
            self.blogContents.remove(at: index)
        } else if self.profileContentType == .photo {
            self.photoContents.remove(at: index)
        }
    }
}

extension ProfileFeedViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        self.getContents()
    }
}
