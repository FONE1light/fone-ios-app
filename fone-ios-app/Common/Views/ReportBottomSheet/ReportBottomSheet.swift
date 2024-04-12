//
//  ReportBottomSheet.swift
//  fone-ios-app
//
//  Created by 여나경 on 12/13/23.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class ReportBottomSheet: UIView {
    
    private let label = UILabel().then {
        $0.font = .font_m(14)
        $0.textColor = .gray_555555
        $0.text = "신고하기"
    }
    
    private let rightArrow = UIImageView(image: UIImage(named: "arrow_right16"))
    
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
        backgroundColor = .white_FFFFFF
        
        [label, rightArrow, button]
            .forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        label.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.leading.equalToSuperview().offset(22)
        }
        
        rightArrow.snp.makeConstraints {
            $0.centerY.equalTo(label)
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(16)
        }
        
        button.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-30)
//            $0.height.equalTo(42) // FIXME: 높이 지정
        }
        
        snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
