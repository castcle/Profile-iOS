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
//  ComplateTableViewCell.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 16/9/2564 BE.
//

import UIKit
import Core

protocol ComplateTableViewCellDelegate {
    func didDone(_ complateTableViewCell: ComplateTableViewCell, skip: Bool)
}

class ComplateTableViewCell: UITableViewCell {

    @IBOutlet var complateButton: UIButton!
    
    var delegate: ComplateTableViewCellDelegate?
    var isSkip: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.complateButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .h4)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configCell(isSkip: Bool) {
        self.isSkip = isSkip
        if isSkip {
            self.complateButton.setTitle(Localization.updateInfo.skip.text, for: .normal)
            self.complateButton.setTitleColor(UIColor.Asset.lightBlue, for: .normal)
            self.complateButton.capsule(color: UIColor.Asset.darkGraphiteBlue, borderWidth: 1, borderColor: UIColor.Asset.lightBlue)
        } else {
            self.complateButton.setTitle(Localization.updateInfo.done.text, for: .normal)
            self.complateButton.setTitleColor(UIColor.Asset.white, for: .normal)
            self.complateButton.capsule(color: UIColor.Asset.lightBlue, borderWidth: 1, borderColor: UIColor.Asset.lightBlue)
        }
    }
    
    @IBAction func complateAction(_ sender: Any) {
        if self.isSkip {
            self.delegate?.didDone(self, skip: true)
        } else {
            self.delegate?.didDone(self, skip: false)
        }
    }
}
