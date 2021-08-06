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
//  SocialSectionController.swift
//  Profile
//
//  Created by Tanakorn Phoochaliaw on 6/8/2564 BE.
//

import Core
import IGListKit

class SocialSectionController: ListSectionController {
    var socialLink: SocialLink = SocialLink()
    
    override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

// MARK: - Data Provider
extension SocialSectionController {
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else {
            return .zero
        }
        return SocialCell.cellSize(width: context.containerSize.width)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(withNibName: ProfileNibVars.CollectionViewCell.social, bundle: ConfigBundle.profile, for: self, at: index) as? SocialCell
        cell?.backgroundColor = UIColor.clear
        cell?.socialLink = self.socialLink
        return cell ?? SocialCell()
    }
    
    override func didUpdate(to object: Any) {
        self.socialLink = (object as? SocialLink) ?? SocialLink()
    }
}
