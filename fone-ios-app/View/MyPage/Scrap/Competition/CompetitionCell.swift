//
//  CompetitionCell.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/26.
//

import UIKit
import RxSwift
import RxCocoa
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
    
    private let bookmarkButton = BookmarkButton()
    var isScrap = BehaviorRelay<Bool>(value: true)
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        setupUI()
        setupConstraints()
        
        bind()
    }
    
    private func setupUI() {
        [
            competitionImageView,
            titleLabel,
            coorporationLabel,
            dDayLabel,
            viewImageView,
            viewCountLabel,
            bookmarkButton,
            separator
        ]
            .forEach { contentView.addSubview($0) }
    }
    
    private func setupConstraints() {
        competitionImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().offset(16)
            $0.width.equalTo(95)
            $0.height.equalTo(98)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.leading.equalTo(competitionImageView.snp.trailing).offset(12)
            $0.trailing.equalTo(bookmarkButton.snp.leading).offset(-22)
        }
        
        coorporationLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        dDayLabel.snp.makeConstraints {
            $0.top.equalTo(coorporationLabel.snp.bottom).offset(16)
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
        
        bookmarkButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.trailing.equalToSuperview().offset(-24)
            $0.size.equalTo(24)
        }
        
        separator.snp.makeConstraints {
            $0.top.equalTo(competitionImageView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
        
    }
    
    private func bind() {
        bookmarkButton.rx.tap
            .asDriver()
            .do { [weak self] _ in
                // cell의 button toggle
                self?.bookmarkButton.toggle()
            }
            .debounce(.milliseconds(500))
            .asObservable()
            .withUnretained(self)
            .bind { owner, _ in
                // API 호출 위해 상태값 방출
                owner.isScrap.accept(owner.bookmarkButton.isSelected)
            }.disposed(by: disposeBag)
    }
    
    func configure(_ competition: CompetitionScrap) {
        titleLabel.text = competition.title
        coorporationLabel.text = competition.coorporation
        dDayLabel.text = competition.leftDays
        viewCountLabel.text = competition.viewCount?.toDecimalFormat()
        bookmarkButton.isSelected = competition.isScrap ?? false
    }
}
