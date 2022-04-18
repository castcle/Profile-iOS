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

protocol PageSyncSocialTableViewCellDelegate {
    func didConnect(_ pageSyncSocialTableViewCell: PageSyncSocialTableViewCell, isActive: Bool)
    func didAutoPost(_ pageSyncSocialTableViewCell: PageSyncSocialTableViewCell, isAutoPost: Bool)
}

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
    
    @IBOutlet var autoPostSwitch: UISwitch!
    @IBOutlet var autoPostIcon: UIImageView!
    @IBOutlet var autoPostLabel: UILabel!
    @IBOutlet var noticeLabel: UILabel!
    @IBOutlet var line01View: UIView!
    @IBOutlet var line02View: UIView!
    
    @IBOutlet var actionTitleLabel: UILabel!
    @IBOutlet var actionDetailLabel: UILabel!
    @IBOutlet var actionButton: UIButton!
    
    public var delegate: PageSyncSocialTableViewCellDelegate?
    var syncDetail: SyncDetail = SyncDetail()
    
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
        
        self.connectIcon.image = UIImage.init(icon: .castcle(.bindLink), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
        self.autoPostIcon.image = UIImage.init(icon: .castcle(.autoPost), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
        
        self.autoPostSwitch.tintColor = UIColor.Asset.darkGray
        self.autoPostSwitch.onTintColor = UIColor.Asset.lightBlue
        self.autoPostSwitch.thumbTintColor = UIColor.Asset.white
        self.autoPostSwitch.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
        self.autoPostLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.autoPostLabel.textColor = UIColor.Asset.white
        self.noticeLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.noticeLabel.textColor = UIColor.Asset.gray
        self.line01View.backgroundColor = UIColor.Asset.black
        self.line02View.backgroundColor = UIColor.Asset.black
        
        self.actionTitleLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.actionTitleLabel.textColor = UIColor.Asset.white
        self.actionDetailLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.actionDetailLabel.textColor = UIColor.Asset.white
        self.actionButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .overline)
        self.actionButton.setTitleColor(UIColor.Asset.white, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func switchValueDidChange(_ sender: UISwitch) {
        if sender.isOn {
            self.delegate?.didAutoPost(self, isAutoPost: true)
        } else {
            self.delegate?.didAutoPost(self, isAutoPost: false)
        }
    }
    
    func configCell(displayName: String, castcleId: String, avatar: String, syncDetail: SyncDetail) {
        self.syncDetail = syncDetail
        
        self.sicialIconView.capsule(color: self.syncDetail.provider.color, borderWidth: 2, borderColor: UIColor.Asset.black)
        self.castcleIconView.capsule(color: UIColor.Asset.black, borderWidth: 2, borderColor: UIColor.Asset.black)
        self.socialIcon.image = self.syncDetail.provider.icon
        self.castcleIcon.image = UIImage.init(icon: .castcle(.logo), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
        
        let castcleAvatarUrl = URL(string: avatar)
        self.castcleAvatarImage.kf.setImage(with: castcleAvatarUrl, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
        self.castcleNameLabel.text = displayName
        self.castcleIdLabel.text = "@\(castcleId)"
        
        let socialAvatarUrl = URL(string: self.syncDetail.avatar)
        self.socialAvatarImage.kf.setImage(with: socialAvatarUrl, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
        self.socialNameLabel.text = self.syncDetail.displayName
        self.socialIdLabel.text = self.syncDetail.userName.isEmpty ? "" : "@\(self.syncDetail.userName)"
        
        if self.syncDetail.autoPost {
            self.autoPostSwitch.setOn(true, animated: false)
        } else {
            self.autoPostSwitch.setOn(false, animated: false)
        }
        
        self.noticeLabel.text = "Your post on \(self.syncDetail.provider.display) will automatically cast on Castcle."
        self.updateButton()
    }
    
    private func updateButton() {
        if self.syncDetail.active {
            self.actionTitleLabel.text = "Do You want to disconnect from \(self.syncDetail.provider.display)? "
            self.actionDetailLabel.text = "Disconnect sync does not affect any of the information you have posted, and it will not affect your account.  You can reconnect it at any time"
            self.actionButton.setTitle("Disconnect", for: .normal)
            self.actionButton.capsule(color: UIColor.Asset.denger, borderWidth: 1, borderColor: UIColor.Asset.denger)
        } else {
            self.actionTitleLabel.text = "Do you wish to reconnect with \(self.syncDetail.provider.display)?"
            self.actionDetailLabel.text = " By reconnecting your social media account, you will be able to automatically cast on Castcle."
            self.actionButton.setTitle("Reconnect", for: .normal)
            self.actionButton.capsule(color: UIColor.Asset.lightBlue, borderWidth: 1, borderColor: UIColor.Asset.lightBlue)
        }
    }
    
    @IBAction func syncAction(_ sender: Any) {
        self.syncDetail.active.toggle()
        self.delegate?.didConnect(self, isActive: self.syncDetail.active)
    }
}
