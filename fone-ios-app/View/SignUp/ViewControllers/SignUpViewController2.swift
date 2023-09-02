//
//  SignUpViewController2.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/02.
//

import UIKit
import Then

// TODO: Notch 여백 설정
class SignUpViewController2: UIViewController, ViewModelBindableType {

    var viewModel: SignUpViewModel! // FIXME: ! 없이 할 방법
    
    let baseView = UIView().then {
        $0.backgroundColor = .white_FFFFFF // beige
    }
    
    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
    }
    
    let stepIndicator = StepIndicator(.second)
    
    let titleLabel = UILabel().then {
        $0.text = "기본 정보를 입력해 주세요"
        $0.font = .font_b(20)
        $0.numberOfLines = 0
    }
    
    let nicknameBlock = UIView()
    
    private let nicknameLabel = UILabel().then {
        $0.text = "닉네임 *"
        $0.font = .font_m(15)
        $0.textColor = .gray_161616
    }
    
    private let nicknameTextField = DefaultTextField(placeHolder: "3~8자리의 숫자, 영어, 한글만 가능합니다")
    
    private let duplicationCheckButton = UIButton().then {
        $0.setTitle("중복확인", for: .normal)
        $0.titleLabel?.font = .font_r(14)
        $0.titleLabel?.textColor = .gray_D9D9D9 // TODO: 왜 색깔 적용 안되고 white인지
//        $0.backgroundColor = .black//.gray_D9D9D9
        $0.borderColor = .gray_D9D9D9
        $0.borderWidth = 1
        $0.cornerRadius = 5
    }
    
    let birthBlock = UIView()
    
    private let birthLabel = UILabel().then {
        $0.text = "생년월일 및 성별 *"
        $0.font = .font_m(15)
        $0.textColor = .gray_161616
    }
    
    private let birthSubtitleLabel = UILabel().then {
        $0.text = "성별과 생년월일의 정보는 변경이 불가능합니다."
        $0.font = .font_r(12)
        $0.textColor = .gray_9E9E9E
    }
    
    private let birthTextField = DefaultTextField(placeHolder: "YYYY-MM-DD")
    
    private let maleButton = UIButton().then {
        $0.setTitle("남자", for: .normal)
        $0.titleLabel?.font = .font_r(14)
        $0.titleLabel?.textColor = .gray_D9D9D9 // TODO: 왜 색깔 적용 안되고 white인지
//        $0.backgroundColor = .black//.gray_D9D9D9
        $0.borderColor = .gray_D9D9D9
        $0.borderWidth = 1
        $0.cornerRadius = 5
    }
    
    private let femaleButton = UIButton().then {
        $0.setTitle("여자", for: .normal)
        $0.titleLabel?.font = .font_r(14)
        $0.titleLabel?.textColor = .gray_D9D9D9 // TODO: 왜 색깔 적용 안되고 white인지
//        $0.backgroundColor = .black//.gray_D9D9D9
        $0.borderColor = .gray_D9D9D9
        $0.borderWidth = 1
        $0.cornerRadius = 5
    }
    
    let profileBlock = UIView()
    
    private let profileLabel = UILabel().then {
        $0.text = "프로필 사진 등록"
        $0.font = .font_m(15)
        $0.textColor = .gray_161616
    }
    
    private let profileSubtitleLabel = UILabel().then {
        $0.text = "필수 선택사항이 아니며 기본 프로필 사진이 등록됩니다."
        $0.font = .font_r(12)
        $0.textColor = .gray_9E9E9E
    }
    
    private let profileImage = UIView().then {
        $0.backgroundColor = .yellow
    }
    
    func bindViewModel() {
        duplicationCheckButton.rx.tap
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
            nicknameBlock,
            EmptyView(height: 40),
            birthBlock,
            EmptyView(height: 40),
            profileBlock
        ]
            .forEach {
            stackView.addArrangedSubview($0)
        }
        
        [
            nicknameLabel,
            nicknameTextField,
            duplicationCheckButton
        ]
            .forEach { nicknameBlock.addSubview($0) }
        
        self.setupNicknameBlock()
        
        [
            birthLabel,
            birthSubtitleLabel,
            birthTextField,
            maleButton,
            femaleButton
        ]
            .forEach { birthBlock.addSubview($0) }
        self.setupBirthBlock()
        
        [
            profileLabel,
            profileSubtitleLabel,
            profileImage
        ]
            .forEach { profileBlock.addSubview($0) }
        self.setupProfileBlock()
        
    }
    
    private func setConstraints() {
        baseView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
//            $0.top.equalToSuperview().offset(40) // TODO: 노치 처리 후
        }
        
        nicknameBlock.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
        
        birthBlock.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }

        profileBlock.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    private func setupNicknameBlock() {
        nicknameLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(8)
            $0.leading.bottom.equalToSuperview()
        }
        
        duplicationCheckButton.snp.makeConstraints {
            $0.top.bottom.equalTo(nicknameTextField)
            $0.leading.equalTo(nicknameTextField.snp.trailing).offset(4)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(82)
        }
    }
    
    private func setupBirthBlock() {
        birthLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        birthSubtitleLabel.snp.makeConstraints {
            $0.top.equalTo(birthLabel.snp.bottom).offset(1)
            $0.leading.equalToSuperview()
        }
        
        birthTextField.snp.makeConstraints {
            $0.top.equalTo(birthSubtitleLabel.snp.bottom).offset(8)
            $0.leading.bottom.equalToSuperview()
        }
        
        maleButton.snp.makeConstraints {
            $0.top.bottom.equalTo(birthTextField)
            $0.leading.equalTo(birthTextField.snp.trailing).offset(4)
            $0.width.equalTo(82)
        }
        
        femaleButton.snp.makeConstraints {
            $0.top.bottom.equalTo(birthTextField)
            $0.leading.equalTo(maleButton.snp.trailing).offset(4)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(82)
        }
    }
    
    private func setupProfileBlock() {
        profileLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        profileSubtitleLabel.snp.makeConstraints {
            $0.top.equalTo(profileLabel.snp.bottom).offset(1)
            $0.leading.equalToSuperview()
        }
        
        profileImage.snp.makeConstraints {
            $0.top.equalTo(profileSubtitleLabel.snp.bottom).offset(8)
            $0.size.equalTo(80)
        }
    }
    
}
