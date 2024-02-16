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
    
    func configure(item: ProfileContent) {
        hookingCommentLabel.text = item.registerBasicInfo?.hookingComment
        profileImageView.kf.setImage(with: URL(string: item.userProfileURL ?? ""))
        nameLabel.text = item.registerBasicInfo?.name
        let year = item.registerDetailInfo?.birthday?.split(separator: "-").first ?? ""
        let age = item.age?.description ?? ""
        ageLabel.text = "\(year)년생 (\(age)살)"
        genderLabel.text = GenderType.getType(serverName: item.registerDetailInfo?.gender ?? "")?.name
    }
}
