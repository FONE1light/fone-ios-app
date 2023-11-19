//
//  JobTypeDropdown.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/17/23.
//

import UIKit
import SnapKit
import Then
import RxCocoa

class JobTypeDropdown: UIView {
    
    private var isSelected = false {
        didSet {
            if isSelected {
                imageView.image = UIImage(named: "arrow_up16")
            } else {
                imageView.image = UIImage(named: "arrow_down")
            }
        }
    }
    
    private let label = UILabel().then {
        $0.text = "ACTOR"
        $0.font = .font_b(20)
        $0.textColor = .gray_161616
    }
    
    private let imageView = UIImageView().then {
        $0.image = UIImage(named: "arrow_down")
    }
    
    private let button = UIButton()
    
    var buttonTap: ControlEvent<Void> {
        button.rx.tap
    }
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
        setConstraints()
    }
    
    private func setupUI() {
        [label, imageView, button]
            .forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        label.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(70)
        }
        
        imageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(label.snp.trailing).offset(6)
            $0.trailing.equalToSuperview()
            $0.size.equalTo(16)
        }
        
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func switchSelectionState() {
        isSelected = !isSelected
    }
    
    func setLabel(_ text: String) {
        label.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
