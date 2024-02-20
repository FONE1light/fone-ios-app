//
//  JobCell.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/17/23.
//

import UIKit
import RxSwift
import RxCocoa

class JobCell: UITableViewCell {
    
    var id: Int?
    var jobType: Job?
    
    private let mainContentView = PostCellMainContentView(hasBookmark: true)
    var disposeBag = DisposeBag()
    
    static let identifier = String(describing: JobCell.self)
    
    private let separator = Divider(
        width: UIScreen.main.bounds.width,
        height: 6, color: .gray_F8F8F8
    )
    
    var bookmarkButtonTap: ControlEvent<Void> {
        mainContentView.bookmarkButtonTap
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        setupUI()
        setConstraints()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag() // 버튼(bookmarkButtonTap) 바인딩을 한 번만 하기 위해 필요
    }
    
    func configure(
        id: Int? = nil,
        jobType: String? = nil, // ACTOR 혹은 STAFF
        profileUrl: String? = nil,
        isVerified: Bool? = nil,
        categories: [String]?, // 작품 성격 최대 2개
        isScrap: Bool? = nil,
        title: String? = nil,
        dDay: String? = nil,
        genre: String? = nil, // 배우 - 장르 중 첫 번째 값
        domain: String? = nil, // 스태프 - 분야 중 첫 번째 값
        produce: String? = nil
    ) {
        self.id = id
        self.jobType = Job.getType(name: jobType)
        
        let categories = categories?.compactMap { Category.getType(serverName: $0) } ?? []
        let genre = Genre.getType(name: genre ?? "")?.koreanName
        let domain = Domain.getType(serverName: domain ?? "")?.name
        
        mainContentView.configure(
            profileUrl: profileUrl,
            isVerified: isVerified,
            categories: categories,
            isScrap: isScrap,
            title: title,
            dDay: dDay,
            genre: genre,
            domain: domain,
            produce: produce
        )
    }
    
    private func setupUI() {
        [mainContentView, separator]
            .forEach { contentView.addSubview($0) }
    }
    
    private func setConstraints() {
        mainContentView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        separator.snp.makeConstraints {
            $0.top.equalTo(mainContentView.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension JobCell {
    func toggleBookmarkButton() {
        mainContentView.toggleBookmarkButton()
    }
}
