//
//  JobScrapCell.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/24.
//

import UIKit
import RxSwift
import RxCocoa

class JobScrapCell: UITableViewCell {
    
    static let identifier = String(describing: JobScrapCell.self)
    var disposeBag = DisposeBag()
    
    private let mainContentView = PostCellMainContentView(hasBookmark: true, hasJobTag: true)
    
    private let separator = Divider(
        width: UIScreen.main.bounds.width,
        height: 6, color: .gray_F8F8F8
    )
    
    var isScrap = BehaviorRelay<Bool>(value: true)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        setupUI()
        setConstraints()
        
        bind()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func configure(_ jobScrap: JobOpening) {
        mainContentView.configure(
            imageUrl: jobScrap.imageUrl,
            isVerified: jobScrap.isVerified,
            categories: jobScrap.categories ?? [],
            isScrap: jobScrap.isScrap,
            title: jobScrap.title,
            dDay: jobScrap.dDay,
            genre: jobScrap.genre,
            domain: jobScrap.domain,
            produce: jobScrap.produce,
            job: jobScrap.job
        )
    }
    
    private func setupUI() {
        [mainContentView, /*jobTag,*/ separator]
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
    
    private func bind() {
        mainContentView.bookmarkButtonTap
            .asDriver()
            .do { [weak self] _ in
                // cell의 button toggle
                _ = self?.mainContentView.toggleBookmarkButton()
            }
            .debounce(.milliseconds(500))
            .asObservable()
            .withUnretained(self)
            .bind { owner, _ in
                // API 호출 위해 상태값 방출
                owner.isScrap.accept(owner.mainContentView.isBookmarkButtonSelected)
            }.disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
