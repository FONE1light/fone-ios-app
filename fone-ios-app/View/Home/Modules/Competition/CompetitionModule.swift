//
//  CompetitionModule.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/09/24.
//

import UIKit

class CompetitionModule: UICollectionViewCell {
    var competitionInfo: CompetitionModuleInfo?
    var sceneCoordinator: SceneCoordinatorType?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var errorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FilmCompetitionCell.self)
    }

    func setModuleInfo(info: CompetitionModuleInfo?, sceneCoordinator: SceneCoordinatorType?) {
        self.sceneCoordinator = sceneCoordinator
        guard let info else {
            errorView.isHidden = false
            return
        }
        self.competitionInfo = info
        setModule()
    }
    
    private func setModule() {
        errorView.isHidden = true
        titleLabel.text = competitionInfo?.title ?? "인기 영화제"
        collectionView.reloadData()
    }
}

extension CompetitionModule: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let maxCount = 5
        let itemCount = competitionInfo?.data?.content?.count ?? 0
        return min(itemCount, maxCount)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as FilmCompetitionCell
        if let item = competitionInfo?.data?.content?[indexPath.item] {
            cell.configure(item: item, index: indexPath.item)
        }
        return cell
    }
}

extension CompetitionModule: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let sceneCoordinator = sceneCoordinator as? SceneCoordinator else { return }
        if let url = competitionInfo?.data?.content?[indexPath.item].linkURL, !url.isEmpty {
            let viewModel = SNSWebViewModel(sceneCoordinator: sceneCoordinator, url: url, title: "영화제 정보")
            let scene = Scene.snsWebViewController(viewModel)
            sceneCoordinator.transition(to: scene, using: .fullScreenModal, animated: true)
        }
    }
}
