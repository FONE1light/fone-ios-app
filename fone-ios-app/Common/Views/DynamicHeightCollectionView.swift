//
//  DynamicHeightCollectionView.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/14.
//

import UIKit

/// 높이를 지정하지 않아도 자동으로 잡히는 UICollectionView 
class DynamicHeightCollectionView: UICollectionView {
    
    override func layoutSubviews() {
      super.layoutSubviews()
      if !__CGSizeEqualToSize(bounds.size,self.intrinsicContentSize){
        self.invalidateIntrinsicContentSize()
      }
    }
    
    override var intrinsicContentSize: CGSize {
      return contentSize
    }
}
