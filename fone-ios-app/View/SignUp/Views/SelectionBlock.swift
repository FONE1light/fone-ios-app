//
//  SelectionBlock.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/08/23.
//

import UIKit
import Then
import RxRelay

/// 직업 or 관심사 선택 label + UICollectionView 영역
class SelectionBlock: UIView {
    private let titleLabel = UILabel().then {
        $0.font = .font_m(15)
    }
    
    private let subtitleLabel = UILabel().then {
        $0.font = .font_r(12)
        $0.textColor = .gray_9E9E9E
    }
    
    private var items: [Selection] = []
    
    private lazy var collectionView: DynamicHeightCollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        let collectionView = DynamicHeightCollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(SelectionCell.self, forCellWithReuseIdentifier: SelectionCell.identifier)
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    let selectedItems = BehaviorRelay<[Selection]>(value: [])
    
    init() {
        super.init(frame: .zero)
        self.setUI()
        self.setContraints()
        self.bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
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
<<<<<<< HEAD
//            $0.height.greaterThanOrEqualTo(33) // TODO: 다른 높이 지정 방식 없는지 확인
            $0.height.greaterThanOrEqualTo(75) //equalTo(70)
=======
//            $0.height.greaterThanOrEqualTo(75) // DynamicHeightCollectionView 사용해서 불필요
>>>>>>> 1e7d325ddc2ba9628990d24ff9812eb18d6ac710
            $0.bottom.equalToSuperview()
        }
    }
    
    func setTitle(_ text: String) {
        titleLabel.text = text
    }
    
    func setSubtitle(_ text: String) {
        subtitleLabel.text = text
    }
    
    func setSelections(_ list: [Selection]) {
        items = list
    }
}

extension SelectionBlock {
    func bindViewModel() {
        
        collectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe { owner, indexPath in
                guard let cell = owner.collectionView.cellForItem(at: indexPath) as? SelectionCell else { return }
                // 1. design properties 변경
                cell.changeSelectedState()
                
                // 2. 선택된 item 업데이트
                guard let item = cell.item else { return }
                var items = owner.selectedItems.value
                
                if cell.isChosen {
                    items.append(item)
                } else {
                    items.removeAll { $0.name == item.name }
                }
                
                owner.selectedItems.accept(items)
                
            }.disposed(by: rx.disposeBag)
        
        collectionView.rx.setDelegate(self).disposed(by: rx.disposeBag)
        
    }
}

extension SelectionBlock: UICollectionViewDataSource {
    
    // MARK: cell count
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    // MARK: cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: SelectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(SelectionCell.self)", for: indexPath) as? SelectionCell else {
            return UICollectionViewCell()
        }
        
        cell.setItem(items[indexPath.row])
        cell.backgroundColor = .gray_EEEFEF
        
        return cell
    }
}

extension SelectionBlock: UICollectionViewDelegateFlowLayout {
    // MARK: cellSize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let defaultHeight = 33.0
        
        let item = items[indexPath.row].name
        let itemSize = item.size(withAttributes: [
            NSAttributedString.Key.font : UIFont.font_r(SelectionCell.Constants.fontSize)
        ])
        let itemWidth = itemSize.width + SelectionCell.Constants.leadingInset * 2 + 1 // TODO: 약간의 여백(1) 필요한 이유
        return CGSize(width: itemWidth, height: defaultHeight)
    }
    
    // MARK: minimumSpacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
}
