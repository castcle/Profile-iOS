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
//  ProfilePostTableViewCell.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 6/1/2565 BE.
//

import UIKit
import Core
import Networking
import Component

class ProfilePostTableViewCell: UITableViewCell {

    @IBOutlet var lineView: UIView!
    @IBOutlet var newPostView: UIView!
    @IBOutlet var searchView: UIView!
    @IBOutlet var miniProfileImage: UIImageView!
    @IBOutlet var placeholderLabel: UILabel!

    var profileType: ProfileType = .unknow
    var userInfo: UserInfo = UserInfo()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.lineView.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.newPostView.backgroundColor = UIColor.Asset.cellBackground
        self.searchView.custom(color: UIColor.Asset.cellBackground, cornerRadius: 18, borderWidth: 1, borderColor: UIColor.Asset.darkGraphiteBlue)
        self.miniProfileImage.circle(color: UIColor.Asset.darkGraphiteBlue)
        self.placeholderLabel.font = UIFont.asset(.light, fontSize: .overline)
        self.placeholderLabel.textColor = UIColor.Asset.lightGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configCell(profileType: ProfileType, userInfo: UserInfo) {
        self.profileType = profileType
        self.userInfo = userInfo
        if self.profileType == .mine {
            let urlProfile = URL(string: UserManager.shared.avatar)
            self.miniProfileImage.kf.setImage(with: urlProfile, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
        } else {
            let urlProfile = URL(string: self.userInfo.images.avatar.thumbnail)
            self.miniProfileImage.kf.setImage(with: urlProfile, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
        }
    }

    @IBAction func postAction(_ sender: Any) {
        if self.profileType == .mine {
            let viewController = PostOpener.open(.post(PostViewModel(postType: .newCast)))
            viewController.modalPresentationStyle = .fullScreen
            Utility.currentViewController().present(viewController, animated: true, completion: nil)
        } else {
            let viewController = PostOpener.open(.post(PostViewModel(postType: .newCast, page: Page().initCustom(id: self.userInfo.id, displayName: self.userInfo.displayName, castcleId: self.userInfo.castcleId, avatar: self.userInfo.images.avatar.thumbnail, cover: self.userInfo.images.cover.fullHd, overview: self.userInfo.overview, official: self.userInfo.verified.official))))
            viewController.modalPresentationStyle = .fullScreen
            Utility.currentViewController().present(viewController, animated: true, completion: nil)
        }
    }
}
