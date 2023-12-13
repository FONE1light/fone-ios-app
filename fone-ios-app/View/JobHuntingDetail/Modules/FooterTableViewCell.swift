//
//  FooterTableViewCell.swift
//  fone-ios-app
//
//  Created by 여나경 on 12/11/23.
//

import UIKit
import RxSwift
import Then
import SnapKit

class FooterTableViewCell: UITableViewCell {
    
    static let identifier = String(String(describing: FooterTableViewCell.self))
    private let label = UILabel().then {
        $0.font = .font_r(12)
        $0.textColor = .gray_9E9E9E
        $0.text = "본 정보는 게시된 담당자측에서 제공한 자료이며, 에프원은 기재된 내용에 대한 오류와 사용자가 이를 신뢰하여 취한 조취에 대해 책임을 지지 않습니다. 또한 누구든 본 정보를 통한 에프원 동의 없이 재배포할 수 없습니다. 부적합한 공고는 신고하기를 통해 알려주세요.\n구인구직이 아닌 광고 등의 목적으로 개인정보를 이용할 경우 법적 처벌을 받을 수 있습니다."
        $0.numberOfLines = 0
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        setupUI()
    }

    private func setupUI() {
        backgroundColor = .gray_F8F8F8
        contentView.addSubview(label)
        
        label.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-45)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
