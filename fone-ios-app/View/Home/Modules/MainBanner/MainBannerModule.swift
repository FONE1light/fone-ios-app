//
//  MainBannerModule.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/09/17.
//

import UIKit

class MainBannerModule: UICollectionViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MainBannerCell.self)
    }
}

extension MainBannerModule: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as MainBannerCell
        cell.configure(index: indexPath.row)
        return cell
    }
}

extension MainBannerModule: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: Double = UIScreen.main.bounds.width
        let height: Double = 250
        
        return CGSize(width: width, height: height)
    }
}

extension MainBannerModule: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width) + 1
        pageCountLabel.text = "\(currentPage) / 6"
    }
}
