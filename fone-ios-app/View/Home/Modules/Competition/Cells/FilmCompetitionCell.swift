//
//  FilmCompetitionCell.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2/12/24.
//

import UIKit

class FilmCompetitionCell: UICollectionViewCell {
    @IBOutlet weak var rankLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(index: Int) {
        rankLabel.text = String(index+1)
    }
}
