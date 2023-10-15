//
//  CompetitionCell.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/26.
//

import UIKit
import RxSwift
import Then

class CompetitionCell: UITableViewCell {
    
    static let identifier = String(describing: CompetitionCell.self)
    var disposeBag = DisposeBag()
    
    private let separator = Divider(
        height: 1,
        color: .gray_EEEFEF
    )
    
    private let competitionImageView = UIImageView().then {
        $0.backgroundColor = .gray_D9D9D9
        $0.cornerRadius = 5
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .font_b(14)
        $0.textColor = .gray_161616
        $0.numberOfLines = 2
    }
    
    private let coorporationLabel = UILabel().then {
        $0.font = .font_m(13)
        $0.textColor = .gray_555555
    }
    
    private let dDayLabel = UILabel().then {
        $0.font = .font_m(13)
        $0.textColor = .violet_6D5999
    }
    
    private let viewImageView = UIImageView().then {
        $0.image = UIImage(named: "show_filled")
    }
    private let viewCountLabel = UILabel().then {
        $0.font = .font_m(13)
        $0.textColor = .gray_9E9E9E
    }
    
    private let bookmarkImageView = UIImageView().then {
        $0.image = UIImage(named: "Bookmark")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        [
            competitionImageView,
            titleLabel,
            coorporationLabel,
            dDayLabel,
            viewImageView,
            viewCountLabel,
            bookmarkImageView,
            separator
        ]
            .forEach { contentView.addSubview($0) }
    }
    
    private func setupConstraints() {
        competitionImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().offset(16)
            $0.width.equalTo(95)
            $0.height.equalTo(98)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.leading.equalTo(competitionImageView.snp.trailing).offset(12)
            $0.trailing.equalTo(bookmarkImageView.snp.leading).offset(-22)
        }
        
        coorporationLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalTo(titleLabel.snp.leading)
        }
        
        dDayLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.leading)
        }
        
        viewImageView.snp.makeConstraints {
            $0.centerY.equalTo(dDayLabel)
            $0.leading.equalTo(dDayLabel.snp.trailing).offset(8)
            $0.size.equalTo(16)
        }
        
        viewCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(dDayLabel)
            $0.leading.equalTo(viewImageView.snp.trailing).offset(2)
        }
        
        bookmarkImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.trailing.equalToSuperview().offset(-24)
            $0.size.equalTo(24)
        }
        
        separator.snp.makeConstraints {
            $0.top.equalTo(dDayLabel.snp.bottom).offset(13)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
        
    }
    func configure(
//        image: // TODO: imageURL 전달 받은 것 넣기
        title: String?,
        coorporation: String?,
        leftDays: String?, // TODO: 유효한 토큰 생기면 서버 데이터 확인해서 형식 확정(날짜, 숫자, 혹은 "D-N"/"마감")
        viewCount: Int
    ) {
        titleLabel.text = title
        coorporationLabel.text = coorporation
        dDayLabel.text = leftDays
        viewCountLabel.text = "3,222"// TODO: viewCount Int to "***,***,**" 포맷팅
    }
    
}


