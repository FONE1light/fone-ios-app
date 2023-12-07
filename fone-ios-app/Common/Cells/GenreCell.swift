//
//  GenreCell.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 12/4/23.
//

import UIKit

class GenreCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var genreLabel: UILabel!
    
    var genre: Genre?
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                imageView.image = genre?.selectedImage
                genreLabel.textColor = .red_CE0B39
            } else {
                imageView.image = genre?.unselectedImage
                genreLabel.textColor = .gray_9E9E9E
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(genre: Genre) {
        self.genre = genre
        imageView.image = genre.unselectedImage
        genreLabel.text = genre.koreanName
    }
}
