//
//  EmailLoginViewController.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/09/02.
//

import UIKit

class EmailLoginViewController: UIViewController, ViewModelBindableType {
    var viewModel: EmailLoginViewModel!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailErrorMessage: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var findIDPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func bindViewModel() {
        keyboardHeight()
            .map { $0 != 0 }
            .subscribe { self.viewModel.isKeyboardShowing = $0 }
            .disposed(by: rx.disposeBag)
        
        closeButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { _ in
                self.viewModel.sceneCoordinator.close(animated: true)
            })
            .disposed(by: rx.disposeBag)
        
        loginButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { _ in
                let email = self.emailTextField.text ?? ""
                let password = self.passwordTextField.text ?? ""
                let signInRequest = EmailSignInUserRequest(email: email, password: password)
                self.viewModel.emailLogin(emailSignInUserRequest: signInRequest)
            }).disposed(by: rx.disposeBag)
        
        findIDPasswordButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { _ in
                self.viewModel.moveToFindIDPassword()
            })
            .disposed(by: rx.disposeBag)
        
        emailTextField.rx.text.orEmpty
            .bind(to: viewModel.emailTextSubject)
            .disposed(by: rx.disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .map { $0.isEmpty }
            .bind(to: viewModel.passwordIsEmptySubject)
            .disposed(by: rx.disposeBag)
        
        viewModel.loginButtonEnable
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { (owner, isEnabled) in
                owner.loginButton.setEnabled(isEnabled: isEnabled)
            }).disposed(by: rx.disposeBag)
        
        viewModel.emailTextSubject
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { (owner, email) in
                owner.viewModel.emailIsValidSubject.onNext(email.isValidEmail())
            }).disposed(by: rx.disposeBag)
        
        viewModel.emailIsValidSubject
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { (owner, isEmailValid) in
                owner.emailErrorMessage.isHidden = isEmailValid
                if isEmailValid {
                    owner.emailContainerView.borderWidth = 0
                } else {
                    owner.emailContainerView.borderWidth = 1
                    owner.emailContainerView.borderColor = .crimson_FF5841
                }
            })
            .disposed(by: rx.disposeBag)
    }
}

extension EmailLoginViewController: UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
