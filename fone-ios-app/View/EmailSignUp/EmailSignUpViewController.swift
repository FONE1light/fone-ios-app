//
//  EmailSignUpViewController.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/09/02.
//

import UIKit

class EmailSignUpViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: EmailSignUpViewModel!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var emailConfirmButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordContainerView: UIView!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var passwordEyeButton: UIButton!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordContainerView: UIView!
    @IBOutlet weak var confirmPasswordErrorLabel: UILabel!
    @IBOutlet weak var confirmPasswordEyeButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
    }
    
    func bindViewModel() {
//        closeButton.rx.tap
//            .withUnretained(self)
//            .subscribe(onNext: { _ in
//                self.viewModel.sceneCoordinator.close(animated: true)
//            }).disposed(by: rx.disposeBag)
        
        emailTextField.rx.text.orEmpty
            .bind(to: viewModel.emailTextSubject)
            .disposed(by: rx.disposeBag)
        
        viewModel.emailIsValidSubject
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { (owner, isValid) in
                owner.emailErrorLabel.isHidden = isValid
                owner.emailContainerView.setTextFieldErrorBorder(showError: !isValid)
                owner.emailConfirmButton.isEnabled = isValid
                let color: UIColor = isValid ? .red_F43663 : .gray_D9D9D9
                owner.emailConfirmButton.setTitleColor(color, for: .normal)
                owner.emailConfirmButton.borderColor = color
            }).disposed(by: rx.disposeBag)
        
        emailConfirmButton.rx.tap
            .subscribe(onNext: { _ in
                // TODO: 이메일 중복 확인
            }).disposed(by: rx.disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.passwordTextSubject)
            .disposed(by: rx.disposeBag)
        
        passwordEyeButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { _ in
                self.eyeButtonTapped(textField: self.passwordTextField, eyeButton: self.passwordEyeButton)
            }).disposed(by: rx.disposeBag)
        
        viewModel.passwordIsValidSubject
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { (owner, isValid) in
                owner.passwordErrorLabel.isHidden = isValid
                owner.passwordContainerView.setTextFieldErrorBorder(showError: !isValid)
            }).disposed(by: rx.disposeBag)
        
        confirmPasswordTextField.rx.text.orEmpty
            .bind(to: viewModel.confirmPasswordTextSubjext)
            .disposed(by: rx.disposeBag)
        
        confirmPasswordEyeButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { _ in
                self.eyeButtonTapped(textField: self.confirmPasswordTextField, eyeButton: self.confirmPasswordEyeButton)
            }).disposed(by: rx.disposeBag)
        
        viewModel.confirmPasswordIsValidSubject
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { (owner, isValid) in
                owner.confirmPasswordErrorLabel.isHidden = isValid
                owner.confirmPasswordContainerView.setTextFieldErrorBorder(showError: !isValid)
            }).disposed(by: rx.disposeBag)
        
        viewModel.nextButtonEnabled
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { (owner, isEnabled) in
                owner.nextButton.setEnabled(isEnabled: isEnabled)
            }).disposed(by: rx.disposeBag)
        
        nextButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { _ in
                let email = self.emailTextField.text ?? ""
                let password = self.passwordTextField.text ?? ""
                self.viewModel.moveToSignUp(email: email, password: password)
            }).disposed(by: rx.disposeBag)
    }
    
    private func setNavigationBar() {
        self.navigationItem.titleView = NavigationTitleView(title: "이메일 회원가입")
        self.navigationItem.rightBarButtonItem = NavigationRightBarButtonItem(type: .close, viewController: self)
    }
    
    func eyeButtonTapped(textField: UITextField, eyeButton: UIButton) {
        textField.isSecureTextEntry.toggle()
        eyeButton.isSelected.toggle()
        let eyeImage = eyeButton.isSelected ? UIImage(named: "show_filled") : UIImage(named: "hide_filled")
        eyeButton.setImage(eyeImage, for: .normal)
    }
}

extension EmailSignUpViewController: UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

