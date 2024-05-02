//
//  AuthorCell.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 11/12/23.
//

import UIKit

struct AuthorInfo {
    let createdAt, profileUrl, nickname, userJob: String
    let viewCount: Int
    let instagramUrl, youtubeUrl: String?
    
    init?(createdAt: String?, profileUrl: String?, nickname: String?, userJob: String?, viewCount: Int?, instagramUrl: String? = nil, youtubeUrl: String? = nil) {
        guard let createdAt = createdAt, let profileUrl = profileUrl, let nickname = nickname, let userJob = userJob, let viewCount = viewCount else { return nil }
        self.createdAt = createdAt
        self.profileUrl = profileUrl
        self.nickname = nickname
        self.userJob = userJob
        self.viewCount = viewCount
        self.instagramUrl = instagramUrl
        self.youtubeUrl = youtubeUrl
    }
}

class AuthorCell: UICollectionViewCell {
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var viewCountLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var userJobLabel: UILabel!
    @IBOutlet weak var officialMarkImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(authorInfo: AuthorInfo, isVerified: Bool) {
        createdAtLabel.text = getDateAndTime(createdAt: authorInfo.createdAt)
        viewCountLabel.text = String(authorInfo.viewCount)
        profileImageView.kf.setImage(with: URL(string: authorInfo.profileUrl))
        nicknameLabel.text = authorInfo.nickname
        userJobLabel.text = authorInfo.userJob
        officialMarkImageView.isHidden = !isVerified
    }
    
    fileprivate func getDateAndTime(createdAt: String) -> String {
        let dateArray = createdAt.split(separator: "T")
        let date = dateArray.first ?? ""
        let time = dateArray.last?.prefix(5) ?? ""
        return "\(date)  \(time)"
    }
}
