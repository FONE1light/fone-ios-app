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
        let indexPaths = (items as? [Domain])?
            .compactMap { Domain.allCases.firstIndex(of: $0) }
            .compactMap { Int($0) }
            .compactMap { IndexPath(row: $0, section: 0) }
        
        visibleCells.forEach { cell in
            guard let cell = cell as? DynamicSizeSelectionCell else { return }
            
            indexPaths?.forEach {
                selectItem(at: $0, animated: false, scrollPosition: [])
            }
        }
        
        selectedItems.accept(items)
    }
}
