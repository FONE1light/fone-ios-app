//
//  JobOpeningCell.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/09/24.
//

import UIKit

class JobOpeningCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var dDayLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var secondCategoryView: UIView!
    @IBOutlet weak var secondCategoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(item: JobOpeningContent, index: Int) {
        imageView.image = UIImage(named: "card\(index + 1)")
        
        setTextColors(index: index)
        
        titleLabel.text = item.title
        nicknameLabel.text = item.nickname
        dDayLabel.text = item.dday
        let gender = GenderType.getType(serverName: item.gender ?? "")
        genderLabel.text = gender?.name
        
        var filteredCategory: [String] = []
        var hasOTT = false
        if let categories = item.categories {
            for category in categories {
                if category == Category.ottDrama.serverName {
                    hasOTT = true
                } else {
                    if let categoryName = Category.getType(serverName: category)?.name, !categoryName.isEmpty {
                        filteredCategory.append(categoryName)
                    }
                }
            }
        }
        
        categoryLabel.text = filteredCategory.first

        if filteredCategory.count == 2 {
            secondCategoryView.isHidden = false
            secondCategoryLabel.isHidden = false
            secondCategoryLabel.text = filteredCategory.last
        } else {
            secondCategoryView.isHidden = true
            secondCategoryLabel.isHidden = true
        }
        
        if hasOTT {
            secondCategoryView.isHidden = false
            secondCategoryLabel.isHidden = false
            secondCategoryLabel.text = Category.ottDrama.name
        }
    }
    
    private func setTextColors(index: Int) {
        let isBlackTheme = index == 1 || index == 4
        titleLabel.textColor = isBlackTheme ? .gray_161616 : .white_FFFFFF
        nicknameLabel.textColor = isBlackTheme ? .gray_161616 : .gray_F8F8F8
        [ dDayLabel, genderLabel, categoryLabel, secondCategoryLabel ].forEach {
            $0?.textColor = isBlackTheme ? .gray_555555 : .gray_F8F8F8
        }
    }
}
