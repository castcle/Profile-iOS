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
//  AddLinkCell.swift
//  Profile
//
//  Created by Tanakorn Phoochaliaw on 6/8/2564 BE.
//

import UIKit
import Core

class AddLinkCell: UICollectionViewCell {

    @IBOutlet var linkLabel: UILabel!
    @IBOutlet var addSocialButton: UIButton!
    @IBOutlet var addSocialView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addSocialView.custom(color: UIColor.Asset.darkGray, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.addSocialButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .body)
        self.addSocialButton.setTitleColor(UIColor.Asset.lightBlue, for: .normal)
        self.linkLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.linkLabel.textColor = UIColor.Asset.white
    }
    
    static func cellSize(width: CGFloat) -> CGSize {
        return CGSize(width: width, height: 100)
    }
    
    @IBAction func addSocialAction(_ sender: Any) {
        Utility.currentViewController().navigationController?.pushViewController(ProfileOpener.open(.addLink), animated: true)
    }
}
