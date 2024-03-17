//
//  AuthorTableViewCell.swift
//  fone-ios-app
//
//  Created by 여나경 on 12/11/23.
//

import UIKit
import RxSwift
import Then
import SnapKit
import RxCocoa

class AuthorTableViewCell: UITableViewCell {
    
    static let identifier = String(String(describing: AuthorTableViewCell.self))
    var disposeBag = DisposeBag()
    
    private let createdAtLabel = UILabel().then {
        $0.font = .font_m(13)
        $0.textColor = .gray_555555
    }
    
    private let viewCountImageView = UIImageView(image: UIImage(named: "show_filled"))
    
    private let viewCountLabel = UILabel().then {
        $0.font = .font_r(12)
        $0.textColor = .gray_9E9E9E
    }
    
    private let profileImageView = UIImageView().then {
        $0.backgroundColor = .gray_D9D9D9
        $0.cornerRadius = 16
        $0.clipsToBounds = true
    }
    
    private let nicknameLabel = UILabel().then {
        $0.font = .font_b(15)
        $0.textColor = .gray_161616
    }
    
    private let userJobLabel = UILabel().then {
        $0.font = .font_b(14)
        $0.textColor = .red_CE0B39
    }
    
    private let officialMarkImageView = UIImageView(image: UIImage(named: "mark")) .then {
        $0.isHidden = true
    }
    
    private let snsStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 6
    }
    
    private let instagramButton = UIButton().then {
        $0.setImage(UIImage(named: "instagram_but"), for: .normal)
    }
    
    var instagramButtonTap: ControlEvent<Void> {
        instagramButton.rx.tap
    }
    
    
    private let youtubeButton = UIButton().then {
        $0.setImage(UIImage(named: "youtube_but"), for: .normal)
    }
    
    var youtubeButtonTap: ControlEvent<Void> {
        youtubeButton.rx.tap
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        setupUI()
    }
    
    
    func configure(authorInfo: AuthorInfo) {
        createdAtLabel.text = getDateAndTime(createdAt: authorInfo.createdAt)
        viewCountLabel.text = String(authorInfo.viewCount)
        profileImageView.load(url: authorInfo.profileUrl)
        nicknameLabel.text = authorInfo.nickname
        userJobLabel.text = authorInfo.userJob
        officialMarkImageView.isHidden = authorInfo.userJob != "OFFICIAL"
        // 정확한 url 필요 없고 존재 유무만 전달
        let hasInstagram = authorInfo.instagramUrl != nil
        let hasYoutube = authorInfo.youtubeUrl != nil
        setupSnsStackView(hasInstagram: hasInstagram, hasYoutube: hasYoutube)
        
    }
    
    private func setupUI() {
        [
            createdAtLabel,
            viewCountImageView,
            viewCountLabel,
            profileImageView,
            nicknameLabel,
            userJobLabel,
            officialMarkImageView,
            snsStackView
        ]
            .forEach { contentView.addSubview($0) }
        
        createdAtLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(16)
        }
        
        viewCountImageView.snp.makeConstraints {
            $0.size.equalTo(16)
            $0.centerY.equalTo(createdAtLabel)
            $0.trailing.equalTo(viewCountLabel.snp.leading).offset(-3)
        }
        
        viewCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(createdAtLabel)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(createdAtLabel.snp.bottom).offset(6)
            $0.leading.equalTo(createdAtLabel)
            $0.size.equalTo(32)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(6)
        }
        
        userJobLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.leading.equalTo(nicknameLabel.snp.trailing).offset(4)
        }
        
        snsStackView.snp.makeConstraints {
            $0.top.equalTo(viewCountLabel.snp.bottom).offset(6)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(32)
        }
    }
    
    private func setupSnsStackView(hasInstagram: Bool, hasYoutube: Bool) {
        snsStackView.arrangedSubviews
            .forEach { $0.removeFromSuperview() }
        
        if hasInstagram {
            snsStackView.addArrangedSubview(instagramButton)
        }
        
        if hasYoutube {
            snsStackView.addArrangedSubview(youtubeButton)
        }
    }
    
    fileprivate func getDateAndTime(createdAt: String) -> String {
        let dateArray = createdAt.split(separator: "T")
        let date = dateArray.first ?? ""
        let time = dateArray.last?.prefix(5) ?? ""
        return "\(date)  \(time)"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
