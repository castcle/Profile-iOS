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
//  MeInfoCell.swift
//  Profile
//
//  Created by Tanakorn Phoochaliaw on 6/8/2564 BE.
//

import UIKit
import Core
import Kingfisher
import SwiftColor
import ActiveLabel

class MeInfoCell: UICollectionViewCell {

    @IBOutlet var coverImage: UIImageView!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var editCoverButton: UIButton!
    @IBOutlet var moreButton: UIButton!
    @IBOutlet var editProfileImageButton: UIButton!
    @IBOutlet var displayNameLabel: UILabel!
    @IBOutlet var userIdLabel: UILabel!
    @IBOutlet var bioLabel: UILabel!
    @IBOutlet var editProfileButton: UIButton!
    @IBOutlet var viewProfileButton: UIButton!
    @IBOutlet var followButton: UIButton!
    @IBOutlet var followLabel: ActiveLabel! {
        didSet {
            self.followLabel.customize { label in
                label.font = UIFont.asset(.regular, fontSize: .body)
                label.numberOfLines = 1
                label.textColor = UIColor.Asset.gray
                
                let followingType = ActiveType.custom(pattern: "198")
                let followerType = ActiveType.custom(pattern: "33.6K")
                
                label.enabledTypes = [followingType, followerType]
                label.customColor[followingType] = UIColor.Asset.white
                label.customSelectedColor[followingType] = UIColor.Asset.white
                label.customColor[followerType] = UIColor.Asset.white
                label.customSelectedColor[followerType] = UIColor.Asset.white
            }
        }
    }
    
    var isMe: Bool = false {
        didSet {
            if self.isMe {
                let urlCover = URL(string: "https://cdn.pixabay.com/photo/2020/02/11/16/25/manarola-4840080_1280.jpg")
                self.coverImage.kf.setImage(with: urlCover)
                
                let urlProfile = URL(string: "https://images.mubicdn.net/images/cast_member/2184/cache-2992-1547409411/image-w856.jpg")
                self.profileImage.kf.setImage(with: urlProfile)
                
                self.displayNameLabel.text = "Tommy Cruise"
                self.userIdLabel.text = "@tommy-cruise"
                
                self.editCoverButton.isHidden = false
                self.editProfileButton.isHidden = false
                self.editProfileImageButton.isHidden = false
                
                self.viewProfileButton.isHidden = true
                self.followButton.isHidden = true
            } else {
                let urlCover = URL(string: "https://cdn.pixabay.com/photo/2021/07/13/18/58/coffee-6464307_1280.jpg")
                self.coverImage.kf.setImage(with: urlCover)
                
                let urlProfile = URL(string: "https://static.wikia.nocookie.net/whywomenkill/images/e/e7/Alexandra_Daddario.jpg")
                self.profileImage.kf.setImage(with: urlProfile)
                
                self.displayNameLabel.text = "Alexandra Daddario"
                self.userIdLabel.text = "@alexandra-daddario"
                
                self.editCoverButton.isHidden = true
                self.editProfileButton.isHidden = true
                self.editProfileImageButton.isHidden = true
                
                self.viewProfileButton.isHidden = false
                self.followButton.isHidden = false
            }
        }
    }
    var isFollow: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.displayNameLabel.font = UIFont.asset(.regular, fontSize: .h4)
        self.displayNameLabel.textColor = UIColor.Asset.white
        self.userIdLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.userIdLabel.textColor = UIColor.Asset.gray
        self.bioLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.bioLabel.textColor = UIColor.Asset.white
        
        self.profileImage.circle(color: UIColor.Asset.white)
        
        self.editProfileImageButton.setImage(UIImage.init(icon: .castcle(.camera), size: CGSize(width: 15, height: 15), textColor: UIColor.Asset.darkGraphiteBlue).withRenderingMode(.alwaysOriginal), for: .normal)
        self.editProfileImageButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
        self.editProfileImageButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.Asset.darkGraphiteBlue)
        
        self.moreButton.setImage(UIImage.init(icon: .castcle(.ellipsisV), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.gray).withRenderingMode(.alwaysOriginal), for: .normal)
        self.moreButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.Asset.gray)
        
        self.editCoverButton.setImage(UIImage.init(icon: .castcle(.camera), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        self.editCoverButton.setBackgroundImage(UIColor.Asset.gray.toImage(), for: .normal)
        self.editCoverButton.capsule()
        
        self.editProfileButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .overline)
        self.editProfileButton.setTitleColor(UIColor.Asset.lightBlue, for: .normal)
        self.editProfileButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.Asset.lightBlue)
        
        self.viewProfileButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .overline)
        self.viewProfileButton.setTitleColor(UIColor.Asset.lightBlue, for: .normal)
        self.viewProfileButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.Asset.lightBlue)
        
        self.followUI()
    }
    
    static func cellSize(width: CGFloat, bioText: String, followText: String) -> CGSize {
        let label = ActiveLabel(frame: CGRect(x: 0, y: 0, width: width - 30, height: CGFloat.greatestFiniteMagnitude))
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont.asset(.regular, fontSize: .body)
        label.numberOfLines = 0
        label.text = bioText
        label.sizeToFit()
        
        let labelFollow = ActiveLabel(frame: CGRect(x: 0, y: 0, width: width - 30, height: CGFloat.greatestFiniteMagnitude))
        labelFollow.font = UIFont.asset(.regular, fontSize: .body)
        labelFollow.numberOfLines = 1
        labelFollow.textColor = UIColor.Asset.gray
        
        let followingType = ActiveType.custom(pattern: "198")
        let followerType = ActiveType.custom(pattern: "33.6K")
        
        labelFollow.enabledTypes = [followingType, followerType]
        labelFollow.customColor[followingType] = UIColor.Asset.white
        labelFollow.customSelectedColor[followingType] = UIColor.Asset.white
        labelFollow.customColor[followerType] = UIColor.Asset.white
        labelFollow.customSelectedColor[followerType] = UIColor.Asset.white
        labelFollow.text = followText
        labelFollow.lineBreakMode = NSLineBreakMode.byWordWrapping
        labelFollow.sizeToFit()
        
        let imageHeight = UIView.aspectRatioCalculator(ratioWidth: 4, ratioHeight: 3, pixelsWidth: Double(width))
        return CGSize(width: width, height: (label.frame.height + labelFollow.frame.height + 180 + CGFloat(imageHeight)))
    }
    
    private func followUI() {
        if self.isFollow == true {
            self.followButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .overline)
            self.followButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
            self.followButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.Asset.lightBlue)
            self.followButton.setIcon(prefixText: "Following  ", prefixTextColor: UIColor.Asset.white, icon: .castcle(.checkmark), iconColor: UIColor.Asset.white, postfixText: "", postfixTextColor: UIColor.Asset.white, forState: .normal, textSize: 14, iconSize: 14)
        } else {
            self.followButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .overline)
            self.followButton.setBackgroundImage(UIColor.Asset.darkGray.toImage(), for: .normal)
            self.followButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.Asset.lightBlue)
            self.followButton.setIcon(prefixText: "     Follow     ", prefixTextColor: UIColor.Asset.lightBlue, icon: .castcle(.checkmark), iconColor: UIColor.Asset.darkGray, postfixText: "", postfixTextColor: UIColor.Asset.white, forState: .normal, textSize: 14, iconSize: 0)
        }
    }
    
    @IBAction func editCoverAction(_ sender: Any) {
    }
    
    @IBAction func editProfileImageAction(_ sender: Any) {
    }
    
    @IBAction func moreAction(_ sender: Any) {
    }
    
    @IBAction func editProfileAction(_ sender: Any) {
    }
    
    @IBAction func viewProfileAction(_ sender: Any) {
        Utility.currentViewController().navigationController?.pushViewController(ProfileOpener.open(.userInfo), animated: true)
    }
    
    @IBAction func followAction(_ sender: Any) {
        self.isFollow.toggle()
        self.followUI()
    }
}
