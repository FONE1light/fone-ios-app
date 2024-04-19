//
//  DomainSelectionView.swift
//  fone-ios-app
//
//  Created by 여나경 on 4/19/24.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxRelay

class DomainSelectionView: FullWidthSelectionView {
    
    init(width: CGFloat) {
        super.init(
            of: Domain.allCases,
            width: width
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// `items`를 선택된 상태로 설정
    func select(items: [Selection]) {
        visibleCells.forEach { cell in
            guard let cell = cell as? SelectionCell,
            let item = cell.item else { return }
            
            if items.contains(where: { $0.serverName == item.serverName }) {
                cell.isChosen = true
            }
        }
        
        selectedItems.accept(items)
    }
}
