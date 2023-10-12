//
//  SavedProfilesViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/10/11.
//

import UIKit

class SavedProfilesViewController: UIViewController, ViewModelBindableType {
    
    struct Profile {
        let imageUrl: String?
        let name: String?
        let age: String?
        let isSaved: Bool?
    }
    
//    private let yOffset: CGFloat
    
    var viewModel: SavedProfilesViewModel!
    
    private var profiles: [Profile] = [
        Profile(imageUrl: nil, name: "황우슬혜", age: "1985년생 (38살)", isSaved: true),
        Profile(imageUrl: nil, name: "황우슬혜", age: "1985년생 (38살)", isSaved: false),
        Profile(imageUrl: nil, name: "황우슬혜", age: "1985년생 (38살)", isSaved: true),
        Profile(imageUrl: nil, name: "황우슬혜", age: "1985년생 (38살)", isSaved: false),
        Profile(imageUrl: nil, name: "황우슬혜", age: "1985년생 (38살)", isSaved: true),
        Profile(imageUrl: nil, name: "황우슬혜", age: "1985년생 (38살)", isSaved: true),
        Profile(imageUrl: nil, name: "황우슬혜", age: "1985년생 (38살)", isSaved: false),
        Profile(imageUrl: nil, name: "황우슬혜", age: "1985년생 (38살)", isSaved: true),
        Profile(imageUrl: nil, name: "황우슬혜", age: "1985년생 (38살)", isSaved: true)
    ]
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
            )
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(with: MyPageProfileCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
//    init(yOffset: CGFloat) {
//        self.yOffset = yOffset
//        super.init()
//
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    func bindViewModel() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setConstraints()
                
    }
    
    private func setUI() {
        view.addSubview(collectionView)
    }
    
    private func setConstraints() {
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
        
//        let y = 50 + view.safeAreaInsets.top
//        self.view.frame.origin = CGPoint(x: 0, y: y)
    }
    
//    override func viewDidLayoutSubviews() {
//
//        let y = 80 + view.safeAreaInsets.top
//        self.view.frame.origin = CGPoint(x: 0, y: y)
//
//        //        self.view.frame.origin = CGPoint(x: 0, y: yOffset)
//    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        
//        let y = 80 + view.safeAreaInsets.top
//        self.view.frame.origin = CGPoint(x: 0, y: y)
//    }
}


extension SavedProfilesViewController: UICollectionViewDataSource {
    
    // MARK: cell count
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profiles.count
    }
    
    // MARK: cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as MyPageProfileCell
        let profile = profiles[indexPath.row]
        
        cell.configure(
            image: nil,
            name: profile.name,
            age: profile.age,
            isSaved: profile.isSaved
        )
        
        return cell
    }

}

extension SavedProfilesViewController: UICollectionViewDelegateFlowLayout {
    // MARK: cellSize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let defaultHeight = 223.0 // FIXME: 셀크기로
        
//        let item = profiles[indexPath.row].name
//        let itemSize = item?.size(withAttributes: [
//            NSAttributedString.Key.font : UIFont.font_r(SelectionCell.Constants.fontSize)
//        ])
        
        
//        let itemWidth = itemSize.width + MyPageProfileCell.Constants.leadingInset * 2 + 1 // TODO: 약간의 여백(1) 필요한 이유
        let itemWidth = (UIScreen.main.bounds.width - 16*2 - 14) / 2
        return CGSize(width: itemWidth, height: defaultHeight)
    }
    
    // MARK: minimumSpacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 26
    }
}
