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
//  UserInfoViewModel.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 8/8/2564 BE.
//

import Networking

public class UserInfoViewModel {
    
    var profileType: ProfileType = .unknow
    var pageInfo: PageInfo = PageInfo()
    var userInfo: User?
    var socialLink: [SocialLink] = []
    
    init(profileType: ProfileType, pageInfo: PageInfo = PageInfo(), userInfo: User? = nil) {
        self.profileType = profileType
        self.pageInfo = pageInfo
        self.userInfo = userInfo
        
        if self.profileType == .people {
            if !(self.userInfo?.links.facebook.isEmpty ?? true) {
                self.socialLink.append(SocialLink(socialLinkType: .facebook, value: self.userInfo?.links.facebook ?? "N/A"))
            } else {
                self.socialLink.append(SocialLink(socialLinkType: .facebook, value: "N/A"))
            }
            
            if !(self.userInfo?.links.twitter.isEmpty ?? true) {
                self.socialLink.append(SocialLink(socialLinkType: .twitter, value: self.userInfo?.links.twitter ?? "N/A"))
            } else {
                self.socialLink.append(SocialLink(socialLinkType: .twitter, value: "N/A"))
            }
            
            if !(self.userInfo?.links.youtube.isEmpty ?? true) {
                self.socialLink.append(SocialLink(socialLinkType: .youtube, value: self.userInfo?.links.youtube ?? "N/A"))
            } else {
                self.socialLink.append(SocialLink(socialLinkType: .youtube, value: "N/A"))
            }
            
            if !(self.userInfo?.links.medium.isEmpty ?? true) {
                self.socialLink.append(SocialLink(socialLinkType: .medium, value: self.userInfo?.links.medium ?? "N/A"))
            } else {
                self.socialLink.append(SocialLink(socialLinkType: .medium, value: "N/A"))
            }
            
            if !(self.userInfo?.links.website.isEmpty ?? true) {
                self.socialLink.append(SocialLink(socialLinkType: .website, value: self.userInfo?.links.website ?? "N/A"))
            } else {
                self.socialLink.append(SocialLink(socialLinkType: .website, value: "N/A"))
            }
            
        } else if self.profileType == .page {
            if !self.pageInfo.links.facebook.isEmpty {
                self.socialLink.append(SocialLink(socialLinkType: .facebook, value: self.pageInfo.links.facebook))
            } else {
                self.socialLink.append(SocialLink(socialLinkType: .facebook, value: "N/A"))
            }
            
            if !self.pageInfo.links.twitter.isEmpty {
                self.socialLink.append(SocialLink(socialLinkType: .twitter, value: self.pageInfo.links.twitter))
            } else {
                self.socialLink.append(SocialLink(socialLinkType: .twitter, value: "N/A"))
            }
            
            if !self.pageInfo.links.youtube.isEmpty {
                self.socialLink.append(SocialLink(socialLinkType: .youtube, value: self.pageInfo.links.youtube))
            } else {
                self.socialLink.append(SocialLink(socialLinkType: .youtube, value: "N/A"))
            }
            
            if !self.pageInfo.links.medium.isEmpty {
                self.socialLink.append(SocialLink(socialLinkType: .medium, value: self.pageInfo.links.medium))
            } else {
                self.socialLink.append(SocialLink(socialLinkType: .medium, value: "N/A"))
            }
            
            if !self.pageInfo.links.website.isEmpty {
                self.socialLink.append(SocialLink(socialLinkType: .website, value: self.pageInfo.links.website))
            } else {
                self.socialLink.append(SocialLink(socialLinkType: .website, value: "N/A"))
            }
        }
    }
}
