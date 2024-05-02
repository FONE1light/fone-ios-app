//
//  BottomSheetViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/10/14.
//

import UIKit
import PanModal
import SnapKit
import Then

class BottomSheetViewController: UIViewController {
    
    var longFormHeight: PanModalHeight {
        shortFormHeight
    }
    
    var shortFormHeight: PanModalHeight {
        return .intrinsicHeight
    }
    
    private let bottomSheetView: UIView
    private let sceneCoordinator: SceneCoordinator?

    init(view: UIView, sceneCoordinator: SceneCoordinatorType?) {
        bottomSheetView = view
        self.sceneCoordinator = sceneCoordinator as? SceneCoordinator
        super.init(nibName: nil, bundle: nil)
//        let height = view.frame.height
//        self.customHeight = .contentHeight(height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(bottomSheetView)
        bottomSheetView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension BottomSheetViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        nil
    }
    
    // SceneCoordinator의 close가 호출되지 않고 dismiss 되는 경우(=항목 누르지 않고 dimmedView 눌러서 닫는 경우) currentVC가 업데이트 되지 않으므로 아래 함수에서 수동으로 업데이트
    func panModalDidDismiss() {
        guard let presentingVC = sceneCoordinator?.currentVC.presentingViewController
        else { return }
        
        guard sceneCoordinator?.currentVC != presentingVC.sceneViewController else { return }
        
        sceneCoordinator?.currentVC = presentingVC.sceneViewController
    }
    
}
