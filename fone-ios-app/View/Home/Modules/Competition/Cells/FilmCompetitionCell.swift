//
//  FilmCompetitionCell.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2/12/24.
//

import UIKit

class FilmCompetitionCell: UICollectionViewCell {
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var rankBackgroundView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ddayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(item: CompetitionContent, index: Int) {
        rankLabel.text = String(index+1)
        rankBackgroundView.backgroundColor = index < 3 ? .red_CE0B39 : .violet_362C4C
        imageView.kf.setImage(with: URL(string: item.imageURL ?? ""))
        titleLabel.text = item.title
        ddayLabel.text = item.screeningDDay
    }
}
