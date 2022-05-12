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
//  ProfileOpener.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 5/8/2564 BE.
//

import UIKit
import Core
import Networking
import Defaults

public enum ProfileScene {
    case photoMethod(SelectPhotoMethodViewModel)
    case about(AboutInfoViewModel)
    case addLink
    case userInfo(UserInfoViewModel)
    case editInfo(ProfileType, UserInfo)
    case action
    case updateUserImage
    case updateUserInfo
    case welcomeCreatePage
    case createPage
    case deletePage(DeletePageViewModel)
    case confirmDeletePage(DeletePageViewModel)
    case deletePageSuccess
    case profile(ProfileViewModel, ProfileFeedViewModel)
    case newPageWithSocial
    case userFollow(UserFollowViewModel)
    case pageSyncSocial(PageSyncSocialViewModel)
    case syncSocialMedia(SyncSocialMediaViewModel)
    case facebookPageList([FacebookPage])
    case contactEmail(EditInfoViewModel)
    case contactPhone(EditInfoViewModel)
}

public struct ProfileOpener {
    public static func open(_ profileScene: ProfileScene) -> UIViewController {
        switch profileScene {
        case .photoMethod(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: ProfileNibVars.Storyboard.profile, bundle: ConfigBundle.profile)
            let viewController = storyboard.instantiateViewController(withIdentifier: ProfileNibVars.ViewController.photoMethod) as? SelectPhotoMethodViewController
            viewController?.viewModel = viewModel
            return viewController ?? SelectPhotoMethodViewController()
        case .about(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: ProfileNibVars.Storyboard.profile, bundle: ConfigBundle.profile)
            let viewController = storyboard.instantiateViewController(withIdentifier: ProfileNibVars.ViewController.about) as? AboutInfoViewController
            viewController?.viewModel = viewModel
            return viewController ?? AboutInfoViewController()
        case .addLink:
            let storyboard: UIStoryboard = UIStoryboard(name: ProfileNibVars.Storyboard.profile, bundle: ConfigBundle.profile)
            let viewController = storyboard.instantiateViewController(withIdentifier: ProfileNibVars.ViewController.addLink)
            return viewController
        case .userInfo(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: ProfileNibVars.Storyboard.mine, bundle: ConfigBundle.profile)
            let viewController = storyboard.instantiateViewController(withIdentifier: ProfileNibVars.ViewController.userInfo) as? UserInfoViewController
            viewController?.viewModel = viewModel
            return viewController ?? UserInfoViewController()
        case .editInfo(let profileType, let userInfo):
            let storyboard: UIStoryboard = UIStoryboard(name: ProfileNibVars.Storyboard.mine, bundle: ConfigBundle.profile)
            let viewController = storyboard.instantiateViewController(withIdentifier: ProfileNibVars.ViewController.editInfo) as? EditInfoViewController
            viewController?.viewModel = EditInfoViewModel(profileType: profileType, userInfo: userInfo)
            return viewController ?? EditInfoViewController()
        case .action:
            let storyboard: UIStoryboard = UIStoryboard(name: ProfileNibVars.Storyboard.mine, bundle: ConfigBundle.profile)
            let viewController = storyboard.instantiateViewController(withIdentifier: ProfileNibVars.ViewController.action)
            return viewController
        case .updateUserImage:
            let storyboard: UIStoryboard = UIStoryboard(name: ProfileNibVars.Storyboard.profile, bundle: ConfigBundle.profile)
            let viewController = storyboard.instantiateViewController(withIdentifier: ProfileNibVars.ViewController.updateUserImage)
            return viewController
        case .updateUserInfo:
            let storyboard: UIStoryboard = UIStoryboard(name: ProfileNibVars.Storyboard.profile, bundle: ConfigBundle.profile)
            let viewController = storyboard.instantiateViewController(withIdentifier: ProfileNibVars.ViewController.updateUserInfo)
            return viewController
        case .welcomeCreatePage:
            let storyboard: UIStoryboard = UIStoryboard(name: ProfileNibVars.Storyboard.profile, bundle: ConfigBundle.profile)
            let viewController = storyboard.instantiateViewController(withIdentifier: ProfileNibVars.ViewController.welcomeCreatePage)
            return viewController
        case .createPage:
            let storyboard: UIStoryboard = UIStoryboard(name: ProfileNibVars.Storyboard.profile, bundle: ConfigBundle.profile)
            let viewController = storyboard.instantiateViewController(withIdentifier: ProfileNibVars.ViewController.createPage)
            return viewController
        case .deletePage(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: ProfileNibVars.Storyboard.profile, bundle: ConfigBundle.profile)
            let viewController = storyboard.instantiateViewController(withIdentifier: ProfileNibVars.ViewController.deletePage) as? DeletePageViewController
            viewController?.viewModel = viewModel
            return viewController ?? DeletePageViewController()
        case .confirmDeletePage(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: ProfileNibVars.Storyboard.profile, bundle: ConfigBundle.profile)
            let viewController = storyboard.instantiateViewController(withIdentifier: ProfileNibVars.ViewController.confirmDeletePage) as? ConfirmDeletePageViewController
            viewController?.viewModel = viewModel
            return viewController ?? ConfirmDeletePageViewController()
        case .deletePageSuccess:
            let storyboard: UIStoryboard = UIStoryboard(name: ProfileNibVars.Storyboard.profile, bundle: ConfigBundle.profile)
            let viewController = storyboard.instantiateViewController(withIdentifier: ProfileNibVars.ViewController.deletePageSuccess)
            return viewController
        case .profile(let profileViewModel, let profileFeedViewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: ProfileNibVars.Storyboard.mine, bundle: ConfigBundle.profile)
            let viewController = storyboard.instantiateViewController(withIdentifier: ProfileNibVars.ViewController.profile) as? ProfileViewController
            viewController?.profileViewModel = profileViewModel
            viewController?.profileFeedViewModel = profileFeedViewModel
            return viewController ?? ProfileViewController()
        case .newPageWithSocial:
            let storyboard: UIStoryboard = UIStoryboard(name: ProfileNibVars.Storyboard.profile, bundle: ConfigBundle.profile)
            let viewController = storyboard.instantiateViewController(withIdentifier: ProfileNibVars.ViewController.newPageWithSocial) as? NewPageWithSocialViewController
            return viewController ?? NewPageWithSocialViewController()
        case .userFollow(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: ProfileNibVars.Storyboard.profile, bundle: ConfigBundle.profile)
            let viewController = storyboard.instantiateViewController(withIdentifier: ProfileNibVars.ViewController.userFollow) as? UserFollowViewController
            viewController?.viewModel = viewModel
            return viewController ?? UserFollowViewController()
        case .pageSyncSocial(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: ProfileNibVars.Storyboard.profile, bundle: ConfigBundle.profile)
            let viewController = storyboard.instantiateViewController(withIdentifier: ProfileNibVars.ViewController.pageSyncSocial) as? PageSyncSocialViewController
            viewController?.viewModel = viewModel
            return viewController ?? PageSyncSocialViewController()
        case .syncSocialMedia(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: ProfileNibVars.Storyboard.profile, bundle: ConfigBundle.profile)
            let viewController = storyboard.instantiateViewController(withIdentifier: ProfileNibVars.ViewController.syncSocialMedia) as? SyncSocialMediaViewController
            viewController?.viewModel = viewModel
            return viewController ?? SyncSocialMediaViewController()
        case .facebookPageList(let facebookPage):
            let storyboard: UIStoryboard = UIStoryboard(name: ProfileNibVars.Storyboard.profile, bundle: ConfigBundle.profile)
            let viewController = storyboard.instantiateViewController(withIdentifier: ProfileNibVars.ViewController.facebookPageList) as? FacebookPageListViewController
            viewController?.facebookPage = facebookPage
            return viewController ?? FacebookPageListViewController()
        case .contactEmail(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: ProfileNibVars.Storyboard.profile, bundle: ConfigBundle.profile)
            let viewController = storyboard.instantiateViewController(withIdentifier: ProfileNibVars.ViewController.contactEmail) as? ContactEmailViewController
            viewController?.viewModel = viewModel
            return viewController ?? ContactEmailViewController()
        case .contactPhone(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: ProfileNibVars.Storyboard.profile, bundle: ConfigBundle.profile)
            let viewController = storyboard.instantiateViewController(withIdentifier: ProfileNibVars.ViewController.contactPhone) as? ContactPhoneViewController
            viewController?.viewModel = viewModel
            return viewController ?? ContactPhoneViewController()
        }
    }

    public static func openProfileDetail(_ castcleId: String, displayName: String) {
        if castcleId == UserManager.shared.rawCastcleId {
            Utility.currentViewController().navigationController?.pushViewController(self.open(.profile(ProfileViewModel(profileType: .mine, castcleId: castcleId, displayName: ""), ProfileFeedViewModel(profileContentType: .all, profileType: .mine, castcleId: ""))), animated: true)
        } else {
            Utility.currentViewController().navigationController?.pushViewController(self.open(.profile(ProfileViewModel(profileType: .user, castcleId: castcleId, displayName: displayName), ProfileFeedViewModel(profileContentType: .all, profileType: .user, castcleId: castcleId))), animated: true)
        }
    }
}
