//
//  RegisterContactLinkInfoViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 2/20/24.
//

import UIKit
import Then
import SnapKit
import RxSwift

class RegisterContactLinkInfoViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: RegisterContactLinkInfoViewModel!
    var disposeBag = DisposeBag()
    
    private let stepIndicator = StepIndicator(index: 0, totalCount: 6)
    
    private let titleLabel = UILabel().then {
        $0.text = "연락할 방법의 링크를 남겨주세요"
        $0.font = .font_b(19)
        $0.textColor = .violet_362C4C
    }
    
    private let descriptionLabel = UILabel().then {
        $0.text = "연락을 받을 수단으로 정확한 정보를 입력해주세요."
        $0.font = .font_m(12)
        $0.textColor = .gray_C5C5C5
    }
    
    private let contactTypeLabel = UILabel().then {
        $0.text = "연락방법"
        $0.font = .font_b(16)
        $0.textColor = .gray_161616
    }
    
    private let starImageView = UIImageView().then {
        $0.image = UIImage(named: "star")
    }
    
    private let contactTypeView = ContactTypeView(text: "카카오 오픈채팅")
    
    private let textField = DefaultTextField(
        placeholder: "링크를 첨부할 수 있어요",
        height: 44
    ).then {
        $0.setLeadingPadding(12)
    }
    
    private let nextButton = CustomButton("등록하기", type: .bottom).then {
        $0.applyShadow(shadowType: .shadowBt)
    }
    
    func bindViewModel() {
        setNavigationBar() // viewModel 바인딩 된 후 navigationBar의 title
        
        // Buttons
        nextButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                // FIXME: 유효성 검증 API 호출
//                owner.viewModel.validate()
                owner.viewModel.moveToRegisterBasicInfo()
            }.disposed(by: rx.disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setConstraints()
        
    }
    
    private func setNavigationBar() {
        navigationItem.titleView = NavigationTitleView(title: "\(viewModel.jobType?.koreanName ?? "") 등록하기")
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
            descriptionLabel,
            contactTypeLabel,
            starImageView,
            contactTypeView,
            textField,
            nextButton
        ]
            .forEach { view.addSubview($0) }
    }
    
    private func setConstraints() {
        stepIndicator.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            $0.leading.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(stepIndicator.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        contactTypeLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(22)
            $0.leading.equalTo(titleLabel.snp.leading)
        }
        
        starImageView.snp.makeConstraints {
            $0.centerY.equalTo(contactTypeLabel)
            $0.leading.equalTo(contactTypeLabel.snp.trailing).offset(2)
            $0.size.equalTo(8)
        }
        
        contactTypeView.snp.makeConstraints {
            $0.leading.equalTo(starImageView.snp.trailing).offset(28)
            $0.height.equalTo(44)
            $0.centerY.equalTo(starImageView)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        textField.snp.makeConstraints {
            $0.top.equalTo(contactTypeLabel.snp.bottom).offset(22)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-38)
            $0.height.equalTo(48)
        }
    }
}

