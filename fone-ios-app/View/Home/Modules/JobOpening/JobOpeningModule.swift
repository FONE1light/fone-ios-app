//
//  JobOpeningModule.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/09/24.
//

import UIKit

class JobOpeningModule: UICollectionViewCell {
    var jobOpeningInfo: JobOpeningModuleInfo?
    var sceneCoordinator: SceneCoordinatorType?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var errorView: UIView!
    
    @IBAction func goToJobOpening(_ sender: Any) {
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
                vc.viewModel.selectedTab.accept(.jobOpening)
            }
            tabBar.selectedIndex = 1
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(JobOpeningCell.self)
    }

    func setModuleInfo(info: JobOpeningModuleInfo?, sceneCoordinator: SceneCoordinatorType?) {
        self.sceneCoordinator = sceneCoordinator
        guard let info else {
            errorView.isHidden = false
            return
        }
        self.jobOpeningInfo = info
        collectionView.reloadData()
        setModule()
    }
    
    private func setModule() {
        errorView.isHidden = true
        titleLabel.text = jobOpeningInfo?.title
    }
}

extension JobOpeningModule: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let maxCount = 6
        let itemCount = jobOpeningInfo?.data?.content?.count ?? 0
        return min(itemCount, maxCount)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as JobOpeningCell
        if let item = jobOpeningInfo?.data?.content?[indexPath.item] {
            cell.configureCell(item: item, index: indexPath.item)
        }
        return cell
    }
}

extension JobOpeningModule: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let sceneCoordinator = sceneCoordinator as? SceneCoordinator else { return }
        if let item = jobOpeningInfo?.data?.content?[indexPath.item],
           let id = item.id, let type = item.type {
            sceneCoordinator.goJobOpeningDetail(jobOpeningId: id, type: Job.getType(name: type) ?? .actor)
        }
    }
}
