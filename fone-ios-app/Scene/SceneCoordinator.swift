//
//  SceneCoordinator.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/08/07.
//

import UIKit
import RxSwift
import RxCocoa
import PanModal

extension UIViewController {
    var sceneViewController: UIViewController {
        if let tabBarController = self as? TabBarViewController {
            return tabBarController.selectedViewController?.children.first ?? self
        }
        return self.children.last ?? self
    }
}

class SceneCoordinator: SceneCoordinatorType {
    private let disposeBag = DisposeBag()
    
    private var window: UIWindow
    var currentVC: UIViewController
    
    required init(window: UIWindow) {
        self.window = window
        currentVC = window.rootViewController!
    }
    
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) {
        let target = scene.instantiate()
        
        switch style {
        case .root:
            currentVC = target.sceneViewController
            window.rootViewController = target
            
        case .push:
            guard let nav = currentVC.navigationController else { break }
            
            nav.rx.willShow
                .withUnretained(self)
                .subscribe(onNext: { (coordinator, evt) in
                    coordinator.currentVC = evt.viewController.sceneViewController
                })
                .disposed(by: disposeBag)
            target.hidesBottomBarWhenPushed = true
            nav.pushViewController(target, animated: animated)
            currentVC = target.sceneViewController
            
        case .fullScreenModal:
            target.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            currentVC.present(target, animated: animated)
            currentVC = target.sceneViewController
            
        case .customModal: // customPanModal
            target.modalPresentationStyle = .custom
            target.transitioningDelegate = PanModalPresentationDelegate.default
            // TODO: dimmed view 수정하려면(alpha값) PanModal 없애고 커스텀 해야할 수 있음
//            let vc = BottomSheetViewController(view: target.view)
//            vc.modalPresentationStyle = .custom
//            vc.transitioningDelegate = PanModalPresentationDelegate.default
//            currentVC.present(vc/*target*/, animated: animated)
            
//            let navigationController = UINavigationController()
////            let testVC = UIViewController()
////            testVC.view = target.view
//            
//            navigationController.setViewControllers([target], animated: false)
//            navigationController.modalPresentationStyle = .custom
//            navigationController.transitioningDelegate = PanModalPresentationDelegate.default
            
            currentVC.present(target, animated: animated)
//            currentVC.presentPanModal(target as! UIViewController & PanModalPresentable)
//            currentVC.presentPanModal(view: target.view)
            currentVC = target.sceneViewController
            
        case .pageSheetModal:
            target.modalPresentationStyle = .pageSheet
            currentVC.present(target, animated: animated)
            currentVC = target.sceneViewController
        }
    }
    
    func close(animated: Bool) {
        if let presentingVC = self.currentVC.presentingViewController {
            self.currentVC.dismiss(animated: animated) {
                self.currentVC = presentingVC.sceneViewController
            }
        } else if let nav = self.currentVC.navigationController {
            guard nav.popViewController(animated: animated) != nil else { return }
            self.currentVC = nav.viewControllers.last!.sceneViewController
        }
    }
}
