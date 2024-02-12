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
    
    var homeInfo: HomeInfoData?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe = true
    }
    
    func bindViewModel() {
        viewModel
            .homeInfoDataSubject
            .subscribe(onNext: { [weak self] homeInfo in
                self?.homeInfo = homeInfo
                self?.collectionView.reloadData()
            }).disposed(by: rx.disposeBag)
        
        setCollectionView()
    }
    
    private func setNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.shadowColor = nil
        navigationBarAppearance.backgroundColor = .white
        
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        
        self.navigationItem.leftBarButtonItem = NavigationLeftBarButtonItem(type: .home)
        self.navigationItem.rightBarButtonItem = NavigationRightBarButtonItem(type: .notification, viewController: self)
    }
    
    private func setCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MainBannerModule.self)
        collectionView.register(JobOpeningModule.self)
        collectionView.register(CompetitionModule.self)
        collectionView.register(ProfileModule.self)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case ModuleSection.mainBanner.rawValue:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as MainBannerModule
            return cell
        case ModuleSection.jobOpening.rawValue:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as JobOpeningModule
            cell.setModuelInfo(info: homeInfo?.jobOpening)
            return cell
        case ModuleSection.competition.rawValue:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as CompetitionModule
            cell.setModuelInfo(info: nil)
            return cell
        case ModuleSection.profile.rawValue:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as ProfileModule
            cell.setModuelInfo(info: homeInfo?.profile)
            return cell
        default:
            return UICollectionViewCell()
        }
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
            height = 219
        case ModuleSection.competition.rawValue:
            height = 259 - 67 //FIXME: 영화제 데이터 들어오면 수정
        case ModuleSection.profile.rawValue:
            height = 254
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
