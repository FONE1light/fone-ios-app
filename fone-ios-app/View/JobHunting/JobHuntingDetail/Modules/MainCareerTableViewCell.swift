//
//  MainCareerTableViewCell.swift
//  fone-ios-app
//
//  Created by 여나경 on 12/11/23.
//

import UIKit
import RxSwift
import Then
import SnapKit

class MainCareerTableViewCell: UITableViewCell {
    
    static let identifier = String(String(describing: MainCareerTableViewCell.self))
    
    private let titleLabel = UILabel().then {
        $0.font = .font_b(17)
        $0.textColor = .gray_161616
        $0.text = "주요경력"
    }
    
    private let detailsLabel = UILabel().then {
        $0.font = .font_r(14)
        $0.textColor = .gray_161616
        $0.numberOfLines = 0
    }
    
    private let divider = Divider(height: 8, color: .gray_F8F8F8)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        self.setupUI()
    }
    
    func configure(years: String, detail: String?) {
        var content = "\(years)"
        if let detail = detail, !detail.isEmpty {
            content += "\n\n\(detail)"
        }
        
        detailsLabel.text = content
    }
    
    private func setupUI() {
        [titleLabel, detailsLabel, divider]
            .forEach { contentView.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        detailsLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        divider.snp.makeConstraints {
            $0.top.equalTo(detailsLabel.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
