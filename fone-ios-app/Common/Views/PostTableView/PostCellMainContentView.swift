//
//  PostCellMainContentView.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/25.
//

import UIKit
import Then
import SnapKit

class PostCellMainContentView: UIView {
    
    var hasBookmark: Bool
    
    private let imageView = UIImageView().then {
        $0.cornerRadius = 5
        $0.backgroundColor = .gray_D9D9D9
    }
    
    private let horizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 20
        $0.alignment = .top
    }
    
    /// `tagList`, `titleLabel`을 포함하고 있는 leftView
    private let leftView = UIView()
    private let tagList = TagList()
    
    let titleLabel = UILabel().then {
        $0.font = .font_b(14)
        $0.textColor = .gray_161616
        $0.numberOfLines = 2
        $0.text = "성균관대 영상학과에서 단편영화<Duet>배우 모집합니다."
    }
    
    private let bookmarkImageView = UIImageView().then {
        $0.image = UIImage(named: "Bookmark")
    }
    
    private let detailInfoBlock = DetailInfoBlock()
    
    private var jobTag = Tag()
    
    init(hasBookmark: Bool = true) {
        self.hasBookmark = hasBookmark
        super.init(frame: .zero)
        
        setupUI()
        setConstraints()
    }
    
    func configure(
        isOfficial: Bool = false,
        job: Job, // actor/staff
        categories: [Category], // 작품 성격 최대 2개
        deadline: String? = nil,
        coorporate: String? = nil,
        gender: String? = nil,
        period: String? = nil,
        casting: String? = nil,
        field: String? = nil
    ) {
        tagList.setValues(
            isOfficial: isOfficial,
            categories: categories
        )
        
        detailInfoBlock.setValues(
            dDay: "D-15",
            coorporate: coorporate,
            field: field ?? casting
        )
        
        jobTag.setType(as: job)
    }
    
    private func setupUI() {
        
        [
            imageView,
            horizontalStackView,
            detailInfoBlock,
            jobTag
        ]
            .forEach {
                self.addSubview($0)
            }
        
        [leftView]
            .forEach {
                horizontalStackView.addArrangedSubview($0)
            }
        
        if hasBookmark {
            horizontalStackView.addArrangedSubview(bookmarkImageView)
        }
        
        [tagList, titleLabel]
            .forEach {
                leftView.addSubview($0)
            }
        
    }
    
    private func setConstraints() {
        imageView.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(112)
            $0.top.leading.bottom.equalToSuperview()
        }
        
        horizontalStackView.snp.makeConstraints {
            $0.top.equalTo(imageView)
            $0.leading.equalTo(imageView.snp.trailing).offset(7)
            $0.trailing.equalToSuperview()
        }
        
        detailInfoBlock.snp.makeConstraints {
            $0.top.equalTo(horizontalStackView.snp.bottom).offset(6)
            $0.leading.equalTo(horizontalStackView)
        }
        
        jobTag.snp.makeConstraints {
            $0.leading.equalTo(detailInfoBlock.snp.trailing).offset(10) // FIXME: 디자인 확정 후 값 수정
            $0.trailing.equalTo(horizontalStackView.snp.trailing)
            $0.bottom.equalToSuperview()
        }
        
        bookmarkImageView.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        
        tagList.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.height.equalTo(18)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(tagList.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
