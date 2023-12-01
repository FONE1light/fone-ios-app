//
//  RegisterDetailContentViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/26/23.
//

import UIKit
import Then
import SnapKit
import RxSwift

class RegisterDetailContentViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: RegisterDetailContentViewModel!
    var disposeBag = DisposeBag()
    
    private let stepIndicator = StepIndicator(index: 2, totalCount: 5)
    
    private let titleLabel = UILabel().then {
        $0.text = "상세 요강을 입력해주세요"
        $0.font = .font_b(19)
        $0.textColor = .violet_362C4C
    }
    
    private let detailContentLabel = UILabel().then {
        $0.text = "상세요강"
        $0.font = .font_b(16)
        $0.textColor = .gray_161616
    }
    
    private let starImageView = UIImageView().then {
        $0.image = UIImage(named: "star")
    }
    
    private let descriptionLabel = UILabel().then {
        $0.text = "본인의 경험을 기반으로 핵심역량과 강점, 목표, 관심분야 등을 간단히 작성해주세요."
        $0.font = .font_m(12)
        $0.textColor = .gray_C5C5C5
        $0.numberOfLines = 0
    }
    
    private let letterCountedTextView = LetterCountedTextView(
        placeholder: "배우 프로필에 올릴 게시글 내용을 작성해주세요. 부적절한 내용이 포함된 게시글은 게시가 제한될 수 있어요.",
        textViewHeight: 172,
        maximumLetterCount: 200
    )
    
    private let nextButton = CustomButton("다음", type: .bottom).then {
        $0.applyShadow(shadowType: .shadowBt)
    }
    
    func bindViewModel() {
        setNavigationBar() // viewModel 바인딩 된 후 navigationBar의 title 설정
        
        // Buttons
        nextButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.viewModel.moveToRegisterCareer()
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
            detailContentLabel,
            starImageView,
            descriptionLabel,
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
        
        detailContentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(16)
        }
        
        starImageView.snp.makeConstraints {
            $0.centerY.equalTo(detailContentLabel)
            $0.leading.equalTo(detailContentLabel.snp.trailing).offset(2)
            $0.size.equalTo(8)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(detailContentLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        letterCountedTextView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-38)
            $0.height.equalTo(48)
        }
    }
}

