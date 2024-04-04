//
//  ProfileModule.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/09/24.
//

import UIKit

class ProfileModule: UICollectionViewCell {
    var profileInfo: ProfileModuleInfo?
    var sceneCoordinator: SceneCoordinatorType?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var errorView: UIView!
    
    @IBAction func goToProfiles(_ sender: Any) {
        if let tabBar = window?.rootViewController as? UITabBarController {
            let nav = tabBar.viewControllers?[1] as? UINavigationController
            if var vc = nav?.topViewController as? JobOpeningHuntingViewController {
                guard let sceneCoordinator = sceneCoordinator as? SceneCoordinator else { return }
                let viewModel = JobOpeningHuntingViewModel(sceneCoordinator: sceneCoordinator)
                sceneCoordinator.currentVC = vc
                
                if !vc.hasViewModel {
                    vc.bind(viewModel: viewModel)
                    vc.hasViewModel = true
                }
                vc.viewModel.selectedTab.accept(.profile)
            }
            tabBar.selectedIndex = 1
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProfileCell.self)
    }
    
    func setModuleInfo(info: ProfileModuleInfo?, sceneCoordinator: SceneCoordinatorType?) {
        self.sceneCoordinator = sceneCoordinator
        guard let info else {
            showErrorView()
            return
        }
        self.profileInfo = info
        collectionView.reloadData()
        setModule()
    }
    
    private func setModule() {
        guard profileInfo?.data?.content?.count != 0 else {
            showErrorView()
            return }
        errorView.isHidden = true
        titleLabel.text = profileInfo?.title
    }
    
    private func showErrorView() {
        errorView.isHidden = false
        errorView.applyShadow(shadowType: .shadowIt2)
    }
}

extension ProfileModule: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let maxCount = 8
        let itemCount = profileInfo?.data?.content?.count ?? 0
        return min(itemCount, maxCount)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as ProfileCell
        if let item = profileInfo?.data?.content?[indexPath.item] {
            cell.configure(item: item)
        }
        return cell
    }
}

extension ProfileModule: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let sceneCoordinator = sceneCoordinator as? SceneCoordinator else { return }
        if let item = profileInfo?.data?.content?[indexPath.item],
           let id = item.id, let type = item.type {
            sceneCoordinator.goJobHuntingDetail(jobHuntingId: id, type: Job.getType(name: type) ?? .actor)
        }
    }
}
