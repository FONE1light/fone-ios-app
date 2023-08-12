//
//  LoginViewController.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/08/07.
//

import UIKit
import RxSwift
import NSObject_Rx

class LoginViewController: UIViewController, ViewModelBindableType {
    var viewModel: LoginViewModel!
    
    @IBOutlet weak var emailSignUpButton: UIButton!
    
    func bindViewModel() {
        emailSignUpButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { _ in
                let findIDPasswordViewModel = FindIDPasswordViewModel(sceneCoordinator: self.viewModel.sceneCoordinator)
                let findIDPasswordScene = Scene.findIDPassword(findIDPasswordViewModel)
                self.viewModel.sceneCoordinator.transition(to: findIDPasswordScene, using: .push, animated: true)
            })
            .disposed(by: rx.disposeBag)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
