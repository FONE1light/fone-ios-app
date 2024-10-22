//
//  RegisterInterestViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/28/23.
//

import UIKit
import Then
import SnapKit
import RxSwift

class RegisterInterestViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: RegisterInterestViewModel!
    var disposeBag = DisposeBag()
    
    private let stepIndicator = StepIndicator(index: 5, totalCount: 6)
    
    private let titleLabel = UILabel().then {
        $0.text = "관심사를 선택해 주세요"
        $0.font = .font_b(19)
        $0.textColor = .violet_362C4C
    }
    
    private let selectAllButton = CustomButton("전체선택", type: .clear).then {
        $0.isActivated = false
    }
    
    private let selectionBlock = SelectionBlock().then {
        $0.setSelections(Category.allCases)
    }
    
    private let nextButton = CustomButton("등록하기", type: .bottom).then {
        $0.applyShadow(shadowType: .shadowBt)
    }
    
    func bindViewModel() {
        setNavigationBar() // viewModel 바인딩 된 후 navigationBar의 title 설정
        
        selectionBlock.selectedItems
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .bind { owner, items in
                guard let categories = items as? [Category] else { return }
                guard !categories.isEmpty else { return } // 선택 해제한 경우나 deselectAll()의 경우 추가 작업 X
                
                if categories.count == Category.allCases.count {
                    owner.selectAllButton.isActivated = true
                    owner.selectionBlock.deselectAll()
                } else {
                    owner.selectAllButton.isActivated = false
                }
            }.disposed(by: disposeBag)
        
        // Buttons
        selectAllButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                guard !owner.selectAllButton.isActivated else { return }
                owner.selectAllButton.isActivated = true
                owner.selectionBlock.deselectAll()
            }.disposed(by: rx.disposeBag)
        
        nextButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                var categories: [Category] = []
                if owner.selectAllButton.isActivated {
                    categories = Category.allCases
                } else {
                    categories = owner.selectionBlock.selectedItems.value as? [Category] ?? []
                }
                let stringCategories = categories.map { $0.serverName }
                owner.viewModel.validate(categories: stringCategories)
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
            selectAllButton,
            selectionBlock,
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
        
        selectAllButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(72)
            $0.height.equalTo(24)
        }
        
        selectionBlock.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-38)
            $0.height.equalTo(48)
        }
    }
}
