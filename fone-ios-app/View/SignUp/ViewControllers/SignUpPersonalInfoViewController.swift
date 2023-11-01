//
//  SignUpPersonalInfoViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/02.
//

import UIKit
import Then
import RxSwift

class SignUpPersonalInfoViewController: UIViewController, ViewModelBindableType {

    var disposeBag = DisposeBag()
    var viewModel: SignUpPersonalInfoViewModel!
    
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
        $0.font = .font_b(15)
        $0.textColor = .gray_161616
    }
    
    private let nicknameTextField = DefaultTextField(placeHolder: "3~8자리의 숫자, 영어, 한글만 가능합니다")
    
    private let duplicatedWarningLabel = UILabel().then {
        $0.text = "중복되는 닉네임입니다."
        $0.font = .font_r(12)
        $0.textColor = .crimson_FF5841
    }
    
    private let duplicationCheckButton = CustomButton("중복확인", type: .auth)
    
    let birthBlock = UIView()
    
    private let birthLabel = UILabel().then {
        $0.text = "생년월일 및 성별 *"
        $0.font = .font_b(15)
        $0.textColor = .gray_161616
    }
    
    private let birthSubtitleLabel = UILabel().then {
        $0.text = "성별과 생년월일의 정보는 변경이 불가능합니다."
        $0.font = .font_r(12)
        $0.textColor = .gray_9E9E9E
    }
    
    private let birthTextField = DefaultTextField(placeHolder: "YYYY-MM-DD")
    
    private let maleButton = CustomButton("남자", type: .auth).then {
        $0.isActivated = false
    }
    
    private let femaleButton = CustomButton("여자", type: .auth).then {
        $0.isActivated = false
    }
    
    let profileBlock = UIView()
    
    private let profileLabel = UILabel().then {
        $0.text = "프로필 사진 등록"
        $0.font = .font_b(15)
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
    
    private let imagePickerViewController = UIImagePickerController()
    
    private let profileButton = UIButton()
    
    private let button = CustomButton("다음", type: .bottom)
    
    func bindViewModel() {
        // TextFields
        nicknameTextField.rx.controlEvent(.editingChanged)
            .withUnretained(self)
            .bind { owner, _ in
                let formattedNickname = owner.viewModel.formatNickname(owner.nicknameTextField.text)
                owner.nicknameTextField.text = formattedNickname
                owner.viewModel.checkNicknameAvailbleState(formattedNickname)
            }.disposed(by: rx.disposeBag)
        
        birthTextField.rx.controlEvent(.editingChanged)
            .withUnretained(self)
            .bind { owner, _ in
                let formattedBirth = owner.viewModel.formatBirthString(owner.birthTextField.text)
                owner.birthTextField.text = formattedBirth
                owner.viewModel.birthday = formattedBirth
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
                owner.maleButton.isActivated = !owner.maleButton.isActivated
                owner.femaleButton.isActivated = !owner.maleButton.isActivated
                owner.viewModel.gender = .MAN
            }.disposed(by: rx.disposeBag)
        
        femaleButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.femaleButton.isActivated = !owner.femaleButton.isActivated
                owner.maleButton.isActivated = !owner.femaleButton.isActivated
                owner.viewModel.gender = .WOMAN
            }.disposed(by: rx.disposeBag)
        
        profileButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.showActionSheet()
            }.disposed(by: rx.disposeBag)
        
        button.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.viewModel.moveToSignUpPhoneNumber()
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
                    owner.nicknameTextField.borderWidth = 0
                case .canCheck:
                    owner.duplicationCheckButton.setTitle("중복확인", for: .normal)
                    owner.duplicationCheckButton.isEnabled = true
                    owner.duplicatedWarningLabel.isHidden = true
                    owner.nicknameTextField.borderWidth = 0
                case .duplicated:
                    owner.duplicationCheckButton.setTitle("중복확인", for: .normal)
                    owner.duplicationCheckButton.isEnabled = false
                    owner.duplicatedWarningLabel.isHidden = false
                    owner.nicknameTextField.borderWidth = 1
                    owner.nicknameTextField.borderColor = .crimson_FF5841
                case .available:
                    owner.duplicationCheckButton.setTitle("인증완료", for: .normal)
                    owner.duplicationCheckButton.isEnabled = false
                    owner.duplicatedWarningLabel.isHidden = true
                    owner.nicknameTextField.borderWidth = 0
                }
            }.disposed(by: self.disposeBag)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setNavigationBar()
        setConstraints()
        
    }
    
    private func setNavigationBar() {
        self.navigationItem.titleView = NavigationTitleView(title: "회원가입")
        self.navigationItem.leftBarButtonItem = NavigationLeftBarButtonItem(
            type: .back,
            viewController: self
        )
    }
    
    private func setUI() {
        self.view.backgroundColor = .white_FFFFFF
        
        self.view.addSubview(baseView)
        
        baseView.addSubview(stackView)
        baseView.addSubview(duplicatedWarningLabel)
        baseView.addSubview(button)
        
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
            profileImage,
            profileButton
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
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(40)
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
        
        profileButton.snp.makeConstraints {
            $0.edges.equalTo(profileImage)
        }
    }
    
}

extension SignUpPersonalInfoViewController: UIImagePickerControllerDelegate {
    
    private func showActionSheet() {
        let chooseImage = UIAlertAction(
            title: "앨범에서 사진 선택",
            style: .default
        ) { _ in
            self.imagePickerViewController.delegate = self
            self.imagePickerViewController.sourceType = .photoLibrary
            self.present(self.imagePickerViewController, animated: true)
        }
        
        let changeToDefaultImage = UIAlertAction(
            title: "기본 이미지로 변경",
            style: .default
        ) { _ in
            self.profileImage.image = UIImage(named: "profileImage")
            self.viewModel.profileUrl = nil
        }
        
        let cancel = UIAlertAction(
            title: "취소",
            style: .cancel
        )
        
        let alert = UIAlertController(
            title: "프로필 사진 설정",
            message: nil,
            preferredStyle: .actionSheet
        )
        alert.addAction(chooseImage)
        alert.addAction(changeToDefaultImage)
        alert.addAction(cancel)
        
        self.present(alert, animated: true)
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        if let imageUrl = info[.imageURL] as? URL {
            print(imageUrl)
            viewModel.uploadProfileImage()
        }
        
        if let pickedImage = info[.originalImage] as? UIImage {
            profileImage.image = pickedImage
        }
        
        imagePickerViewController.dismiss(animated: true, completion: nil)
    }
}

extension SignUpPersonalInfoViewController: UINavigationControllerDelegate {}
