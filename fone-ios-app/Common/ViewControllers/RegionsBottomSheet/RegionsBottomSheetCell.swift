//
//  RegionsBottomSheetCell.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 3/6/24.
//

import UIKit

class RegionsBottomSheetCell: UITableViewCell {
    @IBOutlet weak var regionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if isSelected {
            regionLabel?.font = .font_b(14)
            regionLabel.textColor = .red_CE0B39
        } else {
            regionLabel?.font = .font_r(14)
            regionLabel.textColor = .gray_555555
        }
    }
    
    func configure(region: String) {
        regionLabel.text = region
    }
}
