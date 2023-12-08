//
//  DomainContentView.swift
//  fone-ios-app
//
//  Created by 여나경 on 12/7/23.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxRelay

class DomainContentView: UIView {
    
    private let domainStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 6
    }
    
    private let rightArrowImageView = UIImageView().then {
        $0.image = UIImage(named: "arrow_right")?.withTintColor(.gray_9E9E9E)
    }
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
        setConstraints()
    }
    
    private func setupUI() {
        cornerRadius = 5
        borderWidth = 1
        borderColor = .gray_EEEFEF
        
        [
            domainStackView,
            rightArrowImageView
        ]
            .forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        
        domainStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(11)
            $0.trailing.equalTo(rightArrowImageView.snp.leading).offset(-6)
        }
        
        rightArrowImageView.snp.makeConstraints {
            $0.size.equalTo(16)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupDomainStackView(with selectedDomains: [Domain]) {
        domainStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        var views: [UIView] = []
        
        switch selectedDomains.count {
        case 0:
            let label = UILabel().then {
                $0.text = "분야 선택"
                $0.font = .font_r(12)
                $0.textColor = .gray_9E9E9E
            }
            views.append(label)
            
        case 1, 2:
            views.append(contentsOf: selectedDomains.map { DomainPreviewTag($0) })
            
        case Domain.allCases.count:
            views.append(DomainPreviewTag(title: "전체선택"))
            
        default:
            views.append(DomainPreviewTag(title: "\(selectedDomains.count)개 선택"))
        }
        
        views.forEach { domainStackView.addArrangedSubview($0) }
    }
    
}
