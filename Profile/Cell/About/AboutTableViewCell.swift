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
//  AboutTableViewCell.swift
//  Profile
//
//  Created by Castcle Co., Ltd. on 16/9/2564 BE.
//

import UIKit
import Core

protocol AboutTableViewCellDelegate: AnyObject {
    func didUpdateData(_ aboutTableViewCell: AboutTableViewCell, overview: String)
}

class AboutTableViewCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet var headlineLabel: UILabel!
    @IBOutlet var overviewLabel: UILabel!
    @IBOutlet var overviewTextView: UITextView!
    @IBOutlet var aboutView: UIView!

    var delegate: AboutTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.aboutView.custom(color: UIColor.Asset.darkGray, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.headlineLabel.font = UIFont.asset(.regular, fontSize: .title)
        self.headlineLabel.textColor = UIColor.Asset.white
        self.overviewLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.overviewLabel.textColor = UIColor.Asset.white

        self.overviewTextView.delegate = self
        self.overviewTextView.font = UIFont.asset(.regular, fontSize: .body)
        self.overviewTextView.textColor = UIColor.Asset.white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configCell() {
        self.headlineLabel.text = Localization.UpdateInfo.headline.text
        self.overviewLabel.text = Localization.UpdateInfo.overview.text
        self.overviewTextView.placeholder = Localization.UpdateInfo.overviewPlaceholder.text
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 161
    }

    func textViewDidChange(_ textView: UITextView) {
        self.delegate?.didUpdateData(self, overview: textView.text)
    }
}
