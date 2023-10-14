//
//  MyPageTabBarCollectionView.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/10/13.
//

import UIKit
import RxCocoa

enum TabBarType {
     case savedProfiles
}

extension TabBarType {
    var titles: [String] {
        switch self {
        case .savedProfiles: return ["배우", "스태프"]
        }
    }
}

class MyPageTabBarCollectionView: UIView {
    struct Constants {
        /// leading, trailing inset
        static let horizontalInset: CGFloat = 16
        static let tabBarHeight: CGFloat = 37
        static let grayUnderlineHeight: CGFloat = 1
        static let selectedUnderlineHeight: CGFloat = 2
    }
    
    var titles: [String]
    
    var itemSelected: ControlEvent<IndexPath> {
        collectionView.rx.itemSelected
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
            )
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(with: MyPageTabBarCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    private let underLineView = UIView().then {
        $0.backgroundColor = .gray_D9D9D9
    }
    
    init(type: TabBarType = .savedProfiles) {
        titles = type.titles
        super.init(frame: .zero)
        
        setupUI()
        setConstraints()
        
        collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .left)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [collectionView, underLineView]
            .forEach { addSubview($0) }
        collectionView.isScrollEnabled = false
        collectionView.isPagingEnabled = false
    }
    
    private func setConstraints() {
        collectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        underLineView.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom)
            $0.leading.trailing.equalTo(collectionView)
            $0.height.equalTo(Constants.grayUnderlineHeight)
            $0.bottom.equalToSuperview()
        }
    }
    
    func scrollToItem(at indexPath: IndexPath, at position: UICollectionView.ScrollPosition, animated: Bool) {
        collectionView.scrollToItem(at: indexPath, at: position, animated: animated)
    }
}

extension MyPageTabBarCollectionView: UICollectionViewDataSource {
    
    // MARK: cell count
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    // MARK: cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as MyPageTabBarCell
        
        cell.configure(
            title: titles[indexPath.row]
        )
        
        return cell
    }

}

extension MyPageTabBarCollectionView: UICollectionViewDelegateFlowLayout {
    // MARK: cellSize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let defaultHeight = Constants.tabBarHeight
        
        let itemWidth = (UIScreen.main.bounds.width - Constants.horizontalInset*2) / 2
        
        return CGSize(width: itemWidth, height: defaultHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
