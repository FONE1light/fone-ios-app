//
//  JobHuntingProfileCollectionViewCell.swift
//  fone-ios-app
//
//  Created by 여나경 on 12/12/23.
//

import UIKit

class JobHuntingProfileCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: JobHuntingProfileCollectionViewCell.self)
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ imageUrl: String?) {
        imageView.load(url: imageUrl)
    }
}
