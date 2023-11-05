//
//  ProfileCell.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 10/3/23.
//

import UIKit
import Kingfisher

class ProfileCell: UICollectionViewCell {
    @IBOutlet weak var hookingCommentLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(item: ProfileContent) {
        hookingCommentLabel.text = item.hookingComment
        profileImageView.kf.setImage(with: URL(string: item.profileURL))
        nicknameLabel.text = item.userNickname
        let age = item.age.description
        ageLabel.text = age + "살"
        genderLabel.text = GenderType(rawValue: item.gender)?.string
    }
}
