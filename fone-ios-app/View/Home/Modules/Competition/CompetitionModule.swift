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
        
        collectionView.dataSource = self
        collectionView.register(FilmCompetitionCell.self)
    }

    func setModuelInfo(info: CompetitionModuleInfo?) {
        titleLabel.text = info?.title ?? "인기 영화제"
        self.competitionInfo = info
        setModule()
    }
    
    private func setModule() {
//        guard competitionInfo != nil else {
//            errorView.isHidden = false
//            collectionView.isHidden = true
//            return
//        }
        collectionView.reloadData()
    }
}

extension CompetitionModule: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        let maxCount = 5
//        let itemCount = competitionInfo?.data?.content?.count ?? 0
//        return min(itemCount, maxCount)
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as FilmCompetitionCell
//        if let item = competitionInfo?.data?.content?[indexPath.item] {
            cell.configure(index: indexPath.item)
//        }
        return cell
    }
}

