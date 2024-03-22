//
//  SelectionBlock.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/08/23.
//

import UIKit
import Then
import SnapKit
import RxRelay

/// 직업 or 관심사 선택 label + UICollectionView 영역
class SelectionBlock: UIView {
    private let titleLabel = UILabel().then {
        $0.font = .font_b(15)
    }
    
    private let subtitleLabel = UILabel().then {
        $0.font = .font_r(12)
        $0.textColor = .gray_9E9E9E
    }
    
    private var titlesAreEmpty: Bool {
        if let titleLabelText = titleLabel.text,
           !titleLabelText.isEmpty {
            return false
        }
        
        if let subtitleLabelText = subtitleLabel.text,
            !subtitleLabelText.isEmpty {
            return false
        }
        
        return true
    }
    
    private var allItems: [Selection] = []
    
    private lazy var collectionView: DynamicHeightCollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        let collectionView = DynamicHeightCollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        
        collectionView.register(SelectionCell.self, forCellWithReuseIdentifier: SelectionCell.identifier)
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    var allowsSelection: Bool = true {
        didSet {
            collectionView.allowsSelection = allowsSelection
        }
    }
    
    var selectionLimits: Int = 0
    
    let selectedItems = BehaviorRelay<[Selection]>(value: [])
    
    init() {
        super.init(frame: .zero)
        self.setUI()
        self.setContraints()
        self.bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setUI()
        self.setContraints()
        self.bindViewModel()
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
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func updateCollectionViewTopConstraints() {
        var topOffset: CGFloat = 8
        if titlesAreEmpty {
            topOffset = 0
        }
        
        collectionView.snp.updateConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(topOffset)
        }
    }
    
    func setTitle(_ text: String) {
        titleLabel.text = text
        updateCollectionViewTopConstraints()
    }
    
    func setSubtitle(_ text: String) {
        subtitleLabel.text = text
        updateCollectionViewTopConstraints()
    }
    
    func setSelections(_ list: [Selection]) {
        allItems = list
    }
    
    /// `items`를 선택된 상태로 설정
    func select(items: [Selection]) {
        collectionView.visibleCells.forEach { cell in
            guard let cell = cell as? SelectionCell,
            let item = cell.item else { return }
            
            if items.contains(where: { $0.serverName == item.serverName }) {
                cell.isChosen = true
            }
        }
        
        selectedItems.accept(items)
    }
    
    func deselectAll() {
        collectionView.visibleCells.forEach {
            guard let cell = $0 as? SelectionCell else { return }
            cell.isChosen = false
        }
        selectedItems.accept([])
    }
}

extension SelectionBlock {
    func bindViewModel() {
        
        collectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe { owner, indexPath in
                guard let cell = owner.collectionView.cellForItem(at: indexPath) as? SelectionCell else { return }
                // 1. design properties 변경
                cell.toggle()
                
                // 2. 선택된 item 업데이트
                guard let item = cell.item else { return }
                var items = owner.selectedItems.value
                
                if cell.isChosen {
                    if owner.selectionLimits == 1 {
                        // 무조건 비우고 deselect 후
                        owner.deselectAll()
                        items = []
                        
                        // 현재 셀 toggle ON
                        cell.toggle()
                    } else if owner.selectionLimits > 0, items.count >= owner.selectionLimits {
                        cell.toggle()
                        return
                    }
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
        return allItems.count
    }
    
    // MARK: cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: SelectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(SelectionCell.self)", for: indexPath) as? SelectionCell else {
            return UICollectionViewCell()
        }
        
        cell.setItem(allItems[indexPath.row])
        cell.backgroundColor = .gray_EEEFEF
        
        return cell
    }
}

extension SelectionBlock: UICollectionViewDelegateFlowLayout {
    // MARK: cellSize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let defaultHeight = 33.0
        
        let item = allItems[indexPath.row].name
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
