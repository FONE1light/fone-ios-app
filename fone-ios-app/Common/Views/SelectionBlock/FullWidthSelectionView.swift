//
//  FullWidthSelectionView.swift
//  fone-ios-app
//
//  Created by 여나경 on 12/1/23.
//

import UIKit
import Then
import RxRelay
import RxSwift
import RxCocoa

/// `width` 너비에 꽉 차도록 [Selection]을 표시하는 UICollectionView
class FullWidthSelectionView: DynamicHeightCollectionView {
    
    struct Constants {
        /// collectionView의 width
        var width: CGFloat = 307
        /// 한 행에 배치하는 cell의 개수
        var numberOfItemsInARow: Int = 3
        /// cell 사이 여백
        var minimumInteritemSpacing: CGFloat = 8
    }
    
    private var constants: Constants?
    
    private var items: [Selection] = []
    
    let selectedItems = BehaviorRelay<[Selection]>(value: [])
    
    /// selectedItems: 초기화 시 선택되어 있어야 하는 항목들
    init(
        of selections: [Selection],
        width: CGFloat = 307,
        numberOfItemsInARow: Int = 3,
        minimumInteritemSpacing: CGFloat = 8,
        selectedItems preselectedItems: [Selection]? = nil
    ) {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 9
        layout.scrollDirection = .vertical
        
        super.init(frame: .zero, collectionViewLayout: layout)
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        allowsMultipleSelection = true // default: true로 변경
        
        register(with: DynamicSizeSelectionCell.self)
        dataSource = self        
        
        self.items = selections
        self.constants = Constants(
            width: width,
            numberOfItemsInARow: numberOfItemsInARow,
            minimumInteritemSpacing: minimumInteritemSpacing
        )
        self.selectedItems.accept(preselectedItems ?? [])
        
        self.bindViewModel()
    }
    
    func xibInit(
        of selections: [Selection],
        width: CGFloat = 307,
        numberOfItemsInARow: Int = 3,
        minimumInteritemSpacing: CGFloat = 8,
        selectedItems preselectedItems: [Selection]? = nil
    ) {
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        allowsMultipleSelection = true // default: true로 변경
        
        register(with: DynamicSizeSelectionCell.self)
        dataSource = self
        
        self.items = selections
        self.constants = Constants(
            width: width,
            numberOfItemsInARow: numberOfItemsInARow,
            minimumInteritemSpacing: minimumInteritemSpacing
        )
        self.selectedItems.accept(preselectedItems ?? [])
        
        self.bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 9
        layout.scrollDirection = .vertical
        collectionViewLayout = layout
    }
}

extension FullWidthSelectionView {
    private func bindViewModel() {
        rx.setDelegate(self).disposed(by: rx.disposeBag)
        
        Observable
            .of(rx.itemSelected, rx.itemDeselected)
            .merge()
            .withUnretained(self)
            .bind { owner, indexPath in
                guard let cell = owner.cellForItem(at: indexPath) as? DynamicSizeSelectionCell,
                      let item = cell.item else { return }
                var items = owner.selectedItems.value

                if cell.isSelected {
                    items.append(item)
                } else {
                    items.removeAll { $0.name == item.name }
                }
                
                owner.selectedItems.accept(items)

            }.disposed(by: rx.disposeBag)
        
    }
    
    private func selectItem(at indexPath: IndexPath) {
        selectItem(at: indexPath, animated: false, scrollPosition: [])
        
        guard let cell = cellForItem(at: indexPath) as? DynamicSizeSelectionCell,
              let item = cell.item else { return }
        var items = selectedItems.value
        items.append(item)
        selectedItems.accept(items)
    }
    
    func deselectAll() {
        indexPathsForVisibleItems.forEach {
            deselectItem(at: $0, animated: false)
        }
        selectedItems.accept([])
    }
}

extension FullWidthSelectionView: UICollectionViewDataSource {
    
    // MARK: cell count
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    // MARK: cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // configure
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as DynamicSizeSelectionCell
        let selectionItem = items[indexPath.row]
        cell.configure(selectionItem)
        
        // 초기화 시 선택 처리
        let shouldBeSelected = selectedItems.value.contains(where: {
            $0.name == selectionItem.name
        })
        
        if shouldBeSelected {
            selectItem(at: indexPath)
        }
        
        return cell
    }
}


extension FullWidthSelectionView: UICollectionViewDelegateFlowLayout {
    // MARK: cellSize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let defaultHeight = 32.0
        
        guard let constants = constants else { return CGSize(width: 30, height: defaultHeight) }
        
        let floatNumberOfItemsInARow = CGFloat(constants.numberOfItemsInARow)
        let spacesBetweenItems = constants.minimumInteritemSpacing * (floatNumberOfItemsInARow - 1)
        let itemWidth = (constants.width - spacesBetweenItems) / floatNumberOfItemsInARow - 2 // TODO: 2 빼야 하는 이유
        return CGSize(width: itemWidth, height: defaultHeight)
    }
}
