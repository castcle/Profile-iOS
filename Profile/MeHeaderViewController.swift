//
//  MeHeaderViewController.swift
//  Profile
//
//  Created by Tanakorn Phoochaliaw on 13/8/2564 BE.
//

import UIKit
import Core
import Kingfisher
import SwiftColor
import ActiveLabel

class MeHeaderViewController: UIViewController {

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
    
    var isMe: Bool = false
    var isFollow: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.Asset.darkGray
        
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

}
