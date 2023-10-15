//
//  JobOpeningModule.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/09/24.
//

import UIKit

class JobOpeningModule: UICollectionViewCell {
    var jobOpeningInfo: ModuleInfo?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.dataSource = self
        collectionView.register(JobOpeningCell.self)
    }

    func setModuelInfo(info: ModuleInfo?) {
        self.jobOpeningInfo = info
        collectionView.reloadData()
        setModule()
    }
    
    private func setModule() {
        titleLabel.text = jobOpeningInfo?.title
    }
}

extension JobOpeningModule: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let maxCount = 6
        let itemCount = jobOpeningInfo?.data.content.count ?? 0
        return min(itemCount, maxCount)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as JobOpeningCell
        if let item = jobOpeningInfo?.data.content[indexPath.item] {
            cell.configureCell(item: item, index: indexPath.item)
        }
        return cell
    }
}
