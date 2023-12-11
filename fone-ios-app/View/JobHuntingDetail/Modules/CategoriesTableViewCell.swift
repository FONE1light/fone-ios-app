//
//  CategoriesTableViewCell.swift
//  fone-ios-app
//
//  Created by 여나경 on 12/11/23.
//

import UIKit
import RxSwift
import Then
import SnapKit

class CategoriesTableViewCell: UITableViewCell {
    
    static let identifier = String(String(describing: CategoriesTableViewCell.self))
    
    private let selectionBlock = SelectionBlock()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }
    
    func configure(_ categories: [Category]) {
        selectionBlock.setSelections(categories)
        
        setupUI(categoriesCount: categories.count)
    }
    
    private func setupUI(categoriesCount: Int) {
        contentView.addSubview(selectionBlock)
        
        selectionBlock.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
            $0.height.equalTo(CategoriesTableViewCell.selectionBlockHeight(categoriesCount))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CategoriesTableViewCell {
    // FIXME: height 자동 계산 방법, 혹은 tableView로 변경 혹은 tableView로 새로 만들며 코드로 짜기
    static func selectionBlockHeight(_ categoriesCount: Int) -> CGFloat {
        let cellHeight: CGFloat = 33
        let minimumInteritem: CGFloat = 8
        
        switch categoriesCount {
        case 1...3: return cellHeight
        case 4...6: return cellHeight * 2 + minimumInteritem
        case 7...9: return cellHeight * 3 + minimumInteritem * 2
        default: return 0
        }
//        let height = UILabel.getLabelHeight(width: UIScreen.main.bounds.width - 32, text: item, font: UIFont.font_r(14), line: 0)
//        return height + 74
    }
    
//    // FIXME: height 자동 계산 방법, 혹은 tableView로 변경 혹은 tableView로 새로 만들며 코드로 짜기
//    static func cellHeight(_ categoriesCount: Int) -> CGFloat {
//        let cellHeight: CGFloat = 33
//        let margin: CGFloat = 16
//        let minimumInteritem: CGFloat = 8
//        
//        switch categoriesCount {
//        case 1...3: return margin * 2 + cellHeight
//        case 4...6: return margin * 2 + cellHeight * 2 + minimumInteritem
//        case 7...9: return margin * 2 + cellHeight * 3 + minimumInteritem * 2
//        default: return 0
//        }
//    }
}
