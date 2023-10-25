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
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(item: Content) {
        hookingCommentLabel.text = item.hookingComment
        profileImageView.kf.setImage(with: URL(string: item.profileURL))
        nameLabel.text = item.name
        let year = item.birthday?.split(separator: "-").first ?? ""
        let age = item.age?.description ?? ""
        ageLabel.text = "\(year)년생 (\(age)살)"
        genderLabel.text = GenderType(rawValue: item.gender)?.string
    }
}
