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
import Post
import Networking

class ProfilePostTableViewCell: UITableViewCell {

    @IBOutlet var lineView: UIView!
    @IBOutlet var newPostView: UIView!
    @IBOutlet var searchView: UIView!
    @IBOutlet var miniProfileImage: UIImageView!
    @IBOutlet var placeholderLabel: UILabel!
    
    var profileType: ProfileType = .unknow
    var pageInfo: PageInfo = PageInfo()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lineView.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.newPostView.backgroundColor = UIColor.Asset.darkGray
        self.searchView.custom(color: UIColor.Asset.darkGray, cornerRadius: 18, borderWidth: 1, borderColor: UIColor.Asset.darkGraphiteBlue)
        self.miniProfileImage.circle(color: UIColor.Asset.darkGraphiteBlue)
        self.placeholderLabel.font = UIFont.asset(.light, fontSize: .overline)
        self.placeholderLabel.textColor = UIColor.Asset.lightGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configCell(profileType: ProfileType, pageInfo: PageInfo) {
        self.profileType = profileType
        self.pageInfo = pageInfo
        
        if self.profileType == .me {
            let urlProfile = URL(string: UserManager.shared.avatar)
            self.miniProfileImage.kf.setImage(with: urlProfile, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
        } else if self.profileType == .myPage {
            let urlProfile = URL(string: self.pageInfo.images.avatar.thumbnail)
            self.miniProfileImage.kf.setImage(with: urlProfile, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
        }
    }
    
    @IBAction func postAction(_ sender: Any) {
        if self.profileType == .me {
            let vc = PostOpener.open(.post(PostViewModel(postType: .newCast)))
            vc.modalPresentationStyle = .fullScreen
            Utility.currentViewController().present(vc, animated: true, completion: nil)
        } else if self.profileType == .myPage {
            let vc = PostOpener.open(.post(PostViewModel(postType: .newCast, page: Page().initCustom(id: self.pageInfo.id, displayName: self.pageInfo.displayName, castcleId: self.pageInfo.castcleId, avatar: self.pageInfo.images.avatar.thumbnail, cover: self.pageInfo.images.cover.fullHd, overview: self.pageInfo.overview, official: self.pageInfo.verified.official))))
            vc.modalPresentationStyle = .fullScreen
            Utility.currentViewController().present(vc, animated: true, completion: nil)
        }
    }
}
