//
//  JobOpeningSortButton.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/4/23.
//

import UIKit
import Then
import SnapKit
import RxCocoa

class JobOpeningSortButton: UIView {
    
    private let width: CGFloat
    
    private let label = UILabel().then {
        $0.font = .font_m(14)
        $0.textColor = .gray_161616
    }
    
    private let arrow = UIImageView().then {
        $0.image = UIImage(named: "arrow_down16")
    }
    
    private let button = UIButton()
    
    var tap: ControlEvent<Void> {
        button.rx.tap
    }
    
    /// 고정 너비 `width`를 갖는 정렬 옵션 표시 버튼
    /// - `label.text`에 따라 너비가 변하지 않도록 너비 고정
    init(width: CGFloat) {
        self.width = width
        super.init(frame: .zero)
        
        label.text = "최신순"
        setupUI()
        setConstraints()
    }
    
    private func setupUI() {
        cornerRadius = 5
        backgroundColor = .white_FFFFFF
        
        [label, arrow, button]
            .forEach { self.addSubview($0) }
    }
    
    private func setConstraints() {
        snp.makeConstraints {
            $0.width.equalTo(self.width)
        }
        
        label.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(7)
            $0.leading.equalToSuperview().offset(8)
        }
        
        arrow.snp.makeConstraints {
            $0.centerY.equalTo(label)
            $0.trailing.equalToSuperview().offset(-8)
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
