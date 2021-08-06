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
import Defaults

final class AboutInfoViewModel  {
   
    //MARK: Private
    var socialLinkShelf: SocialLinkShelf = SocialLinkShelf()

    //MARK: Input
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
    
    //MARK: Output
    var didMappingFinish: (() -> ())?
}
