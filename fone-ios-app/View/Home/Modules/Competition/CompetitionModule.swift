//
//  CompetitionModule.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/09/24.
//

import UIKit

class CompetitionModule: UICollectionViewCell {
    var competitionInfo: CompetitionModuleInfo?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var errorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setModuelInfo(info: CompetitionModuleInfo?) {
        titleLabel.text = info?.title ?? "인기 영화제"
        self.competitionInfo = info
        setModule()
    }
    
    private func setModule() {
        guard competitionInfo != nil else {
            errorView.isHidden = false
            collectionView.isHidden = true
            return
        }
        collectionView.reloadData()
    }
}
