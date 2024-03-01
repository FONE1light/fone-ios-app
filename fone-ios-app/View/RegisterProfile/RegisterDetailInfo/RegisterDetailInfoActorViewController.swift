//
//  RegisterDetailInfoActorViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/19/23.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxRelay

class RegisterDetailInfoActorViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: RegisterDetailInfoActorViewModel!
    var disposeBag = DisposeBag()
    
    private var gender: GenderType = .IRRELEVANT
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
    }
    
    private let stepIndicator = StepIndicator(index: 2, totalCount: 6)
    
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
    
    // 신장, 체중
    private let heightWeightStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 32
        $0.distribution = .fillEqually
    }
    
    private let heightBlock = LabelTextField(
        label: "신장",
        placeholder: "",
        textFieldHeight: 44,
        isRequired: true,
        maximumLetterCount: 3,
        textFieldLeadingOffset: 50,
        textFieldKeyboardType: .numberPad
    ).then {
        $0.setTrailingPadding(34)
        $0.setTextAlignment(.right)
    }
    
    private let cmLabel = UILabel().then {
        $0.text = "cm"
        $0.font = .font_r(14)
        $0.textColor = .gray_9E9E9E
    }
    
    private let weightBlock = LabelTextField(
        label: "체중",
        placeholder: "",
        textFieldHeight: 44,
        isRequired: true,
        maximumLetterCount: 3,
        textFieldLeadingOffset: 50,
        textFieldKeyboardType: .numberPad
    ).then {
        $0.setTrailingPadding(29)
        $0.setTextAlignment(.right)
    }
    
    private let kgLabel = UILabel().then {
        $0.text = "kg"
        $0.font = .font_r(14)
        $0.textColor = .gray_9E9E9E
    }
    
    // 이메일
    private let emailBlock = LabelTextField(
        label: "이메일",
        placeholder: "이메일 주소",
        textFieldHeight: 44,
        isRequired: true
    )
    
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
    
    private let instagramImageView = SNSImageView(type: .instagram)
    private let youtubeImageView = SNSImageView(type: .youtube)
    
    private let instagramTextField = DefaultTextField(
        placeholder: "인스타그램 링크를 첨부할 수 있어요.",
        height: 44
    )
    
    private let youtubeTextField = DefaultTextField(
        placeholder: "유튜브 링크를 첨부할 수 있어요.",
        height: 44
    )
    
    private let nextButton = CustomButton("다음", type: .bottom).then {
            $0.applyShadow(shadowType: .shadowBt)
    }
    
    func bindViewModel() {
        birthTextField.rx.text.map {
            $0?.birthFormatted()
        }
            .bind(to: birthTextField.rx.text)
            .disposed(by: rx.disposeBag)
        
        instagramTextField.rx.text
            .withUnretained(self)
            .bind { owner, link in
                guard let link = link else { return }
                if link.isEmpty == false {
                    owner.instagramImageView.isSelected = true
                } else {
                    owner.instagramImageView.isSelected = false
                }
            }.disposed(by: disposeBag)
        
        youtubeTextField.rx.text
            .withUnretained(self)
            .bind { owner, link in
                guard let link = link else { return }
                if link.isEmpty == false {
                    owner.youtubeImageView.isSelected = true
                } else {
                    owner.youtubeImageView.isSelected = false
                }
            }.disposed(by: disposeBag)
        
        // Buttons
        // TODO: 성별 선택 로직 확인 및 수정
        genderIrrelevantButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                let isIrrelevant = !owner.genderIrrelevantButton.isActivated
                
                owner.genderIrrelevantButton.isActivated = isIrrelevant
                owner.maleButton.isActivated = isIrrelevant
                owner.femaleButton.isActivated = isIrrelevant
                
                if isIrrelevant {
                    owner.gender = .IRRELEVANT
                }
            }.disposed(by: rx.disposeBag)
        
        maleButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.maleButton.isActivated = !owner.maleButton.isActivated
                
                if owner.maleButton.isActivated == false {
                    owner.genderIrrelevantButton.isActivated = false
                } else {
                    owner.checkAllActivated()
                    owner.gender = .MAN
                }
            }.disposed(by: rx.disposeBag)
        
        femaleButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.femaleButton.isActivated = !owner.femaleButton.isActivated
                
                if owner.femaleButton.isActivated == false {
                    owner.genderIrrelevantButton.isActivated = false
                } else {
                    owner.checkAllActivated()
                    owner.gender = .WOMAN
                }
            }.disposed(by: rx.disposeBag)
        
        nextButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                let instagramUrl = SnsURL(sns: "INSTAGRAM", url: owner.instagramTextField.text)
                let youtubeUrl = SnsURL(sns: "YOUTUBE", url: owner.youtubeTextField.text)

                let height = Int(owner.heightBlock.textField?.text ?? "")
                let weight = Int(owner.weightBlock.textField?.text ?? "")
                
                let detailInfoRequest = RegisterDetailInfo(
                    birthday: owner.birthTextField.text,
                    gender: owner.gender.serverName,
                    height: height,
                    weight: weight,
                    email: owner.emailBlock.textField?.text,
                    domains: nil,
                    specialty: owner.specialtyBlock.textField?.text,
                    snsUrls: [instagramUrl, youtubeUrl]
                )
                owner.viewModel.validate(detailInfoRequest: detailInfoRequest)
            }.disposed(by: rx.disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setupUI()
        setConstraints()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name:UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    private func setNavigationBar() {
        navigationItem.titleView = NavigationTitleView(title: "배우 등록하기")
        navigationItem.leftBarButtonItem = NavigationLeftBarButtonItem(
            type: .back,
            viewController: self
        )
    }
    
    private func setupUI() {
        view.backgroundColor = .white_FFFFFF
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [
            stepIndicator,
            titleLabel,
            stackView,
            snsBlock
        ]
            .forEach { contentView.addSubview($0) }
        
        view.addSubview(nextButton)
        
        
        [
            birthBlock,
            heightWeightStackView,
            emailBlock,
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
            heightBlock,
            weightBlock
        ]
            .forEach { heightWeightStackView.addArrangedSubview($0) }
        
        heightBlock.addSubview(cmLabel)
        weightBlock.addSubview(kgLabel)
        
        [
            snsLabel,
            instagramImageView,
            instagramTextField,
            youtubeImageView,
            youtubeTextField
        ]
            .forEach { snsBlock.addSubview($0) }
        setupSNSBlock()
    }
    
    private func setConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.edges.equalTo(scrollView.contentLayoutGuide)
        }
        
        stepIndicator.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
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
    
        cmLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
        }
        
        kgLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
        }
        
        snsBlock.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(30)
            $0.leading.trailing.equalTo(stackView)
            $0.bottom.equalToSuperview()
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
    
    private func setupSNSBlock() {
        snsLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        instagramImageView.snp.makeConstraints {
            $0.top.equalTo(snsLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview()
            $0.size.equalTo(44)
        }
        
        instagramTextField.snp.makeConstraints {
            $0.top.bottom.equalTo(instagramImageView)
            $0.leading.equalTo(instagramImageView.snp.trailing).offset(6)
            $0.trailing.equalToSuperview()
        }
        
        youtubeImageView.snp.makeConstraints {
            $0.top.equalTo(instagramImageView.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
            $0.size.equalTo(44)
            $0.bottom.equalToSuperview()
        }
        
        youtubeTextField.snp.makeConstraints {
            $0.top.bottom.equalTo(youtubeImageView)
            $0.leading.equalTo(youtubeImageView.snp.trailing).offset(6)
            $0.trailing.equalToSuperview()
        }
    }
    
    private func checkAllActivated() {
        if maleButton.isActivated && femaleButton.isActivated {
            genderIrrelevantButton.isActivated = true
        }
    }
}

extension RegisterDetailInfoActorViewController {
    @objc func keyboardWillAppear(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        let keyboardFrameEnd = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardHeightEnd = keyboardFrameEnd.height
        
        var contentInset = self.scrollView.contentInset
        contentInset.bottom = keyboardHeightEnd
        scrollView.contentInset = contentInset
    }

    @objc func keyboardWillDisappear(notification: NSNotification) {
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
}
