//
//  MainBannerCell.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/09/24.
//

import UIKit

class MainBannerCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func configure(index: Int) {
        imageView.image = UIImage(named: "banner\(index + 1)")
    }
}
