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
//  PageSyncSocialTableViewCell.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 9/3/2565 BE.
//

import UIKit
import Networking
import Kingfisher

class PageSyncSocialTableViewCell: UITableViewCell {

    @IBOutlet var socialAvatarImage: UIImageView!
    @IBOutlet var castcleAvatarImage: UIImageView!
    @IBOutlet var socialNameLabel: UILabel!
    @IBOutlet var socialIdLabel: UILabel!
    @IBOutlet var castcleNameLabel: UILabel!
    @IBOutlet var castcleIdLabel: UILabel!
    @IBOutlet var sicialIconView: UIView!
    @IBOutlet var socialIcon: UIImageView!
    @IBOutlet var castcleIconView: UIView!
    @IBOutlet var castcleIcon: UIImageView!
    @IBOutlet var connectIcon: UIImageView!
    
    var userInfo: UserInfo = UserInfo()
    
    private var icon: UIImage {
        switch self.userInfo.syncSocial.provider {
        case "facebook":
            return UIImage.init(icon: .castcle(.facebook), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
        case "twitter":
            return UIImage.init(icon: .castcle(.twitter), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
        case "google":
            return UIImage.Asset.googleLogo
        case "apple":
            return UIImage.init(icon: .castcle(.apple), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
        default:
            return UIImage()
        }
    }
    
    private var color: UIColor {
        switch self.userInfo.syncSocial.provider {
        case "facebook":
            return UIColor.Asset.facebook
        case "twitter":
            return UIColor.Asset.twitter
        case "google":
            return UIColor.Asset.white
        case "apple":
            return UIColor.Asset.apple
        default:
            return UIColor.clear
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.socialNameLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.socialNameLabel.textColor = UIColor.Asset.white
        self.socialIdLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.socialIdLabel.textColor = UIColor.Asset.lightGray
        self.castcleNameLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.castcleNameLabel.textColor = UIColor.Asset.white
        self.castcleIdLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.castcleIdLabel.textColor = UIColor.Asset.lightGray
        
        self.socialAvatarImage.circle(color: UIColor.Asset.white)
        self.socialAvatarImage.image = UIImage.Asset.userPlaceholder
        self.castcleAvatarImage.circle(color: UIColor.Asset.white)
        self.castcleAvatarImage.image = UIImage.Asset.userPlaceholder
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configCell(userInfo: UserInfo) {
        self.userInfo = userInfo
        
        self.sicialIconView.capsule(color: self.color, borderWidth: 2, borderColor: UIColor.Asset.black)
        self.castcleIconView.capsule(color: UIColor.Asset.black, borderWidth: 2, borderColor: UIColor.Asset.black)
        self.socialIcon.image = self.icon
        self.castcleIcon.image = UIImage.init(icon: .castcle(.logo), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
        self.connectIcon.image = UIImage.init(icon: .castcle(.bindLink), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
        
        let castcleAvatarUrl = URL(string: self.userInfo.images.avatar.thumbnail)
        self.castcleAvatarImage.kf.setImage(with: castcleAvatarUrl, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
        self.castcleNameLabel.text = self.userInfo.displayName
        self.castcleIdLabel.text = "@\(self.userInfo.castcleId)"
        
        let socialAvatarUrl = URL(string: self.userInfo.syncSocial.avatar)
        self.socialAvatarImage.kf.setImage(with: socialAvatarUrl, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
        self.socialNameLabel.text = self.userInfo.syncSocial.displayName
        self.socialIdLabel.text = self.userInfo.syncSocial.userName.isEmpty ? "" : "@\(self.userInfo.syncSocial.userName)"
    }
}
