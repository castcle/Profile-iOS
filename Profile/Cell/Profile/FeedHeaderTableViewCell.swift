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
//  FeedHeaderTableViewCell.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 3/1/2565 BE.
//

import UIKit
import Core

protocol FeedHeaderTableViewCellDelegate: AnyObject {
    func didSelectTab(_ feedHeaderTableViewCell: FeedHeaderTableViewCell, profileContentType: ProfileContentType)
}

class FeedHeaderTableViewCell: UITableViewCell {

    @IBOutlet var allButton: UIButton!
    @IBOutlet var postButton: UIButton!
    @IBOutlet var blogButton: UIButton!
    @IBOutlet var photoButton: UIButton!
    @IBOutlet var allLineView: UIView!
    @IBOutlet var postLineView: UIView!
    @IBOutlet var blogLineView: UIView!
    @IBOutlet var photoLineView: UIView!

    public var delegate: FeedHeaderTableViewCellDelegate?
    private var profileContentType: ProfileContentType = .all

    override func awakeFromNib() {
        super.awakeFromNib()
        self.allButton.titleLabel?.font = UIFont.asset(.bold, fontSize: .body)
        self.postButton.titleLabel?.font = UIFont.asset(.bold, fontSize: .body)
        self.blogButton.titleLabel?.font = UIFont.asset(.bold, fontSize: .body)
        self.photoButton.titleLabel?.font = UIFont.asset(.bold, fontSize: .body)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configCell(profileContentType: ProfileContentType) {
        self.profileContentType = profileContentType
        self.updateUi()
    }

    private func updateUi() {
        if self.profileContentType == .post {
            self.allButton.setTitleColor(UIColor.Asset.white, for: .normal)
            self.postButton.setTitleColor(UIColor.Asset.lightBlue, for: .normal)
            self.blogButton.setTitleColor(UIColor.Asset.white, for: .normal)
            self.photoButton.setTitleColor(UIColor.Asset.white, for: .normal)
            self.allLineView.backgroundColor = UIColor.Asset.darkGraphiteBlue
            self.postLineView.backgroundColor = UIColor.Asset.lightBlue
            self.blogLineView.backgroundColor = UIColor.Asset.darkGraphiteBlue
            self.photoLineView.backgroundColor = UIColor.Asset.darkGraphiteBlue
        } else if self.profileContentType == .blog {
            self.allButton.setTitleColor(UIColor.Asset.white, for: .normal)
            self.postButton.setTitleColor(UIColor.Asset.white, for: .normal)
            self.blogButton.setTitleColor(UIColor.Asset.lightBlue, for: .normal)
            self.photoButton.setTitleColor(UIColor.Asset.white, for: .normal)
            self.allLineView.backgroundColor = UIColor.Asset.darkGraphiteBlue
            self.postLineView.backgroundColor = UIColor.Asset.darkGraphiteBlue
            self.blogLineView.backgroundColor = UIColor.Asset.lightBlue
            self.photoLineView.backgroundColor = UIColor.Asset.darkGraphiteBlue
        } else if self.profileContentType == .photo {
            self.allButton.setTitleColor(UIColor.Asset.white, for: .normal)
            self.postButton.setTitleColor(UIColor.Asset.white, for: .normal)
            self.blogButton.setTitleColor(UIColor.Asset.white, for: .normal)
            self.photoButton.setTitleColor(UIColor.Asset.lightBlue, for: .normal)
            self.allLineView.backgroundColor = UIColor.Asset.darkGraphiteBlue
            self.postLineView.backgroundColor = UIColor.Asset.darkGraphiteBlue
            self.blogLineView.backgroundColor = UIColor.Asset.darkGraphiteBlue
            self.photoLineView.backgroundColor = UIColor.Asset.lightBlue
        } else {
            self.allButton.setTitleColor(UIColor.Asset.lightBlue, for: .normal)
            self.postButton.setTitleColor(UIColor.Asset.white, for: .normal)
            self.blogButton.setTitleColor(UIColor.Asset.white, for: .normal)
            self.photoButton.setTitleColor(UIColor.Asset.white, for: .normal)
            self.allLineView.backgroundColor = UIColor.Asset.lightBlue
            self.postLineView.backgroundColor = UIColor.Asset.darkGraphiteBlue
            self.blogLineView.backgroundColor = UIColor.Asset.darkGraphiteBlue
            self.photoLineView.backgroundColor = UIColor.Asset.darkGraphiteBlue
        }
    }

    @IBAction func allAction(_ sender: Any) {
        self.profileContentType = .all
        self.updateUi()
        self.delegate?.didSelectTab(self, profileContentType: self.profileContentType)
    }

    @IBAction func postAction(_ sender: Any) {
        self.profileContentType = .post
        self.updateUi()
        self.delegate?.didSelectTab(self, profileContentType: self.profileContentType)
    }

    @IBAction func blogAction(_ sender: Any) {
        self.profileContentType = .blog
        self.updateUi()
        self.delegate?.didSelectTab(self, profileContentType: self.profileContentType)
    }

    @IBAction func photoAction(_ sender: Any) {
        self.profileContentType = .photo
        self.updateUi()
        self.delegate?.didSelectTab(self, profileContentType: self.profileContentType)
    }
}
