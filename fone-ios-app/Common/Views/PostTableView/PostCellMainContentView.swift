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
    var hasJobTag: Bool
    
    private let imageView = UIImageView().then {
        $0.cornerRadius = 5
        $0.backgroundColor = .gray_D9D9D9
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.image = UIImage(resource: .defaultProfile)
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
    var isBookmarkButtonSelected: Bool {
        bookmarkButton.isSelected
    }
    
    private let detailInfoBlock = DetailInfoBlock()
    
    private var jobTag = Tag()
    
    init(hasBookmark: Bool = true, hasJobTag: Bool = false) {
        self.hasBookmark = hasBookmark
        self.hasJobTag = hasJobTag
        
        super.init(frame: .zero)
        jobTag.isHidden = !hasJobTag
        setupUI()
        setConstraints()
    }
    
    // TODO: == nil 삭제
    func configure(
        imageUrl: String? = nil,
        isVerified: Bool? = nil,
        categories: [Category], // 작품 성격 최대 2개
        isScrap: Bool? = nil,
        title: String? = nil,
        dDay: String? = nil,
        genre: String? = nil, // 배우 - 장르 중 첫 번째 값
        domain: String? = nil, // 스태프 - 분야 중 첫 번째 값
        produce: String? = nil,
        job: Job? = nil
    ) {
        imageView.load(url: imageUrl)
        
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
        
        guard let job = job else { return }
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
            $0.leading.equalTo(imageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview()
        }
        
        detailInfoBlock.snp.makeConstraints {
            $0.top.equalTo(horizontalStackView.snp.bottom).offset(6)
            $0.leading.equalTo(horizontalStackView)
            if hasJobTag {
                $0.trailing.equalTo(jobTag.snp.leading).offset(-10)
            } else {
                $0.trailing.equalToSuperview()
            }
        }
        
        jobTag.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview()
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
    func toggleBookmarkButton() -> Bool {
        return bookmarkButton.toggle()
    }
}

extension PostCellMainContentView {
    /// 모든 값 초기화. `prepareForReuse`에서 사용
    func initialize() {
        imageView.image = UIImage(resource: .defaultProfile)
        
        tagList.setValues(
            isVerified: false,
            categories: []
        )
        
        bookmarkButton.isSelected = false
        
        titleLabel.text = nil
        
        detailInfoBlock.setValues()
    }
}
