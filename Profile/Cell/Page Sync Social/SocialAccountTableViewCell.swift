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

    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.titleLabel.textColor = UIColor.Asset.white
        self.displayLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.displayLabel.textColor = UIColor.Asset.lightBlue
        self.nextImage.image = UIImage.init(icon: .castcle(.next), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configCell(socialType: SocialType, isSync: Bool) {
        self.titleLabel.text = socialType.display
        self.socialView.capsule(color: socialType.color)
        self.socialImage.image = socialType.icon
        if isSync {
            self.displayLabel.text = "Synced"
        } else {
            self.displayLabel.text = ""
        }
    }
}
