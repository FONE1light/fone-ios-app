//
//  MainBannerModule.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/09/24.
//

import UIKit

class MainBannerModule: UICollectionViewCell {
    let bannerImageList: [UIImage] = [#imageLiteral(resourceName: "banner1"), #imageLiteral(resourceName: "banner2"), #imageLiteral(resourceName: "banner3"), #imageLiteral(resourceName: "banner4"), #imageLiteral(resourceName: "banner5"), #imageLiteral(resourceName: "banner6")]
    private var timer: Timer?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MainBannerCell.self)
        
        layoutIfNeeded()
        let index = bannerImageList.count
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath,
                                    at: .centeredHorizontally,
                                    animated: false)
        
        startTimer()
    }
    
    private func stopTimer() {
        timer?.invalidate()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3,
                                     target: self,
                                     selector: #selector(scrollToNext),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc func scrollToNext() {
        var item = visibleCellIndexPath().item
        if item == bannerImageList.count * 3 - 1 {
            collectionView.scrollToItem(at: IndexPath(item: bannerImageList.count * 2 - 1, section: 0),
                                        at: .centeredHorizontally,
                                        animated: false)
            item = bannerImageList.count * 2 - 1
        }
        
        item += 1
        collectionView.scrollToItem(at: IndexPath(item: item, section: 0),
                                    at: .centeredHorizontally,
                                    animated: true)
        let currentPage: Int = item % bannerImageList.count + 1
        updatePageCount(currentPage)
    }
}

extension MainBannerModule: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bannerImageList.count * 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let bannerImage = bannerImageList[indexPath.item % bannerImageList.count]
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as MainBannerCell
        cell.imageView.image = bannerImage
        //        cell.configure(index: indexPath.row)
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
    private func visibleCellIndexPath() -> IndexPath {
        return collectionView.indexPathsForVisibleItems[0]
    }
    
    private func updatePageCount(_ currentPage: Int) {
        pageCountLabel.text = "\(currentPage) / \(bannerImageList.count)"
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.stopTimer()
        self.startTimer()
        
        var item = visibleCellIndexPath().item
        
        if item == bannerImageList.count * 3 - 2 {
            item = bannerImageList.count * 2
        } else if item == 1 {
            item = bannerImageList.count + 1
        }
        collectionView.isPagingEnabled = false
        collectionView.scrollToItem(at: IndexPath(item: item, section: 0),
                                    at: .centeredHorizontally,
                                    animated: false)
        collectionView.isPagingEnabled = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let item = visibleCellIndexPath().item
        let currentPage: Int = item % bannerImageList.count + 1
        updatePageCount(currentPage)
    }
}
