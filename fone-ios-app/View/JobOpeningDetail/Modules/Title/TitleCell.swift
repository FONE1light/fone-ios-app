//
//  TitleCell.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 11/12/23.
//

import UIKit

struct TitleInfo {
    let categories: [String]
    let title: String
    
    init?(categories: [String]?, title: String?) {
        guard let categories = categories, let title = title else { return nil }
        self.categories = categories
        self.title = title
    }
}

class TitleCell: UICollectionViewCell {
    @IBOutlet weak var firstCategoryLabel: UILabel!
    @IBOutlet weak var secondCategoryLabel: UILabel!
    @IBOutlet weak var secondCategoryView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configrue(titleInfo: TitleInfo) {
        let firstCategory = titleInfo.categories.first ?? ""
        firstCategoryLabel.text =  Category.getType(serverName: firstCategory)?.name
        if titleInfo.categories.count > 1 {
            secondCategoryView.isHidden = false
            let secondCategory = titleInfo.categories.last ?? ""
            secondCategoryLabel.text = Category.getType(serverName: secondCategory)?.name
        } else {
            secondCategoryView.isHidden = true
        }
        titleLabel.text = titleInfo.title
    }
}

extension TitleCell {
    static func cellHeight(_ item: String?) -> CGFloat {
        guard let item = item else { return 0 }
        let height = UILabel.getLabelHeight(width: UIScreen.main.bounds.width - 32, text: item, font: UIFont.font_b(19), line: 0)
        return height + 64
    }
}
