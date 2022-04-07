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
//  SocialAccountTableViewCell.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 9/2/2565 BE.
//

import UIKit
import Core
import Networking

class SocialAccountTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var displayLabel: UILabel!
    @IBOutlet var nextImage: UIImageView!
    @IBOutlet var socialView: UIView!
    @IBOutlet var socialImage: UIImageView!
    
    private var userInfo: UserInfo = UserInfo()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.titleLabel.textColor = UIColor.Asset.white
        self.displayLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.displayLabel.textColor = UIColor.Asset.gray
        self.nextImage.image = UIImage.init(icon: .castcle(.next), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configCell(socialType: SocialType, userInfo: UserInfo) {
        self.userInfo = userInfo
        self.titleLabel.text = socialType.display
        if socialType == .facebook {
            self.socialView.capsule(color: UIColor.Asset.facebook)
            self.socialImage.image = UIImage.init(icon: .castcle(.facebook), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
        } else if socialType == .twitter {
            self.socialView.capsule(color: UIColor.Asset.twitter)
            self.socialImage.image = UIImage.init(icon: .castcle(.twitter), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
        } else {
            self.socialView.capsule(color: .clear)
            self.socialImage.image = UIImage()
        }
        
//        if socialUser.socialId.isEmpty {
            self.displayLabel.text = ""
//            self.displayLabel.textColor = UIColor.Asset.gray
//            self.nextImage.isHidden = false
//        } else {
//            self.displayLabel.text = "Linked"
//            self.displayLabel.textColor = UIColor.Asset.lightBlue
//            self.nextImage.isHidden = true
//        }
    }
    
//    private func isSyncProvider(socialType: SocialType) -> Bool {
//        if socialType == .facebook {
//            for i in 0..<self.userInfo.syncSocial
//        } else if socialType == .twitter {
//            
//        } else {
//            return false
//        }
//    }
    
}
