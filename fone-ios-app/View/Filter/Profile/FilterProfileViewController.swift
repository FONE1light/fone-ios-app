//
//  FilterProfileViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 4/19/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class FilterProfileViewController: UIViewController, ViewModelBindableType {
    var viewModel: FilterProfileViewModel!
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var genderClearButton: CustomButton!
    @IBOutlet weak var genderSelectionBlock: SelectionBlock!
    @IBOutlet weak var ageClearButton: CustomButton!
    @IBOutlet weak var ageSelectionView: AgeSelectionView!
    @IBOutlet weak var categoryClearButton: CustomButton!
    @IBOutlet weak var categorySelectionBlock: SelectionBlock!
    
    private let domainLabel = UILabel().then {
        $0.text = "분야"
        $0.font = .font_b(15)
    }
    private let domainClearButton = CustomButton("전체선택", type: .clear)
    
    private let domainSelectionView = DomainSelectionView(
        width: UIScreen.main.bounds.width - 16 * 2
    )
    
    @IBOutlet weak var confirmButton: CustomButton!

    private let selectedGenders = BehaviorSubject<[GenderType]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupDefaults()
    }
    
    func bindViewModel() {
        resetButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.genderSelectionBlock.selectedItems.accept(GenderType.allCases)
                owner.ageSelectionView.selectedItems.accept(FilterAge.allCases)
                owner.categorySelectionBlock.selectedItems.accept(Category.allCases)
            }.disposed(by: rx.disposeBag)
        
        closeButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.viewModel.sceneCoordinator.close(animated: true)
            }.disposed(by: rx.disposeBag)
        
        confirmButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                guard let genders = owner.genderSelectionBlock.selectedItems.value as? [GenderType],
                      let ages = owner.ageSelectionView.selectedItems.value as? [FilterAge],
                      let categories = owner.categorySelectionBlock.selectedItems.value as? [Category],
                      let domains = owner.domainSelectionView.selectedItems.value as? [Domain] else { return }
                
                let filterOptions = FilterOptions(genders: genders, ages: ages, categories: categories, domains: domains)
                owner.viewModel.applyFilter(filterOptions)
                owner.viewModel.sceneCoordinator.close(animated: true)
            }.disposed(by: rx.disposeBag)
        
        // SelectionBlocks
        // 성별
        genderSelectionBlock.selectedItems
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .bind { owner, items in
                guard let genders = items as? [GenderType] else { return }
                guard !genders.isEmpty else { return } // 선택 해제한 경우나 deselectAll()의 경우 추가 작업 X
                
                if genders.count == GenderType.allCases.count {
                    owner.genderClearButton.isActivated = true
                    owner.genderSelectionBlock.deselectAll()
                } else {
                    owner.genderClearButton.isActivated = false
                }
            }.disposed(by: disposeBag)
        
        genderClearButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                guard !owner.genderClearButton.isActivated else { return }
                owner.genderClearButton.isActivated = true
                owner.genderSelectionBlock.deselectAll()
            }.disposed(by: rx.disposeBag)
        
          // 나이
        ageSelectionView.selectedItems
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .bind { owner, items in
                guard let ages = items as? [FilterAge] else { return }
                guard !ages.isEmpty else { return } // 선택 해제한 경우나 deselectAll()의 경우 추가 작업 X
                
                if ages.count == FilterAge.allCases.count {
                    owner.ageClearButton.isActivated = true
                    owner.ageSelectionView.deselectAll()
                } else {
                    owner.ageClearButton.isActivated = false
                }
            }.disposed(by: disposeBag)
        
        ageClearButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                guard !owner.ageClearButton.isActivated else { return }
                owner.ageClearButton.isActivated = true
                owner.ageSelectionView.deselectAll()
            }.disposed(by: rx.disposeBag)
        
        // 관심사 선택
        categorySelectionBlock.selectedItems
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .bind { owner, items in
                guard let categories = items as? [Category] else { return }
                guard !categories.isEmpty else { return } // 선택 해제한 경우나 deselectAll()의 경우 추가 작업 X
                
                if categories.count == Category.allCases.count {
                    owner.categoryClearButton.isActivated = true
                    owner.categorySelectionBlock.deselectAll()
                } else {
                    owner.categoryClearButton.isActivated = false
                }
            }.disposed(by: disposeBag)
        
        categoryClearButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                guard !owner.categoryClearButton.isActivated else { return }
                owner.categoryClearButton.isActivated = true
                owner.categorySelectionBlock.deselectAll()
            }.disposed(by: rx.disposeBag)
        
        // 분야
        domainSelectionView.selectedItems
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .bind { owner, items in
                guard let domains = items as? [Domain] else { return }
                guard !domains.isEmpty else { return } // 선택 해제한 경우나 deselectAll()의 경우 추가 작업 X
                
                if domains.count == Domain.allCases.count {
                    owner.domainClearButton.isActivated = true
                    owner.domainSelectionView.deselectAll()
                } else {
                    owner.domainClearButton.isActivated = false
                }
            }.disposed(by: disposeBag)
        
        domainClearButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                guard !owner.domainClearButton.isActivated else { return }
                owner.domainClearButton.isActivated = true
                owner.domainSelectionView.deselectAll()
            }.disposed(by: rx.disposeBag)
    }
    
    private func setupUI() {
        [
            domainLabel,
            domainClearButton,
            domainSelectionView
        ]
            .forEach { contentView.addSubview($0) }
        
        genderClearButton.xibInit("전체선택", type: .clear)
        ageClearButton.xibInit("연령무관", type: .clear)
        categoryClearButton.xibInit("전체선택", type: .clear)
        confirmButton.xibInit("보러가기", type: .bottom)
        
        genderSelectionBlock.setSelections(GenderType.allCases)
        let width = UIScreen.main.bounds.width - 16 * 2
        let filterOptions = try? viewModel.filterOptionsSubject.value()
        ageSelectionView.xibInit(of: FilterAge.allCases, width: width, selectedItems: filterOptions?.ages)
        categorySelectionBlock.setSelections(Category.allCases)
        
        genderClearButton.isActivated = true
        ageClearButton.isActivated = true
        categoryClearButton.isActivated = true
        domainClearButton.isActivated = true
    }
    
    private func setConstraints() {
        domainLabel.snp.makeConstraints {
            $0.top.equalTo(categorySelectionBlock.snp.bottom).offset(32)
            $0.leading.equalTo(categorySelectionBlock.snp.leading)
        }
        
        domainClearButton.snp.makeConstraints {
            $0.centerY.equalTo(domainLabel)
            $0.trailing.equalTo(categorySelectionBlock.snp.trailing)
            $0.size.equalTo(categoryClearButton)
        }
        
        domainSelectionView.snp.makeConstraints {
            $0.top.equalTo(domainLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(categorySelectionBlock)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func setupDefaults() {
        guard let filterOptions = try? viewModel.filterOptionsSubject.value() else { return }
        genderSelectionBlock.select(items: filterOptions.genders)
        categorySelectionBlock.select(items: filterOptions.categories)
        domainSelectionView.select(items: filterOptions.domains ?? [])
    }
}

