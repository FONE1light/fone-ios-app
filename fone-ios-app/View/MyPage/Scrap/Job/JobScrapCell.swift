//
//  JobScrapCell.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/24.
//

import UIKit

class JobScrapCell: UITableViewCell {
    
    private let mainContentView = PostCellMainContentView(hasBookmark: true)
    private var jobTag = Tag()
    
    static let identifier = String(describing: JobScrapCell.self)
    
    private let separator = Divider(
        width: UIScreen.main.bounds.width,
        height: 6, color: .gray_F8F8F8
    )
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        setupUI()
        setConstraints()
    }
    
    func configure(
        job: Job, // actor/staff
        categories: [Category], // 작품 성격 최대 2개
        dDay: String? = nil,
        coorporate: String? = nil,
        casting: String? = nil,
        field: String? = nil
    ) {
        mainContentView.configure(
            categories: categories,
//            title: title,
            dDay: dDay,
            coorporate: coorporate,
            casting: casting,
            field: field
        )
        
        jobTag.setType(as: job)
    }
    
    private func setupUI() {
        [mainContentView, jobTag, separator]
            .forEach { contentView.addSubview($0) }
    }
    
    private func setConstraints() {
        mainContentView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        jobTag.snp.makeConstraints {
            $0.trailing.bottom.equalTo(mainContentView)
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
