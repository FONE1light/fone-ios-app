//
//  ProfileViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/12.
//

import UIKit
import Then
import RxSwift

class ProfileViewController: UIViewController, ViewModelBindableType {
    
    var disposeBag = DisposeBag()
    var viewModel: ProfileViewModel!
    
    private let profileImage = UIImageView().then {
        $0.image = UIImage(named: "profileImage")
    }
    
    let nicknameBlock = UIView()
    
    private let nicknameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = .font_m(15)
        $0.textColor = .gray_161616
    }
    
    private let nicknameSubtitle = UILabel().then {
        $0.text = "※3~8자리의 숫자, 영어 한글만 가능합니다."
        $0.font = .font_r(12)
        $0.textColor = .gray_9E9E9E
    }
    
    private let nicknameTextField = DefaultTextField()
    
    private let duplicatedWarningLabel = UILabel().then {
        $0.text = "중복되는 닉네임입니다."
        $0.font = .font_r(12)
        $0.textColor = .crimson_FF5841
    }
    
    private let duplicationCheckButton = CustomButton("중복확인", type: .auth)
    
    let jobSelectionBlock = SelectionBlock().then {
        $0.setTitle("직업 선택")
        $0.setSelections(Job.allCases)
    }
    
    let categorySelectionBlock = SelectionBlock().then {
        $0.setTitle("관심사 선택")
        $0.setSubtitle("(중복 선택 가능)")
        $0.setSelections(Category.allCases)
    }
    
    let button = CustomButton("수정하기", type: .bottom)
    
    
    let baseView = UIView()
    
    func bindViewModel() {
        // TextFields
        nicknameTextField.rx.controlEvent(.editingChanged)
            .withUnretained(self)
            .bind { owner, _ in
                owner.viewModel.checkNicknameAvailbleState(owner.nicknameTextField.text)
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
        
        // ViewModel
        viewModel.nicknameAvailbleState
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { owner, state in
                switch state {
                case .cannotCheck:
                    owner.duplicationCheckButton.setTitle("중복확인", for: .normal)
                    owner.duplicationCheckButton.isEnabled = false
                    owner.duplicatedWarningLabel.isHidden = true
                case .canCheck:
                    owner.duplicationCheckButton.setTitle("중복확인", for: .normal)
                    owner.duplicationCheckButton.isEnabled = true
                    owner.duplicatedWarningLabel.isHidden = true
                case .duplicated:
                    owner.duplicationCheckButton.setTitle("중복확인", for: .normal)
                    owner.duplicationCheckButton.isEnabled = false
                    owner.duplicatedWarningLabel.isHidden = false
                case .available:
                    owner.duplicationCheckButton.setTitle("인증완료", for: .normal)
                    owner.duplicationCheckButton.isEnabled = false
                    owner.duplicatedWarningLabel.isHidden = true
                }
            }.disposed(by: self.disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white_FFFFFF
        setNavigationBar()
        setUI()
        setConstraints()
    }
    
    private func setNavigationBar() {
        self.navigationItem.titleView = NavigationTitleView(title: "")
        self.navigationItem.leftBarButtonItem = NavigationLeftBarButtonItem(
            type: .back,
            viewController: self
        )
    }
    
    private func setUI() {
        self.view.addSubview(baseView)
        
        [
            profileImage,
            nicknameBlock,
            jobSelectionBlock,
            categorySelectionBlock,
            button
        ]
            .forEach { baseView.addSubview($0) }
        
        [
            nicknameLabel,
            nicknameSubtitle,
            nicknameTextField,
            duplicationCheckButton
        ]
            .forEach { nicknameBlock.addSubview($0) }
        
        self.setupNicknameBlock()
    }
    
    
    private func setConstraints() {
        baseView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
        
        profileImage.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.size.equalTo(64)
        }
        
        nicknameBlock.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview()
        }
        
        jobSelectionBlock.snp.makeConstraints {
            $0.top.equalTo(nicknameBlock.snp.bottom).offset(42)
            $0.leading.trailing.equalToSuperview()
        }
        
        categorySelectionBlock.snp.makeConstraints {
            $0.top.equalTo(jobSelectionBlock.snp.bottom).offset(41)
            $0.leading.trailing.equalToSuperview()
        }
        
        button.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-38)
            $0.height.equalTo(48)
        }
    }
    
    private func setupNicknameBlock() {
        nicknameLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        nicknameSubtitle.snp.makeConstraints {
            $0.leading.equalTo(nicknameLabel.snp.trailing).offset(4)
            $0.centerY.equalTo(nicknameLabel)
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
}
