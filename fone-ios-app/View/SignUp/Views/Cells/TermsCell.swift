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
    
    let stackView = UIStackView().then {
        $0.axis = .vertical
    }
    
    let visibleView = UIView()
    
    let expandableView = UIView().then {
        $0.cornerRadius = 5
        $0.backgroundColor = .gray_EEEFEF
        $0.isHidden = true
    }
    
    let scrollView = UIScrollView()
    
    let checkBox = UIImageView().then {
        $0.image = UIImage(named: "checkboxes_off")
    }
    
    let label = UILabel().then {
        $0.font = .font_r(16)
        $0.textColor = .gray_9E9E9E
    }
    
    let arrowDown = UIImageView().then {
        $0.image = UIImage(named: "arrow_down16")//?.withRenderingMode(.alwaysTemplate)
    }
    
    let termsLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = .font_r(12)
        $0.textColor = .gray_9E9E9E
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        setupUI()
    }
    
    private func setupUI() {
        self.contentView.addSubview(stackView)
        
        [visibleView, expandableView]
            .forEach { stackView.addArrangedSubview($0) }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // visibleView
        [checkBox, label, arrowDown]
            .forEach { visibleView.addSubview($0) }

        checkBox.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8).priority(.low)
            $0.leading.equalToSuperview()
            $0.size.equalTo(16)
        }
        
        label.snp.makeConstraints {
            $0.centerY.equalTo(checkBox)
            $0.leading.equalTo(checkBox.snp.trailing).offset(6)
        }
        
        arrowDown.snp.makeConstraints {
            $0.centerY.equalTo(checkBox)
            $0.trailing.equalToSuperview()
        }
        
        // expandableView
        expandableView.snp.makeConstraints {
            $0.height.equalTo(77.3).priority(.low) // FIXME: 높이 다른 방식으로 지정
        }
        
        [ scrollView ]
            .forEach { expandableView.addSubview($0) }
        
        [ termsLabel ]
            .forEach { scrollView.addSubview($0) }
        
        scrollView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview()
        }
        
        termsLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalTo(expandableView).inset(20)
        }
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        visibleView.translatesAutoresizingMaskIntoConstraints = false
        expandableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
