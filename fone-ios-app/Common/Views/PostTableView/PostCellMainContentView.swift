//
//  PostCellMainContentView.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/25.
//

import UIKit
import Then
import SnapKit
import RxCocoa

class PostCellMainContentView: UIView {
    
    var hasBookmark: Bool
    
    private let imageView = UIImageView().then {
        $0.cornerRadius = 5
        $0.backgroundColor = .gray_D9D9D9
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.image = UIImage(named: "default_profile")
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
    }
    
    private let bookmarkButton = BookmarkButton()
    
    var bookmarkButtonTap: ControlEvent<Void> {
        bookmarkButton.rx.tap
    }
    
    private let detailInfoBlock = DetailInfoBlock()
    
    init(hasBookmark: Bool = true) {
        self.hasBookmark = hasBookmark
        super.init(frame: .zero)
        
        setupUI()
        setConstraints()
    }
    
    func configure(
        profileUrl: String? = nil,
        isVerified: Bool? = nil,
        categories: [Category], // 작품 성격 최대 2개
        isScrap: Bool? = nil,
        title: String? = nil,
        dDay: String? = nil,
        genre: String? = nil, // 배우 - 장르 중 첫 번째 값
        domain: String? = nil, // 스태프 - 분야 중 첫 번째 값
        produce: String? = nil
    ) {
        imageView.load(url: profileUrl)
        
        tagList.setValues(
            isVerified: isVerified ?? false,
            categories: categories
        )
        
        bookmarkButton.isSelected = isScrap ?? false
        
        titleLabel.text = title
        
        detailInfoBlock.setValues(
            dDay: dDay,
            domainOrGenre: domain ?? genre,
            produce: produce
        )
    }
    
    private func setupUI() {
        
        [
            imageView,
            horizontalStackView,
            detailInfoBlock
        ]
            .forEach {
                self.addSubview($0)
            }
        
        [leftView]
            .forEach {
                horizontalStackView.addArrangedSubview($0)
            }
        
        if hasBookmark {
            horizontalStackView.addArrangedSubview(bookmarkButton)
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
            $0.trailing.equalTo(bookmarkButton.snp.leading).offset(-9)
        }
        
        bookmarkButton.snp.makeConstraints {
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

extension PostCellMainContentView {
    func toggleBookmarkButton() {
        bookmarkButton.toggle()
    }
}
