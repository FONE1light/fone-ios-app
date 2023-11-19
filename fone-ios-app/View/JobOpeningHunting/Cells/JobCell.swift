//
//  JobCell.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/17/23.
//

import UIKit

class JobCell: UITableViewCell {
    
    private let mainContentView = PostCellMainContentView(hasBookmark: true)
    
    static let identifier = String(describing: JobCell.self)
    
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
        categories: [Category], // 작품 성격 최대 2개
        deadline: String? = nil,
        coorporate: String? = nil,
        gender: String? = nil,
        period: String? = nil,
        casting: String? = nil,
        field: String? = nil
    ) {
        mainContentView.configure(
            categories: categories,
            deadline: deadline,
            coorporate: coorporate,
            gender: gender,
            period: period,
            casting: casting,
            field: field
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
