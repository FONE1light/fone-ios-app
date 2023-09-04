//
//  SignUpPhoneNumberViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/02.
//

import UIKit
import Then

// TODO: Notch 여백 설정
class SignUpPhoneNumberViewController: UIViewController, ViewModelBindableType {

    var viewModel: SignUpViewModel! // FIXME: ! 없이 할 방법
    
    let baseView = UIView().then {
        $0.backgroundColor = .white_FFFFFF
    }
    
    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
    }
    
    let stepIndicator = StepIndicator(.third)
    
    let titleLabel = UILabel().then {
        $0.text = "마지막으로\n휴대전화 번호를 인증해주세요."
        $0.font = .font_b(20)
        $0.numberOfLines = 0
    }
    
    let phoneNumberBlock = UIView()
    
    private let phoneNumberLabel = UILabel().then {
        $0.text = "휴대전화 번호"
        $0.font = .font_m(15)
        $0.textColor = .gray_161616
    }
    
    private let phoneNumberTextField = DefaultTextField(placeHolder: "'-' 빼고 숫자만 입력")
    
    private let sendAuthNumberButton = UIButton().then {
        $0.setTitle("인증번호 발송", for: .normal)
        $0.titleLabel?.font = .font_r(14)
        $0.titleLabel?.textColor = .gray_D9D9D9 // TODO: 왜 색깔 적용 안되고 white인지
//        $0.backgroundColor = .black//.gray_D9D9D9
        $0.borderColor = .gray_D9D9D9
        $0.borderWidth = 1
        $0.cornerRadius = 5
    }
    
    let agreementBlock = UIView()
    
    
    
    func bindViewModel() {
        sendAuthNumberButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
            print("clicked")
            owner.viewModel.checkNicknameDuplication("테스트닉네임")
        }.disposed(by: rx.disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setConstraints()
        
    }
    
    private func setUI() {
        self.view.backgroundColor = .white_FFFFFF
        
        self.view.addSubview(baseView)
        
        baseView.addSubview(stackView)
        
        [
            stepIndicator,
            EmptyView(height: 14),
            titleLabel,
            EmptyView(height: 32),
            phoneNumberBlock,
            EmptyView(height: 178),
            agreementBlock
        ]
            .forEach {
            stackView.addArrangedSubview($0)
        }
        
        [
            phoneNumberLabel,
            phoneNumberTextField,
            sendAuthNumberButton
        ]
            .forEach { phoneNumberBlock.addSubview($0) }
        
        self.setupPhoneNumberBlock()
        
    }
    
    private func setConstraints() {
        baseView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
//            $0.top.equalToSuperview().offset(40)
        }
        
        phoneNumberBlock.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
        
        agreementBlock.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }

    }
    
    private func setupPhoneNumberBlock() {
        phoneNumberLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        phoneNumberTextField.snp.makeConstraints {
            $0.top.equalTo(phoneNumberLabel.snp.bottom).offset(8)
            $0.leading.bottom.equalToSuperview()
        }
        
        sendAuthNumberButton.snp.makeConstraints {
            $0.top.bottom.equalTo(phoneNumberTextField)
            $0.leading.equalTo(phoneNumberTextField.snp.trailing).offset(4)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(82)
        }
    }
    
    
}
