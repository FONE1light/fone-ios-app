//
//  JobHuntingProfilesViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 12/12/23.
//

import UIKit
import Then
import SnapKit
import RxSwift

class JobHuntingProfilesViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: JobHuntingProfilesViewModel!
    private let navigationBar = UIView()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 114, height: 132)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1

        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(with: JobHuntingProfileCollectionViewCell.self)
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    func bindViewModel() {
        collectionView.rx.itemSelected
            .withUnretained(self)
            .bind { owner, indexPath in
                // TODO: cell의 데이터/imageView 이용하도록 수정할지?
//                let cell = owner.collectionView.dequeueReusableCell(forIndexPath: indexPath) as JobHuntingProfileCollectionViewCell
                
                let modal = ProfilePreviewController(imageUrl: owner.viewModel.imageUrls?[indexPath.row])
                modal.modalPresentationStyle = .pageSheet
                owner.present(modal, animated: true)
            }.disposed(by: rx.disposeBag)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setConstraints()
        setNavigationBar(title: viewModel.name)
    }
    
    private func setNavigationBar(title: String?) {
        
        let titleLabel = UILabel().then {
            $0.text = title
            $0.font = .font_b(19)
            $0.textColor = .gray_161616
        }
        
        let closeButton = UIButton().then {
            $0.setImage(UIImage(named: "close_MD"), for: .normal)
        }
        
        [titleLabel, closeButton]
            .forEach { navigationBar.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }

        closeButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.viewModel.sceneCoordinator.close(animated: true)
            }.disposed(by: rx.disposeBag)
    }
    
    private func setupUI() {
        view.backgroundColor = .white_FFFFFF
        
        [navigationBar, collectionView]
            .forEach { view.addSubview($0) }
    }
    
    private func setConstraints() {
        navigationBar.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(view.safeAreaInsets.top).offset(UIView.notchTop)
            $0.leading.trailing.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
    }
}

extension JobHuntingProfilesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.imageUrls?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as JobHuntingProfileCollectionViewCell
        cell.configure(viewModel.imageUrls?[indexPath.row])
        
        return cell
    }
}
