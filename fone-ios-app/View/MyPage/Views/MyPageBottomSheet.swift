//
//  MyPageBottomSheet.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/10/14.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift

class MyPageBottomSheet: UIView {

    private let titleLabel = UILabel().then {
        $0.font = .font_b(19)
        $0.textColor = .gray_161616
    }
    
    private let contentLabel = UILabel().then {
        $0.font = .font_m(14)
        $0.textColor = .gray_555555
        $0.numberOfLines = 0
    }
    
    private let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 7
        $0.distribution = .fillEqually
    }
    private let noButton = UIButton().then {
        $0.cornerRadius = 5
        $0.backgroundColor = .red_CE0B39
        $0.setTitle("아니오", for: .normal)
        $0.setTitleColor(.white_FFFFFF, for: .normal)
        $0.titleLabel?.font = .font_m(16)
    }
    
    private let yesButton = UIButton().then {
        $0.cornerRadius = 5
        $0.backgroundColor = .gray_EEEFEF
        $0.setTitle("예", for: .normal)
        $0.setTitleColor(.gray_161616, for: .normal)
        $0.titleLabel?.font = .font_m(16)
    }
    
    var yesButtonTap: ControlEvent<Void> {
        yesButton.rx.tap
    }
    var noButtonTap: ControlEvent<Void> {
        noButton.rx.tap
    }
    
    init(
        title: String?,
        content: String?
    ) {
        super.init(frame: .zero)
        
        setUI()
        setConstraints()
        
        titleLabel.text = title
        contentLabel.text = content
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUI() {
        backgroundColor = .white_FFFFFF
        
        [
            titleLabel,
            contentLabel,
            buttonStackView
        ]
            .forEach { addSubview($0) }
        
        [
            noButton,
            yesButton
        ]
            .forEach { buttonStackView.addArrangedSubview($0) }
    }
    
    private func setConstraints() {

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.centerX.equalToSuperview()
//            $0.height.equalTo(26)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
//            $0.height.equalTo(20)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(44)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-40)
            $0.height.equalTo(48)
        }
        
        snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width)
        }
    }
}
