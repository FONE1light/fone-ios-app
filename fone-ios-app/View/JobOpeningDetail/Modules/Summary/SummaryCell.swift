//
//  SummaryCell.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 11/12/23.
//

import UIKit

class SummaryCell: UICollectionViewCell {
    @IBOutlet weak var detailsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(item: String) {
        detailsLabel.text = item
    }
}

extension SummaryCell {
    static func cellHeight(_ item: String?) -> CGFloat {
        guard let item = item else { return 0 }
        let height = UILabel.getLabelHeight(width: UIScreen.main.bounds.width - 32, text: item, font: UIFont.font_r(14), line: 0)
        return height + 74
    }
}
