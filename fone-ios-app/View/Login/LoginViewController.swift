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
    
   
    @IBOutlet weak var kakaoLoginView: UIView!
    @IBOutlet weak var googleLoginView: UIView!
    @IBOutlet weak var appleLoginView: UIView!
    
    @IBOutlet weak var kakaoLoginButton: UIButton!
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    
    @IBOutlet weak var emailLoginButton: UIButton!
    @IBOutlet weak var emailSignUpButton: UIButton!
    @IBOutlet weak var questionButton: UIButton!
    
    func bindViewModel() {
        kakaoLoginButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { _ in
            })
            .disposed(by: rx.disposeBag)
        
        googleLoginButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { _ in
                
            })
            .disposed(by: rx.disposeBag)
        
        appleLoginButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { _ in
                
            })
            .disposed(by: rx.disposeBag)
        
        emailLoginButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { _ in
                self.viewModel.moveToEmailLogin()
            })
            .disposed(by: rx.disposeBag)
        
        emailSignUpButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { _ in
                self.viewModel.moveToEmailSignUp()
            })
            .disposed(by: rx.disposeBag)
        
        questionButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { _ in
                self.viewModel.moveToQuestion()
            })
            .disposed(by: rx.disposeBag)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [ kakaoLoginView, googleLoginView, appleLoginView ].forEach {
            $0.applyShadow(shadowType: .shadowIt2)
        }
    }
}
