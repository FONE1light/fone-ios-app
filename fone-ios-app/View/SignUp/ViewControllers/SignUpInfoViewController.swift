//
//  SignUpInfoViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/02.
//

import UIKit
import Then
import RxSwift

// TODO: Notch 여백 설정
class SignUpInfoViewController: UIViewController, ViewModelBindableType {

    var disposeBag = DisposeBag()
    var viewModel: SignUpViewModel! // FIXME: ! 없이 할 방법
    
    let baseView = UIView().then {
        $0.backgroundColor = .white_FFFFFF
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
    
    private let duplicatedWarningLabel = UILabel().then {
        $0.text = "중복되는 닉네임입니다."
        $0.font = .font_r(12)
        $0.textColor = .crimson_FF5841
    }
    
    private let duplicationCheckButton = DefaultButton().then {
        $0.setTitle("중복확인", for: .normal)
        $0.setTitleColor(.gray_D9D9D9, for: .normal)
        
        $0.titleLabel?.font = .font_r(14)
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
    
    private let maleButton = DefaultButton().then {
        $0.setTitle("남자", for: .normal)
//        $0.setTitleColor(.red_F43663, for: .normal) // TODO: textColor 적용
        $0.setTitleColor(.gray_D9D9D9, for: .normal)
        $0.titleLabel?.font = .font_r(14)
        $0.borderColor = .gray_D9D9D9
        $0.borderWidth = 1
        $0.cornerRadius = 5
    }
    
    private let femaleButton = DefaultButton().then {
        $0.setTitle("여자", for: .normal)
        $0.setTitleColor(.gray_D9D9D9, for: .normal) // TODO: textColor 적용
        $0.titleLabel?.font = .font_r(14)
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
    
    private let profileImage = UIImageView().then {
        $0.image = UIImage(named: "profileImage")
    }
    
    func bindViewModel() {
        // TextFields
        nicknameTextField.rx.controlEvent(.editingChanged)
            .withUnretained(self)
            .bind { owner, _ in
                owner.viewModel.checkNicknameAvailbleState(owner.nicknameTextField.text)
            }.disposed(by: rx.disposeBag)
        
        birthTextField.rx.controlEvent(.editingChanged)
            .withUnretained(self)
            .bind { owner, _ in
                let formattedBirth = owner.viewModel.formatBirthString(owner.birthTextField.text)
                owner.birthTextField.text = formattedBirth
            }.disposed(by: rx.disposeBag)
        
        // Buttons
        duplicationCheckButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                guard let nickname = owner.nicknameTextField.text, !nickname.isEmpty else {
                    return
                }
                owner.viewModel.checkNicknameDuplication(nickname)
            }.disposed(by: rx.disposeBag)
        
        maleButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                if owner.maleButton.isActivated.value {
                    owner.maleButton.deactivate()
                } else {
                    owner.maleButton.activate()
                    owner.femaleButton.deactivate()
                }
            }.disposed(by: rx.disposeBag)
        
        femaleButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                if owner.femaleButton.isActivated.value {
                    owner.femaleButton.deactivate()
                } else {
                    owner.femaleButton.activate()
                    owner.maleButton.deactivate()
                }
            }.disposed(by: rx.disposeBag)
        
        maleButton.isActivated
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { owner, isActivated in
                if isActivated {
                    owner.maleButton.borderColor = .red_F43663
                    owner.maleButton.setTitleColor(.red_F43663, for: .normal)
                } else {
                    owner.maleButton.borderColor = .gray_D9D9D9
                    owner.maleButton.setTitleColor(.gray_D9D9D9, for: .normal)
                }
            }.disposed(by: disposeBag) // rx로?
        
        femaleButton.isActivated
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { owner, isActivated in
                if isActivated {
                    owner.femaleButton.borderColor = .red_F43663
                    owner.femaleButton.setTitleColor(.red_F43663, for: .normal)
                } else {
                    owner.femaleButton.borderColor = .gray_D9D9D9
                    owner.femaleButton.setTitleColor(.gray_D9D9D9, for: .normal)
                }
            }.disposed(by: disposeBag) // rx로?
        
        // ViewModel
        viewModel.nicknameAvailbleState
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { owner, state in
                switch state {
                case .cannotCheck:
                    owner.duplicationCheckButton.borderColor = .gray_D9D9D9
                    owner.duplicationCheckButton.setTitle("중복확인", for: .normal)
                    owner.duplicationCheckButton.setTitleColor(.gray_D9D9D9, for: .normal)
                    owner.nicknameTextField.borderWidth = 0
                    owner.duplicatedWarningLabel.isHidden = true
                case .canCheck:
                    owner.duplicationCheckButton.borderColor = .red_F43663
                    owner.duplicationCheckButton.setTitle("중복확인", for: .normal)
                    owner.duplicationCheckButton.setTitleColor(.red_F43663, for: .normal)
                    owner.nicknameTextField.borderWidth = 0
                    owner.duplicatedWarningLabel.isHidden = true
                case .duplicated:
                    owner.duplicationCheckButton.borderColor = .gray_D9D9D9
                    owner.duplicationCheckButton.setTitle("중복확인", for: .normal)
                    owner.duplicationCheckButton.setTitleColor(.gray_D9D9D9, for: .normal)
                    owner.nicknameTextField.borderColor = .crimson_FF5841
                    owner.nicknameTextField.borderWidth = 1
                    owner.duplicatedWarningLabel.isHidden = false
                case .available:
                    owner.duplicationCheckButton.borderColor = .gray_D9D9D9
                    owner.duplicationCheckButton.setTitle("인증완료", for: .normal)
                    owner.duplicationCheckButton.setTitleColor(.gray_D9D9D9, for: .normal)
                    owner.nicknameTextField.borderWidth = 0
                    owner.duplicatedWarningLabel.isHidden = true
                }
            }.disposed(by: self.disposeBag)
        
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
        baseView.addSubview(duplicatedWarningLabel)
        
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
        
        duplicatedWarningLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(3)
            $0.leading.equalTo(nicknameTextField.snp.leading)
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
            $0.top.leading.equalToSuperview()
        }
        
        profileSubtitleLabel.snp.makeConstraints {
            $0.top.equalTo(profileLabel.snp.bottom).offset(1)
            $0.leading.equalToSuperview()
        }
        
        profileImage.snp.makeConstraints {
            $0.top.equalTo(profileSubtitleLabel.snp.bottom).offset(8)
            $0.leading.bottom.equalToSuperview()
            $0.size.equalTo(108)
        }
    }
    
}
