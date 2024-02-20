//
//  ContactTypeView.swift
//  fone-ios-app
//
//  Created by 여나경 on 2/20/24.
//

import UIKit
import Then
import SnapKit
import RxCocoa

class ContactTypeView: UIView {
    
    private let label = UILabel().then {
        $0.font = .font_r(16)
        $0.textColor = .gray_9E9E9E
    }
    
    private let arrow = UIImageView().then {
        $0.image = UIImage(named: "arrow_down16")
    }
    
    private let button = UIButton()
    
    var tap: ControlEvent<Void> {
        button.rx.tap
    }
    
    init(text: String?) {
        super.init(frame: .zero)
        
        label.text = text
        setupUI()
        setConstraints()
    }
    
    private func setupUI() {
        cornerRadius = 5
        backgroundColor = .gray_F8F8F8
        
        [label, arrow, button]
            .forEach { self.addSubview($0) }
    }
    
    private func setConstraints() {
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(12)
        }
        
        arrow.snp.makeConstraints {
            $0.centerY.equalTo(label)
            $0.trailing.equalToSuperview().offset(-12)
            $0.size.equalTo(16)
        }
        
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setLabel(_ text: String?) {
        label.text = text
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
