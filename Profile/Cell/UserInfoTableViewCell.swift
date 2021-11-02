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
//  UserInfoTableViewCell.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 8/8/2564 BE.
//

import UIKit
import Kingfisher

class UserInfoTableViewCell: UITableViewCell {

    @IBOutlet var coverImage: UIImageView!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var displayNameLabel: UILabel!
    @IBOutlet var userIdLabel: UILabel!
    @IBOutlet var bioTitleLabel: UILabel!
    @IBOutlet var bioLabel: UILabel!
    @IBOutlet var birthdayTitleLabel: UILabel!
    @IBOutlet var birthdayLabel: UILabel!
    @IBOutlet var linkTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let urlCover = URL(string: "https://cdn.pixabay.com/photo/2021/07/13/18/58/coffee-6464307_1280.jpg")
        self.coverImage.kf.setImage(with: urlCover, placeholder: UIImage.Asset.placeholder, options: [.transition(.fade(0.35))])
        
        let urlProfile = URL(string: "https://static.wikia.nocookie.net/whywomenkill/images/e/e7/Alexandra_Daddario.jpg")
        self.profileImage.kf.setImage(with: urlProfile, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
        
        self.displayNameLabel.text = "Alexandra Daddario"
        self.userIdLabel.text = "@alexandra-daddario"
        
        self.displayNameLabel.font = UIFont.asset(.regular, fontSize: .h4)
        self.displayNameLabel.textColor = UIColor.Asset.white
        self.userIdLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.userIdLabel.textColor = UIColor.Asset.white
        
        self.bioTitleLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.bioTitleLabel.textColor = UIColor.Asset.lightBlue
        self.bioLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.bioLabel.textColor = UIColor.Asset.white
        
        self.birthdayTitleLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.birthdayTitleLabel.textColor = UIColor.Asset.lightBlue
        self.birthdayLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.birthdayLabel.textColor = UIColor.Asset.white
        
        self.linkTitleLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.linkTitleLabel.textColor = UIColor.Asset.lightBlue
        
        self.profileImage.circle(color: UIColor.Asset.white)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
