//
//  DetailImageCell.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 11/12/23.
//

import UIKit

class DetailImageCell: UICollectionViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var imageUrls: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(with: JobHuntingProfileCollectionViewCell.self)
    }
    
    func configure(imageUrls: [String]) {
        self.imageUrls = imageUrls
        collectionView.reloadData()
        pageControl.hidesForSinglePage = true
        pageControl.numberOfPages = imageUrls.count
    }
}

extension DetailImageCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as JobHuntingProfileCollectionViewCell
        cell.configure(imageUrls[indexPath.row])
        cell.imageView.contentMode = .scaleAspectFit
        return cell
    }
}

extension DetailImageCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: Double = UIScreen.main.bounds.width
        let height = width / 375 * 400
        
        return CGSize(width: width, height: height)
    }
}

extension DetailImageCell: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
        self.pageControl.currentPage = page
    }
}
