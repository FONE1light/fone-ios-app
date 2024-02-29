//
//  RegisterCareerViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/27/23.
//

import UIKit
import Then
import SnapKit
import RxSwift

class RegisterCareerViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: RegisterCareerViewModel!
    var disposeBag = DisposeBag()
    
    private let stepIndicator = StepIndicator(index: 4, totalCount: 6)
    
    private let titleLabel = UILabel().then {
        $0.text = "주요 경력을 입력해 주세요"
        $0.font = .font_b(19)
        $0.textColor = .violet_362C4C
    }
    
    private let descriptionLabel = UILabel().then {
        $0.text = "담당하신 업무의 역할과 성과를 선별하여 최신순으로 작성해주세요."
        $0.font = .font_m(12)
        $0.textColor = .gray_C5C5C5
        $0.numberOfLines = 0
    }
    
    private let letterCountedTextView = LetterCountedTextView(
        placeholder: "작품 참여 경험이나 맡은 역할을 자유롭게 알려주세요.",
        textViewHeight: 159,
        maximumLetterCount: 500
    )
    
    private let selectionBlock = CareerSelectionBlock().then {
        $0.selectItem(at: IndexPath(row: 0, section: 0) )
    }
    
    private let nextButton = CustomButton("다음", type: .bottom).then {
        $0.applyShadow(shadowType: .shadowBt)
    }
    
    func bindViewModel() {
        setNavigationBar() // viewModel 바인딩 된 후 navigationBar의 title 설정
        
        // Buttons
        nextButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                guard let career = owner.selectionBlock.selectedItem.value as? CareerType else { return }
                let careerDetail = owner.letterCountedTextView.text
                owner.viewModel.validate(career: career.rawValue, careerDetail: careerDetail)
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
            selectionBlock,
            letterCountedTextView,
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
        
        selectionBlock.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        letterCountedTextView.snp.makeConstraints {
            $0.top.equalTo(selectionBlock.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-38)
            $0.height.equalTo(48)
        }
    }
}

