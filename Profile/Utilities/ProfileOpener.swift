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
import RealmSwift

public enum ProfileScene {
    case welcome
    case photoMethod(SelectPhotoMethodViewModel)
    case about(AboutInfoViewModel)
    case addLink
    case userInfo(UserInfoViewModel)
    case editInfo(ProfileType, PageInfo)
    case action
    case userDetail(UserDetailViewModel)
    case meHeader(MeHeaderViewModel)
    case infoTab
    case userFeed(UserFeedViewModel)
    case welcomeCreatePage
    case createPage
    case deletePage(DeletePageViewModel)
    case confirmDeletePage(DeletePageViewModel)
    case deletePageSuccess
}

public struct ProfileOpener {
    public static func open(_ profileScene: ProfileScene) -> UIViewController {
        switch profileScene {
        case .welcome:
            let storyboard: UIStoryboard = UIStoryboard(name: ProfileNibVars.Storyboard.profile, bundle: ConfigBundle.profile)
            let vc = storyboard.instantiateViewController(withIdentifier: ProfileNibVars.ViewController.welcome)
            return vc
        case .photoMethod(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: ProfileNibVars.Storyboard.profile, bundle: ConfigBundle.profile)
            let vc = storyboard.instantiateViewController(withIdentifier: ProfileNibVars.ViewController.photoMethod) as? SelectPhotoMethodViewController
            vc?.viewModel = viewModel
            return vc ?? SelectPhotoMethodViewController()
        case .about(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: ProfileNibVars.Storyboard.profile, bundle: ConfigBundle.profile)
            let vc = storyboard.instantiateViewController(withIdentifier: ProfileNibVars.ViewController.about) as? AboutInfoViewController
            vc?.viewModel = viewModel
            return vc ?? AboutInfoViewController()
        case .addLink:
            let storyboard: UIStoryboard = UIStoryboard(name: ProfileNibVars.Storyboard.profile, bundle: ConfigBundle.profile)
            let vc = storyboard.instantiateViewController(withIdentifier: ProfileNibVars.ViewController.addLink)
            return vc
        case .userInfo(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: ProfileNibVars.Storyboard.me, bundle: ConfigBundle.profile)
            let vc = storyboard.instantiateViewController(withIdentifier: ProfileNibVars.ViewController.userInfo) as? UserInfoViewController
            vc?.viewModel = viewModel
            return vc ?? UserInfoViewController()
        case .editInfo(let profileType, let pageInfo):
            let storyboard: UIStoryboard = UIStoryboard(name: ProfileNibVars.Storyboard.me, bundle: ConfigBundle.profile)
            let vc = storyboard.instantiateViewController(withIdentifier: ProfileNibVars.ViewController.editInfo) as? EditInfoViewController
            vc?.profileType = profileType
            vc?.pageInfo = pageInfo
            return vc ?? EditInfoViewController()
        case .action:
            let storyboard: UIStoryboard = UIStoryboard(name: ProfileNibVars.Storyboard.me, bundle: ConfigBundle.profile)
            let vc = storyboard.instantiateViewController(withIdentifier: ProfileNibVars.ViewController.action)
            return vc
        case .userDetail(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: ProfileNibVars.Storyboard.me, bundle: ConfigBundle.profile)
            let vc = storyboard.instantiateViewController(withIdentifier: ProfileNibVars.ViewController.userDetail) as? UserDetailViewController
            vc?.viewModel = viewModel
            return vc ?? UserDetailViewController()
        case .meHeader(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: ProfileNibVars.Storyboard.me, bundle: ConfigBundle.profile)
            let vc = storyboard.instantiateViewController(withIdentifier: ProfileNibVars.ViewController.meHeader) as? MeHeaderViewController
            vc?.viewModel = viewModel
            return vc ?? MeHeaderViewController()
        case .infoTab:
            let storyboard: UIStoryboard = UIStoryboard(name: ProfileNibVars.Storyboard.me, bundle: ConfigBundle.profile)
            let vc = storyboard.instantiateViewController(withIdentifier: ProfileNibVars.ViewController.infoTab)
            return vc
        case .userFeed(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: ProfileNibVars.Storyboard.me, bundle: ConfigBundle.profile)
            let vc = storyboard.instantiateViewController(withIdentifier: ProfileNibVars.ViewController.userFeed) as? UserFeedViewController
            vc?.viewModel = viewModel
            return vc ?? UserFeedViewController()
        case .welcomeCreatePage:
            let storyboard: UIStoryboard = UIStoryboard(name: ProfileNibVars.Storyboard.profile, bundle: ConfigBundle.profile)
            let vc = storyboard.instantiateViewController(withIdentifier: ProfileNibVars.ViewController.welcomeCreatePage)
            return vc
        case .createPage:
            let storyboard: UIStoryboard = UIStoryboard(name: ProfileNibVars.Storyboard.profile, bundle: ConfigBundle.profile)
            let vc = storyboard.instantiateViewController(withIdentifier: ProfileNibVars.ViewController.createPage)
            return vc
        case .deletePage(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: ProfileNibVars.Storyboard.profile, bundle: ConfigBundle.profile)
            let vc = storyboard.instantiateViewController(withIdentifier: ProfileNibVars.ViewController.deletePage) as? DeletePageViewController
            vc?.viewModel = viewModel
            return vc ?? DeletePageViewController()
        case .confirmDeletePage(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: ProfileNibVars.Storyboard.profile, bundle: ConfigBundle.profile)
            let vc = storyboard.instantiateViewController(withIdentifier: ProfileNibVars.ViewController.confirmDeletePage) as? ConfirmDeletePageViewController
            vc?.viewModel = viewModel
            return vc ?? ConfirmDeletePageViewController()
        case .deletePageSuccess:
            let storyboard: UIStoryboard = UIStoryboard(name: ProfileNibVars.Storyboard.profile, bundle: ConfigBundle.profile)
            let vc = storyboard.instantiateViewController(withIdentifier: ProfileNibVars.ViewController.deletePageSuccess)
            return vc
        }
    }
    
    public static func openProfileDetail(_ type: AuthorType, castcleId: String?, displayName: String, page: Page?) {
        if type == .people {
            guard let id = castcleId else { return }
            if id == UserManager.shared.rawCastcleId {
                Utility.currentViewController().navigationController?.pushViewController(self.open(.userDetail(UserDetailViewModel(profileType: .me, castcleId: nil, displayName: "", page: nil))), animated: true)
            } else {
                Utility.currentViewController().navigationController?.pushViewController(self.open(.userDetail(UserDetailViewModel(profileType: .people, castcleId: castcleId, displayName: displayName, page: nil))), animated: true)
            }
        } else {
            guard let page = page else { return }
            let realm = try! Realm()
            if realm.objects(Page.self).filter("castcleId = '\(page.castcleId)'").first != nil {
                Utility.currentViewController().navigationController?.pushViewController(self.open(.userDetail(UserDetailViewModel(profileType: .myPage, castcleId: nil, displayName: "", page: page))), animated: true)
            } else {
                Utility.currentViewController().navigationController?.pushViewController(self.open(.userDetail(UserDetailViewModel(profileType: .page, castcleId: nil, displayName: "", page: page))), animated: true)
            }
        }
    }
}
