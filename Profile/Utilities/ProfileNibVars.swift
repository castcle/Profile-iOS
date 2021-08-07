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
//  ProfileNibVars.swift
//  Profile
//
//  Created by Tanakorn Phoochaliaw on 5/8/2564 BE.
//

public struct ProfileNibVars {
    // MARK: - View Controller
    public struct ViewController {
        public static let welcome = "WelcomeEditProfileViewController"
        public static let photoMethod = "SelectPhotoMethodViewController"
        public static let about = "AboutInfoViewController"
        public static let addLink = "AddSocialViewController"
        public static let me = "MeViewController"
        public static let userInfo = "UserInfoViewController"
    }
    
    // MARK: - View
    public struct Storyboard {
        public static let profile = "Profile"
        public static let me = "Me"
    }
    
    // MARK: - TableViewCell
    public struct TableViewCell {
        public static let meInfo = "UserInfoTableViewCell"
        public static let socialLink = "SocialLinkTableViewCell"
    }
    
    // MARK: - CollectionViewCell
    public struct CollectionViewCell {
        public static let about = "AboutCell"
        public static let addLink = "AddLinkCell"
        public static let addSocial = "AddSocialCell"
        public static let social = "SocialCell"
        public static let complateButton = "ComplateButtonCell"
        public static let meInfo = "MeInfoCell"
    }
}
