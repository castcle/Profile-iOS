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
//  SocialLinkTableViewCell.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 8/8/2564 BE.
//

import UIKit
import Core

class SocialLinkTableViewCell: UITableViewCell {

    @IBOutlet var socialView: UIView!
    @IBOutlet var socialIcon: UIImageView!
    @IBOutlet var valueLabel: UILabel!
    
    var socialLink: SocialLink? {
        didSet {
            guard let social = self.socialLink else { return }
            switch social.socialLinkType {
            case .facebook:
                self.socialIcon.image = UIImage.init(icon: .castcle(.facebook), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
            case .twitter:
                self.socialIcon.image = UIImage.init(icon: .castcle(.twitter), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
            case .youtube:
                self.socialIcon.image = UIImage.init(icon: .castcle(.youtube), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
            default:
                self.socialIcon.image = UIImage.init(icon: .castcle(.link), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
            }
            
            self.valueLabel.text = social.value
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.socialView.custom(color: UIColor.Asset.darkGray, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.valueLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.valueLabel.textColor = UIColor.Asset.lightBlue
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
