//
//  ImageCollectionViewCell.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 11/6/23.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var thumbnailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
