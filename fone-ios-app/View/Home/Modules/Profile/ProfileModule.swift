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
    @IBOutlet weak var errorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.dataSource = self
        collectionView.register(ProfileCell.self)
    }
    
    func setModuelInfo(info: ProfileModuleInfo?) {
        guard let info else {
            showErrorView()
            return
        }
        self.profileInfo = info
        collectionView.reloadData()
        setModule()
    }
    
    private func setModule() {
        guard profileInfo?.data?.content?.count != 0 else {
            showErrorView()
            return }
        errorView.isHidden = true
        titleLabel.text = profileInfo?.title
    }
    
    private func showErrorView() {
        errorView.isHidden = false
        errorView.applyShadow(shadowType: .shadowIt2)
    }
}

extension ProfileModule: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let maxCount = 8
        let itemCount = profileInfo?.data?.content?.count ?? 0
        return min(itemCount, maxCount)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as ProfileCell
        if let item = profileInfo?.data?.content?[indexPath.item] {
            cell.configure(item: item)
        }
        return cell
    }
}
