//
//  CategoriesCell.swift
//  fone-ios-app
//
//  Created by 여나경 on 12/10/23.
//

import UIKit

class CategoriesCell: UICollectionViewCell {
    
    @IBOutlet weak var selectionBlock: SelectionBlock!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(_ categories: [Category]) {
        selectionBlock.setSelections(categories)
    }

}

extension CategoriesCell {
    // FIXME: height 자동 계산 방법, 혹은 tableView로 변경 혹은 tableView로 새로 만들며 코드로 짜기
    static func cellHeight(_ categories: [Category]) -> CGFloat {
        let cellHeight: CGFloat = 33
        let margin: CGFloat = 16
        let minimumInteritem: CGFloat = 8
        
        switch categories.count {
        case 1...3: return margin + cellHeight + margin
        case 4...6: return margin + cellHeight * 2 + minimumInteritem + margin
        case 7...9: return margin + cellHeight * 3 + minimumInteritem * 2 + margin
        default: return 0
        }
//        let height = UILabel.getLabelHeight(width: UIScreen.main.bounds.width - 32, text: item, font: UIFont.font_r(14), line: 0)
//        return height + 74
    }
}
