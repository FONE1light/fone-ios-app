//
//  LeftAlignedCollectionViewFlowLayout.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/14.
//

import UIKit

/// 왼쪽으로 정렬된 UICollectionView layout
class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)

        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left // 다음 줄로 넘어갔으면 초기화
            }

            layoutAttribute.frame.origin.x = leftMargin

            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing // 다음 cell의 x 좌표 계산
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }

        return attributes
    }
}
