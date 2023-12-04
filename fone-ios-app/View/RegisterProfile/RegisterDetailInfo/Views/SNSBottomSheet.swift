//
//  SNSBottomSheet.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/28/23.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxRelay

enum SNSType {
    case instagram
    case youtube
    
    var title: String {
        switch self {
        case .instagram: "인스타그램"
        case .youtube: "유튜브"
        }
    }
    
    func bottomSheet(link: BehaviorRelay<String?>) -> UIView {
        SNSBottomSheet(type: self, link: link)
    }
}

class SNSBottomSheet: UIView {
    
    private let snsLabel = UILabel().then {
        $0.text = "SNS"
        $0.font = .font_m(16)
        $0.textColor = .gray_9E9E9E
    }
    
    private let typeTitle = UILabel().then {
        $0.font = .font_b(16)
        $0.textColor = .gray_161616
    }

    private let textField: DefaultTextField
    private let link: BehaviorRelay<String?>
    
    private let nextButton = CustomButton("등록하기", type: .bottom)
    
    init(type: SNSType, link: BehaviorRelay<String?>) {
        textField = DefaultTextField(
            placeholder: "\(type.title) 링크를 첨부할 수 있어요"
        )
        self.link = link
        super.init(frame: .zero)
        
        typeTitle.text = type.title
        textField.text = link.value
        
        setupUI()
        setConstraints()
        bind()
    }
    
    private func setupUI() {
        backgroundColor = .white_FFFFFF
        [
            snsLabel,
            typeTitle,
            textField,
            // view
            nextButton
        ]
            .forEach { addSubview($0) }
        
        nextButton.applyShadow(shadowType: .shadowBt)
    }
    
    private func setConstraints() {
        snsLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(22)
        }
        
        typeTitle.snp.makeConstraints {
            $0.top.equalTo(snsLabel.snp.bottom).offset(13)
            $0.leading.trailing.equalTo(snsLabel)
        }
        
        textField.snp.makeConstraints {
            $0.top.equalTo(typeTitle.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(snsLabel)
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(132) // TODO: 추후 삭제
            $0.height.equalTo(48)
            $0.leading.trailing.equalTo(snsLabel)
            $0.bottom.equalToSuperview().inset(38)
        }
        
        snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width)
        }
    }
    
    private func bind() {
        nextButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.link.accept(owner.textField.text)
                // TODO: dismiss bottomSheet
            }.disposed(by: rx.disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
