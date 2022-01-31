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
//  BlockedUserTableViewCell.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 28/1/2565 BE.
//

import UIKit
import Core
import ActiveLabel

protocol BlockedUserTableViewCellDelegate {
    func didUnblocked(_ blockedUserTableViewCell: BlockedUserTableViewCell)
}

class BlockedUserTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: ActiveLabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var unblockButton: UIButton!
    
    public var delegate: BlockedUserTableViewCellDelegate?
    private var viewModel = UserBlockedViewModel()
    private var castcleId: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.subTitleLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.subTitleLabel.textColor = UIColor.Asset.white
        self.unblockButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .body)
        self.unblockButton.setTitleColor(UIColor.Asset.white, for: .normal)
        self.unblockButton.capsule(color: UIColor.Asset.denger, borderWidth: 1, borderColor: UIColor.Asset.denger)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configCell(castcleId: String) {
        self.viewModel.delegate = self
        self.castcleId = castcleId
        self.titleLabel.customize { label in
            label.font = UIFont.asset(.regular, fontSize: .body)
            label.numberOfLines = 0
            label.textColor = UIColor.Asset.white
            label.enabledTypes = [.mention]
            label.mentionColor = UIColor.Asset.lightBlue
        }
        
        self.titleLabel.text = "@\(self.castcleId) is blocked"
        self.subTitleLabel.text = "Do you wish to view @\(self.castcleId) casts?\nConsidering unblock @\(self.castcleId)"
        self.unblockButton.setTitle("Unblocked", for: .normal)
    }
    
    @IBAction func unblockAction(_ sender: Any) {
        self.viewModel.unblockUser(castcleId: self.castcleId)
    }
}

extension BlockedUserTableViewCell: UserBlockedViewModelDelegate {
    func didUnblocked() {
        self.delegate?.didUnblocked(self)
    }
}
