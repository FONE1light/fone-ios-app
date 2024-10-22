//
//  CareerSelectionBlock.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/27/23.
//

import UIKit
import Then
import RxRelay
import RxSwift

/// 직업 or 관심사 선택 label + UICollectionView 영역
class CareerSelectionBlock: UIView {
    
    struct Constants {
        /// 가로에 꽉 차는 너비를 지정할 경우 collectionView 외부 여백
        static let leadingMargin: CGFloat = 16
        /// 한 행에 배치하는 cell의 개수
        static let numberOfItemsInARow: Int = 3
        /// cell 사이 여백
        static let minimumInteritemSpacing: CGFloat = 8
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .font_b(15)
    }
    
    private let subtitleLabel = UILabel().then {
        $0.font = .font_r(12)
        $0.textColor = .gray_9E9E9E
    }
    
    let collectionView: FullWidthSelectionView = {
        let selections = [
            CareerType.NEWCOMER,
            CareerType.LESS_THAN_1YEARS,
            CareerType.LESS_THAN_3YEARS,
            CareerType.LESS_THAN_6YEARS,
            CareerType.LESS_THAN_10YEARS,
            CareerType.MORE_THAN_10YEARS,
        ]
        let width = UIScreen.main.bounds.width - Constants.leadingMargin * 2
        
        let fullWidthSelectionView = FullWidthSelectionView(
            of: selections,
            width: width,
            numberOfItemsInARow: Constants.numberOfItemsInARow,
            minimumInteritemSpacing: Constants.minimumInteritemSpacing
        )
        fullWidthSelectionView.allowsMultipleSelection = false
        return fullWidthSelectionView
    }()
    
    let selectedItem = BehaviorRelay<Selection>(value: CareerType.NEWCOMER)
    var selectedCareers: [String] = []
    var clearButtonIsActivated = BehaviorSubject<Bool>(value: true)
    
    init() {
        super.init(frame: .zero)
        
        self.setupUI()
        self.setContraints()
        self.bindViewModel()
    }
    
    func xibInit() {
        self.setupUI()
        self.setContraints()
        self.bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        [titleLabel, subtitleLabel, collectionView]
            .forEach { self.addSubview($0) }
    }
    
    private func setContraints() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(2)
            $0.bottom.equalTo(titleLabel)
        }
        
        collectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.bottom.equalToSuperview()
        }
    }
}

extension CareerSelectionBlock {
    private func bindViewModel() {
        
        collectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe { owner, indexPath in
                guard let cell = owner.collectionView.cellForItem(at: indexPath) as? DynamicSizeSelectionCell
 else { return }
                // collectionView의 allowsMultipleSelection이 false이므로 다른 cell을 선택 해제하지 않아도 됨
                
                // 선택(isSelected=true)된 item 업데이트
                guard let item = cell.item else { return }
                owner.selectedItem.accept(item)
                owner.clearButtonIsActivated.onNext(false)
                if let career = item as? CareerType {
                    owner.selectedCareers.append(career.rawValue)
                    if owner.selectedCareers.count == CareerType.allCases.count - 1 {
                        owner.clearButtonIsActivated.onNext(true)
                        owner.deselectAll()
                    }
                }
            }.disposed(by: rx.disposeBag)
        
        collectionView.rx.itemDeselected
            .withUnretained(self)
            .subscribe { owner, indexPath in
                guard let cell = owner.collectionView.cellForItem(at: indexPath) as? DynamicSizeSelectionCell
 else { return }
                guard let item = cell.item else { return }
                
                if let career = item as? CareerType {
                    owner.selectedCareers.removeAll { $0 == career.rawValue }
                }
            }.disposed(by: rx.disposeBag)
    }
    
    func selectItem(at indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
    }
    
    func deselectAll() {
        guard let selectedItems = collectionView.indexPathsForSelectedItems else { return }
        for indexPath in selectedItems {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
        selectedCareers = []
    }
}
