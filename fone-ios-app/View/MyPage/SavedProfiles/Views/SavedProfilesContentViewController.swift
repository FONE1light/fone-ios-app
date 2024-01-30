//
//  SavedProfilesContentViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/10/11.
//

import UIKit
import RxSwift

struct Profile {
    let id: Int?
    let imageUrl: String?
    let name: String?
    let age: String?
    let isSaved: Bool?
    let birthYear: String?
    let job: Job?
}

class SavedProfilesContentViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: SavedProfilesContentViewModel!
    private var disposeBag = DisposeBag()
    
    private var profiles: [Profile] = []
    
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
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindViewModel() {
        viewModel.savedProfiles
            .withUnretained(self)
            .bind { owner, profiles in
                guard let profiles = profiles else { return }
                owner.profiles = profiles
                owner.collectionView.reloadData()
            }.disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .withUnretained(self)
            .bind { owner, indexPath in
                let profile = owner.profiles[indexPath.row]
                guard let id = profile.id,
                      let job = profile.job else { return }
                
                owner.viewModel.goJobHuntingDetail(jobHuntingId: id, type: job)
            }.disposed(by: rx.disposeBag)
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
            id: profile.id,
            jobType: profile.job?.name,
            image: profile.imageUrl,
            name: profile.name,
            birthYear: profile.birthYear,
            age: Int(profile.age ?? ""),
            isSaved: profile.isSaved
        )
        
        return cell
    }

}

extension SavedProfilesContentViewController: UICollectionViewDelegateFlowLayout {
    // MARK: cellSize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (UIScreen.main.bounds.width - 16*2 - 14) / 2
        let defaultHeight = MyPageProfileCell.cellHeight(width: itemWidth)
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
