//
//  SavedProfilesContentViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/10/11.
//

import UIKit

struct Profile {
    let imageUrl: String?
    let name: String?
    let age: String?
    let isSaved: Bool?
    let birthYear: String? // age, birthYear 공존 혹은 하나만?
    let job: Job? // 서버 데이터 확인 후 수정
}

class SavedProfilesContentViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: SavedProfilesContentViewModel!
    
    private var profiles: [Profile] = [
        Profile(imageUrl: nil, name: "황우슬혜", age: "1985년생 (38살)", isSaved: true, birthYear: nil, job: nil),
        Profile(imageUrl: nil, name: "황우슬혜", age: "1985년생 (38살)", isSaved: false, birthYear: nil, job: nil),
        Profile(imageUrl: nil, name: "황우슬혜", age: "1985년생 (38살)", isSaved: true, birthYear: nil, job: nil),
        Profile(imageUrl: nil, name: "황우슬혜", age: "1985년생 (38살)", isSaved: false, birthYear: nil, job: nil),
        Profile(imageUrl: nil, name: "황우슬혜", age: "1985년생 (38살)", isSaved: true, birthYear: nil, job: nil),
        Profile(imageUrl: nil, name: "황우슬혜", age: "1985년생 (38살)", isSaved: true, birthYear: nil, job: nil),
        Profile(imageUrl: nil, name: "황우슬혜", age: "1985년생 (38살)", isSaved: false, birthYear: nil, job: nil),
        Profile(imageUrl: nil, name: "황우슬혜", age: "1985년생 (38살)", isSaved: true, birthYear: nil, job: nil),
        Profile(imageUrl: nil, name: "황우슬혜", age: "1985년생 (38살)", isSaved: true, birthYear: nil, job: nil)
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
    
    // TODO: 추후 backgroundColor 삭제
    init(backgroundColor: UIColor) {
        super.init(nibName: nil, bundle: nil)
        
//        view.backgroundColor = backgroundColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    }
}


extension SavedProfilesContentViewController: UICollectionViewDataSource {
    
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

extension SavedProfilesContentViewController: UICollectionViewDelegateFlowLayout {
    // MARK: cellSize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let defaultHeight = 223.0 // FIXME: 셀크기로
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