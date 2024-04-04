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
            currentVC.present(target, animated: animated)
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
    
    /// 모집 상세로 이동
    func goJobOpeningDetail(jobOpeningId: Int, type: Job) {
        jobOpeningInfoProvider.rx.request(.jobOpeningDetail(jobOpeningId: jobOpeningId, type: type))
            .mapObject(Result<JobOpeningData>.self)
            .asObservable()
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                guard let jobOpening = response.data?.jobOpening else {
                    response.message?.toast()
                    return }
                let viewModel = JobOpeningDetailViewModel(sceneCoordinator: self, jobOpeningDetail: jobOpening)
                let detailScene = Scene.jobOpeningDetail(viewModel)
                self.transition(to: detailScene, using: .push, animated: true)
            },
            onError: { error in
                print(error)
            }).disposed(by: disposeBag)
    }
    
    /// 프로필 상세로 이동
    func goJobHuntingDetail(jobHuntingId: Int, type: Job) {
        profileInfoProvider.rx.request(.profileDetail(profileId: jobHuntingId, type: type))
            .mapObject(Result<ProfileData>.self)
            .asObservable()
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                guard let profile = response.data?.profile else {
                    response.message?.toast()
                    return
                }
                
                let viewModel = JobHuntingDetailViewModel(sceneCoordinator: self, jobHuntingDetail: profile)
                viewModel.jobType = type
                
                let detailScene = Scene.jobHuntingDetail(viewModel)
                self.transition(to: detailScene, using: .push, animated: true)
            },
                       onError: { error in
                print(error.localizedDescription)
                error.localizedDescription.toast()
            }).disposed(by: disposeBag)
        
    }
}
