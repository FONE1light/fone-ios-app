//
//  TermsCell.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/10.
//

import UIKit
import SnapKit

class TermsCell: UITableViewCell {

    static let identifier = String(describing: TermsCell.self)
    
    let label = UILabel().then {
        $0.text = "이용약관 동의(필수)"
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        backgroundColor = .gray_EEEFEF
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.contentView.addSubview(label)
        
        label.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
        }
    }
    
}
