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
                let signInInfo = EmailSignInInfo(email: email, password: password)
                self.viewModel.emailLogin(emailSignInInfo: signInInfo)
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
        
        viewModel.emailIsValidSubject
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { (owner, isEmailValid) in
                owner.emailErrorMessage.isHidden = isEmailValid
                owner.emailContainerView.setTextFieldErrorBorder(showError: !isEmailValid)
            }).disposed(by: rx.disposeBag)
        
        viewModel.showLoginErrorAlertSubject
            .subscribe(onNext: { _ in
                self.loginErrorAlert()
            }).disposed(by: rx.disposeBag)
    }
    
    func loginErrorAlert() {
        let alertTitle = """
        로그인에 실패했습니다.
        아이디 또는 비밀번호를 확인해주세요.
        """
        let alert = UIAlertController.init(title: "", message: alertTitle, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}

extension EmailLoginViewController: UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
