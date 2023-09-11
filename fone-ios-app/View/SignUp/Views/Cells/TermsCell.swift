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
    
    let checkBox = UIImageView().then {
        $0.image = UIImage(named: "checkboxes_off")
    }
    
    let label = UILabel().then {
        $0.font = .font_r(16)
        $0.textColor = .gray_9E9E9E
    }
    
    let arrowDown = UIImageView().then {
        $0.image = UIImage(named: "arrow_down16")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        setupUI()
    }
    
    private func setupUI() {
        [label, checkBox, arrowDown]
            .forEach { self.contentView.addSubview($0) }
        
        checkBox.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.equalToSuperview()
            $0.size.equalTo(16)
        }
        
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(checkBox.snp.trailing).offset(6)
        }
        
        arrowDown.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
