//
//  SummaryTableViewCell.swift
//  fone-ios-app
//
//  Created by 여나경 on 12/11/23.
//

import UIKit
import RxSwift
import Then
import SnapKit

class SummaryTableViewCell: UITableViewCell {
    
    static let identifier = String(String(describing: MainCareerTableViewCell.self))
    
    private let titleLabel = UILabel().then {
        $0.font = .font_b(17)
        $0.textColor = .gray_161616
        $0.text = "상세요강"
    }
    
    private let detailsLabel = UILabel().then {
        $0.font = .font_r(14)
        $0.textColor = .gray_161616
        $0.numberOfLines = 0
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        self.setupUI()
    }
    
    func configure(item: String) {
        detailsLabel.text = item
    }
    
    private func setupUI() {
        [titleLabel, detailsLabel]
            .forEach { contentView.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        detailsLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
