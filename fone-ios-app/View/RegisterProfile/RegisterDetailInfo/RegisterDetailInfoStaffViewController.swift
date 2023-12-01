//
//  RegisterDetailInfoStaffViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/28/23.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxRelay

class RegisterDetailInfoStaffViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: RegisterDetailInfoStaffViewModel!
    var disposeBag = DisposeBag()
    
    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
    }
    
    private let stepIndicator = StepIndicator(index: 1, totalCount: 4)
    
    private let titleLabel = UILabel().then {
        $0.text = "상세 정보를 입력해주세요"
        $0.font = .font_b(19)
        $0.textColor = .violet_362C4C
        $0.numberOfLines = 0
    }
    
    // 출생연도
    private let birthBlock = UIView()
    private let birthLabel = UILabel().then {
        $0.text = "출생연도"
        $0.font = .font_b(16)
        $0.textColor = .gray_161616
    }
    
    private let birthRequiredStar = UIImageView(image: UIImage(named: "star"))
    
    private let birthTextField = DefaultTextField(placeholder: "YYYY-MM-DD", height: 44)
    
    private let genderIrrelevantButton = CustomButton("성별무관", type: .clear).then {
        $0.isActivated = false
    }
    
    private let maleButton = CustomButton("남자", type: .auth).then {
        $0.isActivated = false
    }
    
    private let femaleButton = CustomButton("여자", type: .auth).then {
        $0.isActivated = false
    }
    
    // 이메일
    private let emailBlock = LabelTextField(
        label: "이메일",
        placeholder: "이메일 주소",
        textFieldHeight: 44,
        isRequired: true
    )
    
    // 분야
    private let fieldBlock = UIView()
    
    private let fieldLabel = UILabel().then {
        $0.text = "분야"
        $0.font = .font_b(16)
        $0.textColor = .gray_161616
    }
    
    private let fieldRequiredStar = UIImageView(image: UIImage(named: "star"))
    
    private let fieldContentView = UIView().then {
        $0.cornerRadius = 5
        $0.borderWidth = 1
        $0.borderColor = .gray_EEEFEF
    }
    
    private let fieldContentButton = UIButton()
    
    // 특기
    private let specialtyBlock = LabelTextField(
        label: "특기",
        placeholder: "나의 특기를 추가해보세요.",
        textFieldHeight: 44,
        isRequired: false
    )
    
    // SNS
    private let snsBlock = UIView()
    
    private let snsLabel = UILabel().then {
        $0.text = "SNS"
        $0.font = .font_b(16)
        $0.textColor = .gray_161616
    }
    
    private let instagramButton = UIButton().then {
        $0.setImage(UIImage(named: "instagram_but_g"), for: .normal)
        $0.setImage(UIImage(named: "instagram_but_c"), for: .selected)
    }
    
    private let youtubeButton = UIButton().then {
        $0.setImage(UIImage(named: "youtube_but_g"), for: .normal)
        $0.setImage(UIImage(named: "youtube_but_c"), for: .selected)
    }
    
    private let nextButton = CustomButton("다음", type: .bottom)
    
    func bindViewModel() {
        setNavigationBar()
        
        birthTextField.rx.text.map {
            $0?.birthFormatted()
        }
            .bind(to: birthTextField.rx.text)
            .disposed(by: rx.disposeBag)
        
        viewModel.instagramLink
            .withUnretained(self)
            .bind { owner, link in
                guard let link = link else { return }
                if link.isEmpty == false {
                    owner.instagramButton.isSelected = true
                } else {
                    owner.instagramButton.isSelected = false
                }
            }.disposed(by: disposeBag)
        
        viewModel.youtubeLink
            .withUnretained(self)
            .bind { owner, link in
                guard let link = link else { return }
                if link.isEmpty == false {
                    owner.youtubeButton.isSelected = true
                } else {
                    owner.youtubeButton.isSelected = false
                }
            }.disposed(by: disposeBag)
        
        // Buttons
        genderIrrelevantButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                let isIrrelevant = !owner.genderIrrelevantButton.isActivated
                
                owner.genderIrrelevantButton.isActivated = isIrrelevant
                owner.maleButton.isActivated = isIrrelevant
                owner.femaleButton.isActivated = isIrrelevant
            }.disposed(by: rx.disposeBag)
        
        maleButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.maleButton.isActivated = !owner.maleButton.isActivated
                
                if owner.maleButton.isActivated == false {
                    owner.genderIrrelevantButton.isActivated = false
                } else {
                    owner.checkAllActivated()
                }
//                owner.viewModel.gender = .MAN
            }.disposed(by: rx.disposeBag)
        
        femaleButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.femaleButton.isActivated = !owner.femaleButton.isActivated
                
                if owner.femaleButton.isActivated == false {
                    owner.genderIrrelevantButton.isActivated = false
                } else {
                    owner.checkAllActivated()
                }
//                owner.viewModel.gender = .WOMAN
            }.disposed(by: rx.disposeBag)
        
        fieldContentButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                print("clicked")
//                owner.present(<#T##viewControllerToPresent: UIViewController##UIViewController#>, animated: <#T##Bool#>)
            }.disposed(by: rx.disposeBag)
        
        instagramButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                let bottomSheet = SNSBottomSheet(type: .instagram, link: owner.viewModel.instagramLink)
                owner.presentPanModal(view: bottomSheet)
            }.disposed(by: rx.disposeBag)
        
        youtubeButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                    let bottomSheet = SNSBottomSheet(type: .youtube, link: owner.viewModel.youtubeLink)
                    owner.presentPanModal(view: bottomSheet)
            }.disposed(by: rx.disposeBag)
        
        nextButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.viewModel.moveToRegisterDetailContent()
            }.disposed(by: rx.disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setConstraints()
        
    }
    
    private func setNavigationBar() {
        navigationItem.titleView = NavigationTitleView(title: "스태프 등록하기")
        navigationItem.leftBarButtonItem = NavigationLeftBarButtonItem(
            type: .back,
            viewController: self
        )
    }
    
    private func setupUI() {
        view.backgroundColor = .white_FFFFFF
        
        [
            stepIndicator,
            titleLabel,
            stackView,
            snsBlock,
            nextButton
        ]
            .forEach { view.addSubview($0) }
        
        [
            birthBlock,
            emailBlock,
            fieldBlock,
            specialtyBlock
        ]
            .forEach { stackView.addArrangedSubview($0) }
        
        [
            birthLabel,
            birthRequiredStar,
            birthTextField,
            genderIrrelevantButton,
            maleButton,
            femaleButton
        ]
            .forEach { birthBlock.addSubview($0) }
        self.setupBirthBlock()
        
        [
            fieldLabel,
            fieldRequiredStar,
            fieldContentView,
            fieldContentButton
        ]
            .forEach { fieldBlock.addSubview($0) }
        setupFieldBlock()
        
        [
            snsLabel,
            instagramButton,
            youtubeButton
        ]
            .forEach { snsBlock.addSubview($0) }
        setupSNSBlock()
    }
    
    private func setConstraints() {
        stepIndicator.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.leading.equalToSuperview().offset(16)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(stepIndicator.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        snsBlock.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(stackView)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(stackView)
            $0.bottom.equalToSuperview().offset(-38)
            $0.height.equalTo(48)
        }
    }
    
    private func setupBirthBlock() {
        birthLabel.snp.makeConstraints {
            $0.centerY.equalTo(genderIrrelevantButton)
            $0.leading.equalToSuperview()
        }
        
        birthRequiredStar.snp.makeConstraints {
            $0.centerY.equalTo(birthLabel)
            $0.leading.equalTo(birthLabel.snp.trailing).offset(2)
        }
        
        birthTextField.snp.makeConstraints {
            $0.top.equalTo(birthLabel.snp.bottom).offset(8)
            $0.leading.bottom.equalToSuperview()
        }
        
        genderIrrelevantButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.width.equalTo(72)
            $0.height.equalTo(24)
        }
        
        maleButton.snp.makeConstraints {
            $0.top.bottom.equalTo(birthTextField)
            $0.leading.equalTo(birthTextField.snp.trailing).offset(6)
            $0.width.equalTo(58)
        }
        
        femaleButton.snp.makeConstraints {
            $0.top.bottom.equalTo(birthTextField)
            $0.leading.equalTo(maleButton.snp.trailing).offset(6)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(58)
        }
    }
    
    private func setupFieldBlock() {
        fieldLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        fieldLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        fieldRequiredStar.snp.makeConstraints {
            $0.centerY.equalTo(fieldLabel)
            $0.leading.equalTo(fieldLabel.snp.trailing).offset(2)
            $0.size.equalTo(8)
        }
        
        fieldContentView.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.height.equalTo(44)
            $0.leading.equalTo(fieldRequiredStar.snp.trailing).offset(24)
        }
        
        fieldContentButton.snp.makeConstraints {
            $0.edges.equalTo(fieldContentView)
        }
        
    }
    
    private func setupSNSBlock() {
        snsLabel.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
        }
        
        instagramButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(62)
            $0.size.equalTo(40)
        }
        
        youtubeButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(instagramButton.snp.trailing).offset(8)
            $0.size.equalTo(40)
        }
        
        
    }
    
    private func checkAllActivated() {
        if maleButton.isActivated && femaleButton.isActivated {
            genderIrrelevantButton.isActivated = true
        }
    }
}
