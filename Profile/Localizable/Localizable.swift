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
//  Localizable.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 7/1/2565 BE.
//

import Core

extension Localization {
    
    // MARK: - Create Page
    public enum createPage {
        case title
        case headline
        case button
        
        public var text: String {
            switch self {
            case .title:
                return "create_page_title".localized(bundle: ConfigBundle.profile)
            case .headline:
                return "create_page_headline".localized(bundle: ConfigBundle.profile)
            case .button:
                return "create_page_button".localized(bundle: ConfigBundle.profile)
            }
        }
    }

    // MARK: - Create Page Display Name
    public enum createPageName {
        case headline
        case description
        case displayName
        case button
        
        public var text: String {
            switch self {
            case .headline:
                return "create_page_name_headline".localized(bundle: ConfigBundle.profile)
            case .description:
                return "create_page_name_description".localized(bundle: ConfigBundle.profile)
            case .displayName:
                return "create_page_name_display_name".localized(bundle: ConfigBundle.profile)
            case .button:
                return "create_page_name_button".localized(bundle: ConfigBundle.profile)
            }
        }
    }

    // MARK: - Choose Profile Image
    public enum chooseProfileImage {
        case skip
        case headline
        case description
        case cameraRoll
        case takePhoto
        
        public var text: String {
            switch self {
            case .skip:
                return "choose_profile_image_skip".localized(bundle: ConfigBundle.profile)
            case .headline:
                return "choose_profile_image_headline".localized(bundle: ConfigBundle.profile)
            case .description:
                return "choose_profile_image_description".localized(bundle: ConfigBundle.profile)
            case .cameraRoll:
                return "choose_profile_image_camera_roll".localized(bundle: ConfigBundle.profile)
            case .takePhoto:
                return "choose_profile_image_take_photo".localized(bundle: ConfigBundle.profile)
            }
        }
    }

    // MARK: - Update info
    public enum updateInfo {
        case headline
        case overview
        case overviewPlaceholder
        case links
        case addSocial
        case skip
        case done
        case birthday
        case date
        
        public var text: String {
            switch self {
            case .headline:
                return "update_info_headline".localized(bundle: ConfigBundle.profile)
            case .overview:
                return "update_info_overview".localized(bundle: ConfigBundle.profile)
            case .overviewPlaceholder:
                return "update_info_overview_placeholder".localized(bundle: ConfigBundle.profile)
            case .links:
                return "update_info_links".localized(bundle: ConfigBundle.profile)
            case .addSocial:
                return "update_info_add_social".localized(bundle: ConfigBundle.profile)
            case .skip:
                return "update_info_skip".localized(bundle: ConfigBundle.profile)
            case .done:
                return "update_info_done".localized(bundle: ConfigBundle.profile)
            case .birthday:
                return "update_info_birthday".localized(bundle: ConfigBundle.profile)
            case .date:
                return "update_info_date".localized(bundle: ConfigBundle.profile)
            }
        }
    }

    // MARK: - Add Social
    public enum addSocial {
        case title
        case apply
        case description
        case facebook
        case twitter
        case youtube
        case medium
        case website
        
        public var text: String {
            switch self {
            case .title:
                return "add_social_title".localized(bundle: ConfigBundle.profile)
            case .apply:
                return "add_social_apply".localized(bundle: ConfigBundle.profile)
            case .description:
                return "add_social_description".localized(bundle: ConfigBundle.profile)
            case .facebook:
                return "add_social_facebook".localized(bundle: ConfigBundle.profile)
            case .twitter:
                return "add_social_twitter".localized(bundle: ConfigBundle.profile)
            case .youtube:
                return "add_social_youtube".localized(bundle: ConfigBundle.profile)
            case .medium:
                return "add_social_medium".localized(bundle: ConfigBundle.profile)
            case .website:
                return "add_social_website".localized(bundle: ConfigBundle.profile)
            }
        }
    }
}
