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
//  AboutInfoViewModel.swift
//  Profile
//
//  Created by Tanakorn Phoochaliaw on 6/8/2564 BE.
//

import Foundation
import Core
import Networking
import Defaults
import SwiftyJSON

protocol AboutInfoViewModelDelegate {
    func didUpdateUserInfoFinish(success: Bool)
    func didUpdatePageInfoFinish(success: Bool)
}

public class AboutInfoViewModel {
   
    //MARK: Private
    var delegate: AboutInfoViewModelDelegate?
    var socialLinkShelf: SocialLinkShelf = SocialLinkShelf()
    var userRepository: UserRepository = UserRepositoryImpl()
    var pageRepository: PageRepository = PageRepositoryImpl()
    var userRequest: UserRequest = UserRequest()
    var pageRequest: PageRequest = PageRequest()
    let tokenHelper: TokenHelper = TokenHelper()
    var isSkip: Bool = true
    var avatarType: AvatarType
    var overView: String = ""
    var dobDisplay: String = ""
    var dobDate: Date?
    var castcleId: String
    var stage: Stage = .none
    
    enum Stage {
        case updateUserInfo
        case updatePageInfo
        case none
    }

    //MARK: Input
    public init(avatarType: AvatarType, castcleId: String = "") {
        self.avatarType = avatarType
        self.castcleId = castcleId
        self.tokenHelper.delegate = self
    }
    
    func clearData() {
        Defaults[.facebook] = ""
        Defaults[.twitter] = ""
        Defaults[.youtube] = ""
        Defaults[.medium] = ""
        Defaults[.website] = ""
        self.socialLinkShelf.socialLinks = []
    }
    
    func mappingData() {
        self.socialLinkShelf.socialLinks = []
        if !Defaults[.facebook].isEmpty {
            self.socialLinkShelf.socialLinks.append(SocialLink(socialLinkType: .facebook, value: Defaults[.facebook]))
        }
        
        if !Defaults[.twitter].isEmpty {
            self.socialLinkShelf.socialLinks.append(SocialLink(socialLinkType: .twitter, value: Defaults[.twitter]))
        }
        
        if !Defaults[.youtube].isEmpty {
            self.socialLinkShelf.socialLinks.append(SocialLink(socialLinkType: .youtube, value: Defaults[.youtube]))
        }
        
        if !Defaults[.medium].isEmpty {
            self.socialLinkShelf.socialLinks.append(SocialLink(socialLinkType: .medium, value: Defaults[.medium]))
        }
        
        if !Defaults[.website].isEmpty {
            self.socialLinkShelf.socialLinks.append(SocialLink(socialLinkType: .website, value: Defaults[.website]))
        }

        self.didMappingFinish?()
    }
    
    public func updateUserInfo() {
        self.stage = .updateUserInfo
        if let dob = self.dobDate {
            self.userRequest.payload.dob = dob.dateToStringSever()
        }
        
        self.userRequest.payload.overview = self.overView
        self.userRequest.payload.links.facebook = Defaults[.facebook]
        self.userRequest.payload.links.twitter = Defaults[.twitter]
        self.userRequest.payload.links.youtube = Defaults[.youtube]
        self.userRequest.payload.links.medium = Defaults[.medium]
        self.userRequest.payload.links.website = Defaults[.website]
        
        self.userRepository.updateMe(userRequest: self.userRequest) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let userHelper = UserHelper()
                    userHelper.updateLocalProfile(user: User(json: json))
                    self.delegate?.didUpdateUserInfoFinish(success: true)
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.delegate?.didUpdateUserInfoFinish(success: false)
                }
            }
        }
    }
    
    func updatePageInfo() {
        self.stage = .updatePageInfo
        self.pageRequest.overview = self.overView
        self.pageRequest.links.facebook = Defaults[.facebook]
        self.pageRequest.links.twitter = Defaults[.twitter]
        self.pageRequest.links.youtube = Defaults[.youtube]
        self.pageRequest.links.medium = Defaults[.medium]
        self.pageRequest.links.website = Defaults[.website]
        
        self.pageRepository.updatePageInfo(pageId: self.castcleId, pageRequest: self.pageRequest) { (success, response, isRefreshToken) in
            if success {
                self.stage = .none
                self.delegate?.didUpdatePageInfoFinish(success: true)
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.delegate?.didUpdatePageInfoFinish(success: false)
                }
            }
        }
    }
    
    //MARK: Output
    var didMappingFinish: (() -> ())?
}

extension AboutInfoViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.stage == .updatePageInfo {
            self.updatePageInfo()
        } else if self.stage == .updateUserInfo {
            self.updateUserInfo()
        }
    }
}
