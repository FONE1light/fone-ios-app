//
//  AuthorCell.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 11/12/23.
//

import UIKit

class AuthorCell: UICollectionViewCell {
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var viewCountLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var userJobLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(createdAt: String, viewCount: Int, profileUrl: String, nickname: String, userJob: String) {
        createdAtLabel.text = getDateAndTime(createdAt: createdAt)
        viewCountLabel.text = String(viewCount)
        profileImageView.kf.setImage(with: URL(string: profileUrl))
        nicknameLabel.text = nickname
        userJobLabel.text = userJob
    }
    
    fileprivate func getDateAndTime(createdAt: String) -> String {
        let dateArray = createdAt.split(separator: "T")
        let date = dateArray.first ?? ""
        let time = dateArray.last?.prefix(5) ?? ""
        return "\(date)  \(time)"
    }
}
