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
//  ProfileActionViewController.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 8/8/2564 BE.
//

import UIKit
import Core
import PanModal

public class ProfileActionViewController: UIViewController {

    @IBOutlet var seeFollowToppicImage: UIImageView!
    @IBOutlet var shareImage: UIImageView!
    @IBOutlet var seeFollowToppicLabel: UILabel!
    @IBOutlet var shareLabel: UILabel!

    var maxHeight = (UIScreen.main.bounds.height - 220)

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.seeFollowToppicImage.image = UIImage.init(icon: .castcle(.seeFollowingTopics), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white)
        self.shareImage.image = UIImage.init(icon: .castcle(.share), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white)
        self.seeFollowToppicLabel.font = UIFont.asset(.bold, fontSize: .body)
        self.seeFollowToppicLabel.textColor = UIColor.Asset.white
        self.shareLabel.font = UIFont.asset(.bold, fontSize: .body)
        self.shareLabel.textColor = UIColor.Asset.white
    }

    @IBAction func seeFollowToppicAction(_ sender: Any) {
        self.dismiss(animated: true)
    }

    @IBAction func shareAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension ProfileActionViewController: PanModalPresentable {

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    public var panScrollable: UIScrollView? {
        return nil
    }

    public var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(self.maxHeight)
    }

    public var anchorModalToLongForm: Bool {
        return false
    }
}
