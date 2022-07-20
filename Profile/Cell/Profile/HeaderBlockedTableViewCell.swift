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
//  HeaderBlockedTableViewCell.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 28/1/2565 BE.
//

import UIKit
import Core
import Networking
import Lightbox

class HeaderBlockedTableViewCell: UITableViewCell {

    @IBOutlet var coverImage: UIImageView!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var displayNameLabel: UILabel!
    @IBOutlet var userIdLabel: UILabel!

    private var userInfo = UserInfo()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.displayNameLabel.font = UIFont.asset(.regular, fontSize: .head4)
        self.displayNameLabel.textColor = UIColor.Asset.white
        self.userIdLabel.font = UIFont.asset(.light, fontSize: .overline)
        self.userIdLabel.textColor = UIColor.Asset.textGray
        self.profileImage.circle(color: UIColor.Asset.white)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configCell(userInfo: UserInfo) {
        self.userInfo =  userInfo
        let urlProfile = URL(string: self.userInfo.images.avatar.thumbnail)
        let urlCover = URL(string: self.userInfo.images.cover.large)
        self.profileImage.kf.setImage(with: urlProfile, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
        self.coverImage.kf.setImage(with: urlCover, placeholder: UIImage.Asset.placeholder, options: [.transition(.fade(0.35))])
        self.displayNameLabel.text = self.userInfo.displayName
        self.userIdLabel.text = "@\(self.userInfo.castcleId)"
    }

    private func displayUserImage(imageUrl: String) {
        let images = [
            LightboxImage(imageURL: URL(string: imageUrl)!)
        ]
        LightboxConfig.CloseButton.textAttributes = [
            .font: UIFont.asset(.bold, fontSize: .body),
            .foregroundColor: UIColor.Asset.white
          ]
        LightboxConfig.CloseButton.text = "Close"
        let controller = LightboxController(images: images)
        controller.pageDelegate = self
        controller.dismissalDelegate = self
        controller.dynamicBackground = true
        controller.footerView.isHidden = true
        Utility.currentViewController().present(controller, animated: true, completion: nil)
    }

    @IBAction func viewUserCoverAction(_ sender: Any) {
        self.displayUserImage(imageUrl: self.userInfo.images.cover.fullHd)
    }

    @IBAction func viewUserAvatarAction(_ sender: Any) {
        self.displayUserImage(imageUrl: self.userInfo.images.avatar.fullHd)
    }
}

extension HeaderBlockedTableViewCell: LightboxControllerPageDelegate {
    public func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
        // MARK: - Lightbox Move Page
    }
}

extension HeaderBlockedTableViewCell: LightboxControllerDismissalDelegate {
    public func lightboxControllerWillDismiss(_ controller: LightboxController) {
        // MARK: - Lightbox Dismiss
    }
}
