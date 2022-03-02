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
//  Created by Castcle Co., Ltd. on 5/8/2564 BE.
//

public struct ProfileNibVars {
    // MARK: - View Controller
    public struct ViewController {
        public static let welcome = "WelcomeEditProfileViewController"
        public static let photoMethod = "SelectPhotoMethodViewController"
        public static let about = "AboutInfoViewController"
        public static let addLink = "AddSocialViewController"
        public static let userInfo = "UserInfoViewController"
        public static let editInfo = "EditInfoViewController"
        public static let action = "ProfileActionViewController"
        public static let welcomeCreatePage = "WelcomeCreatePageViewController"
        public static let createPage = "PageDisplayNameViewController"
        public static let deletePage = "DeletePageViewController"
        public static let confirmDeletePage = "ConfirmDeletePageViewController"
        public static let deletePageSuccess = "DeletePageSuccessViewController"
        public static let profile = "ProfileViewController"
        public static let newPageWithSocial = "NewPageWithSocialViewController"
        public static let userFollow = "UserFollowViewController"
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
        public static let editInfo = "EditInfoTableViewCell"
        public static let editPageInfo = "EditPageInfoTableViewCell"
        public static let about = "AboutTableViewCell"
        public static let dob = "DobTableViewCell"
        public static let addLink = "AddLinkTableViewCell"
        public static let social = "SocialTableViewCell"
        public static let complate = "ComplateTableViewCell"
        public static let confirmDeletePage = "ConfirmDeletePageTableViewCell"
        public static let profileHeader = "ProfileHeaderTableViewCell"
        public static let feedHeader = "FeedHeaderTableViewCell"
        public static let profileHeaderSkeleton = "ProfileHeaderSkeletonTableViewCell"
        public static let profilePost = "ProfilePostTableViewCell"
        public static let newPageWithSocial = "NewPageWithSocialTableViewCell"
        public static let blockedUser = "BlockedUserTableViewCell"
        public static let headerBlocked = "HeaderBlockedTableViewCell"
    }
    
    // MARK: - CollectionViewCell
    public struct CollectionViewCell {
        public static let addSocial = "AddSocialCell"
        public static let pageDisplayName = "CreatePageDisplayNameCell"
    }
}
