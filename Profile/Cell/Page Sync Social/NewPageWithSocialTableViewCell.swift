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
//  NewPageWithSocialTableViewCell.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 26/1/2565 BE.
//

import UIKit
import Core

protocol NewPageWithSocialTableViewCellDelegate: AnyObject {
    func didSyncFacebook(_ newPageWithSocialTableViewCell: NewPageWithSocialTableViewCell)
    func didSyncTwitter(_ newPageWithSocialTableViewCell: NewPageWithSocialTableViewCell)
}

class NewPageWithSocialTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var facebookLabel: UILabel!
    @IBOutlet var twitterLabel: UILabel!
    @IBOutlet var facebookView: UIView!
    @IBOutlet var twitterView: UIView!
    @IBOutlet var facebookImage: UIImageView!
    @IBOutlet var twitterImage: UIImageView!
    @IBOutlet var createPageNormalButton: UIButton!

    public var delegate: NewPageWithSocialTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.font = UIFont.asset(.bold, fontSize: .head4)
        self.titleLabel.textColor = UIColor.Asset.white
        self.subTitleLabel.font = UIFont.asset(.light, fontSize: .body)
        self.subTitleLabel.textColor = UIColor.Asset.white
        self.facebookLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.facebookLabel.textColor = UIColor.Asset.white
        self.twitterLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.twitterLabel.textColor = UIColor.Asset.white
        self.facebookView.custom(color: UIColor.Asset.facebook, cornerRadius: 10)
        self.twitterView.custom(color: UIColor.Asset.twitter, cornerRadius: 10)
        self.facebookImage.image = UIImage.init(icon: .castcle(.facebook), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
        self.twitterImage.image = UIImage.init(icon: .castcle(.twitter), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
        self.createPageNormalButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .body)
        self.createPageNormalButton.setTitleColor(UIColor.Asset.white, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configCell() {
        self.titleLabel.text = "Sync your social media page"
        self.subTitleLabel.text = "Syncing your Castcle page with your social media account allows you to Cast your posts from another platform seamlessly"
        self.facebookLabel.text = "Sync your page with Facebook"
        self.twitterLabel.text = "Sync your page with Twitter"
        self.createPageNormalButton.setTitle("+ Create new page", for: .normal)
    }

    @IBAction func facebookAction(_ sender: Any) {
        self.delegate?.didSyncFacebook(self)
    }

    @IBAction func twitterAction(_ sender: Any) {
        self.delegate?.didSyncTwitter(self)
    }

    @IBAction func createPageNormalAction(_ sender: Any) {
        Utility.currentViewController().navigationController?.pushViewController(ProfileOpener.open(.welcomeCreatePage), animated: true)
    }
}
