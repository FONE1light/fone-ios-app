//
//  FullWidthSelectionView.swift
//  fone-ios-app
//
//  Created by 여나경 on 12/1/23.
//

import UIKit
import Then
import RxRelay

/// `width` 너비를 가지는 UICollectionView
class FullWidthSelectionView: UIView {
    
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
    
    private lazy var collectionView: DynamicHeightCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 9
        
        layout.scrollDirection = .vertical
        let collectionView = DynamicHeightCollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(with: CareerSelectionCell.self)
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    let selectedItems = BehaviorRelay<[Selection]>(value: [])
    
    init(
        width: CGFloat = 307,
        numberOfItemsInARow: Int = 3,
        minimumInteritemSpacing: CGFloat = 8
    ) {
        super.init(frame: .zero)
        
        self.constants = Constants(
            width: width,
            numberOfItemsInARow: numberOfItemsInARow,
            minimumInteritemSpacing: minimumInteritemSpacing
        )
        self.setupUI()
        self.setContraints()
        self.bindViewModel()
    }
    
    func xibInit(
        width: CGFloat = 307,
        numberOfItemsInARow: Int = 3,
        minimumInteritemSpacing: CGFloat = 8
    ) {
        self.constants = Constants(
            width: width,
            numberOfItemsInARow: numberOfItemsInARow,
            minimumInteritemSpacing: minimumInteritemSpacing
        )
        self.setupUI()
        self.setContraints()
        self.bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        addSubview(collectionView)
        collectionView.allowsMultipleSelection = true
    }
    
    private func setContraints() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension FullWidthSelectionView {
    private func bindViewModel() {
        
        collectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe { owner, indexPath in
                guard let cell = owner.collectionView.cellForItem(at: indexPath) as? CareerSelectionCell else { return }
                // 선택(isSelected=true)된 item 업데이트
                guard let item = cell.item else { return }
                var items = owner.selectedItems.value
                
                if cell.isSelected {
                    items.append(item)
                } else {
                    items.removeAll { $0.name == item.name }
                }
                
                owner.selectedItems.accept(items)
                
            }.disposed(by: rx.disposeBag)
        
        collectionView.rx.setDelegate(self).disposed(by: rx.disposeBag)
    }
    
    func selectItem(at indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
    }
}

extension FullWidthSelectionView {
    
    func setSelections(_ list: [Selection]) {
        items = list
    }
}

extension FullWidthSelectionView: UICollectionViewDataSource {
    
    // MARK: cell count
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    // MARK: cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as SelectionCell
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as CareerSelectionCell
        
        cell.setItem(items[indexPath.row])
        
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
