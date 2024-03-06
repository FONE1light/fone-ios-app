//
//  RegionsBottomSheetViewController.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 3/6/24.
//

import UIKit
import PanModal

class RegionsBottomSheetViewController: UIViewController, ViewModelBindableType {
    var viewModel: RegionsBottomSheetViewModel!
    
    var longFormHeight: PanModalHeight {
        shortFormHeight
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(263)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.register(RegionsBottomSheetCell.self)
    }
    
    func bindViewModel() {
        
    }
}

extension RegionsBottomSheetViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as RegionsBottomSheetCell
        
        cell.configure(region: viewModel.list[indexPath.row])
        
        return cell
    }
}

extension RegionsBottomSheetViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        tableView
    }
    
    // SceneCoordinator의 close가 호출되지 않고 dismiss 되는 경우(=항목 누르지 않고 dimmedView 눌러서 닫는 경우) currentVC가 업데이트 되지 않으므로 아래 함수에서 수동으로 업데이트
    func panModalDidDismiss() {
        guard let sceneCoordinator = viewModel.sceneCoordinator as? SceneCoordinator,
              let presentingVC = sceneCoordinator.currentVC.presentingViewController
        else { return }
        
        guard sceneCoordinator.currentVC != presentingVC.sceneViewController else { return }
        
        sceneCoordinator.currentVC = presentingVC.sceneViewController
    }
}
