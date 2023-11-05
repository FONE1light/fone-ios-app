//
//  ProfileModule.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/09/24.
//

import UIKit

class ProfileModule: UICollectionViewCell {
    var profileInfo: ProfileModuleInfo?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.dataSource = self
        collectionView.register(ProfileCell.self)
    }
    
    func setModuelInfo(info: ProfileModuleInfo?) {
        self.profileInfo = info
        collectionView.reloadData()
        setModule()
    }
    
    private func setModule() {
        titleLabel.text = profileInfo?.title
    }
}

extension ProfileModule: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let maxCount = 8
        let itemCount = profileInfo?.data.content.count ?? 0
        return min(itemCount, maxCount)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as ProfileCell
        if let item = profileInfo?.data.content[indexPath.item] {
            cell.configure(item: item)
        }
        return cell
    }
}
