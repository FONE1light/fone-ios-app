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
        $0.cornerRadius = 32
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill // 정확한 원이 되게 하기 위함
    }
    private let imagePickerViewController = UIImagePickerController()
    private let profileButton = UIButton()
    
    let nicknameBlock = UIView()
    
    private let nicknameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = .font_b(15)
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
        $0.selectionLimits = 1
    }
    
    let categorySelectionBlock = SelectionBlock().then {
        $0.setTitle("관심사 선택")
        $0.setSubtitle("(중복 선택 가능)")
        $0.setSelections(Category.allCases)
    }
    
    let button = CustomButton("수정하기", type: .bottom)
    
    
    let baseView = UIView()
    
    func bindViewModel() {
        viewModel.previousProfile
            .withUnretained(self)
            .bind { owner, profile in
                owner.loadPreviousProfile(profile)
            }.disposed(by: disposeBag)
        
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
        
        viewModel.profileUrlRelay
            .withUnretained(self)
            .bind { owner, imageUrl in
                owner.setProfileImage(imageUrl)
            }.disposed(by: disposeBag)
        
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
        
        
        profileButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.showActionSheet()
            }.disposed(by: rx.disposeBag)
        
        button.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                guard let interests = owner.categorySelectionBlock.selectedItems.value as? [Category] else { return }
                let stringInterest = interests.map { $0.serverName }
                
                guard let jobs = owner.jobSelectionBlock.selectedItems.value as? [Job] else { return }
                let stringJob = jobs.first?.serverName
                
                let userInfo = UserInfo(
                    interests: stringInterest,
                    job: stringJob,
                    nickname: owner.nicknameTextField.text,
                    profileURL: owner.viewModel.profileUrlRelay.value ?? ""
                )
                owner.viewModel.modifyInfo(userInfo)
            }.disposed(by: rx.disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white_FFFFFF
        setNavigationBar()
        setUI()
        setConstraints()
    }
    
    private func loadPreviousProfile(_ profile: User?) {
        guard let profile = profile else { return }
        
        viewModel.profileUrlRelay.accept(profile.profileURL)
        nicknameTextField.text = profile.nickname
        guard let job = Job.getType(name: profile.job) else { return }
        jobSelectionBlock.select(items: [job])
        
        let interests = profile.interests?.compactMap { Category.getType(serverName: $0) }
        guard let categories = interests else { return }
        categorySelectionBlock.select(items: categories)
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
            profileButton,
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
        
        profileButton.snp.makeConstraints {
            $0.edges.equalTo(profileImage)
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

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
            self.viewModel.profileUrlRelay.accept(nil)
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
        if let pickedImage = info[.originalImage] as? UIImage {
            viewModel.uploadProfileImage(pickedImage)
        }
        
        imagePickerViewController.dismiss(animated: true, completion: nil)
    }
    
    private func setProfileImage(_ stringUrl: String?) {
        guard let url = stringUrl, !url.isEmpty else {
            profileImage.image = UIImage(named: "profileImage")
            profileImage.cornerRadius = 0
            return
        }
        profileImage.load(url: url)
        profileImage.cornerRadius = profileImage.frame.width / 2
    }
}
