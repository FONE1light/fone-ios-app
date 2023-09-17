//
//  HomeViewController.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/09/11.
//

import UIKit

enum ModuleSection: Int, CaseIterable {
    case mainBanner = 0
    case jobOpening
    case competition
    case profile
}

class HomeViewController: UIViewController, ViewModelBindableType {
    var viewModel: HomeViewModel!
    var hasViewModel = false
    
    @IBOutlet weak var notiButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MainBannerModule.self)
        collectionView.register(JobOpeningModule.self)
        collectionView.register(CompetitionModule.self)
        collectionView.register(ProfileModule.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func bindViewModel() {
        notiButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                let notiScene = Scene.notification
                owner.viewModel.sceneCoordinator.transition(to: notiScene, using: .push, animated: true)
            }.disposed(by: rx.disposeBag)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        switch indexPath.section {
        case ModuleSection.mainBanner.rawValue:
            cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as MainBannerModule
        case ModuleSection.jobOpening.rawValue:
            cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as JobOpeningModule
        case ModuleSection.competition.rawValue:
            cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as CompetitionModule
        case ModuleSection.profile.rawValue:
            cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as ProfileModule
        default:
            break
        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return ModuleSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: Double = UIScreen.main.bounds.width
        var height: Double = 250
        switch indexPath.section {
        case ModuleSection.mainBanner.rawValue:
            height = 250
        case ModuleSection.jobOpening.rawValue:
            height = 214
        case ModuleSection.competition.rawValue:
            height = 259
        case ModuleSection.profile.rawValue:
            height = 249
        default:
            height = 0
        }
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case ModuleSection.mainBanner.rawValue:
            return UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 0)
        case ModuleSection.jobOpening.rawValue:
            return UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        case ModuleSection.competition.rawValue:
            return UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        case ModuleSection.profile.rawValue:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        default: return  .zero
        }
    }
}
