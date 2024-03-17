//
//  EmailSignUpViewController.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/09/02.
//

import UIKit

class EmailSignUpViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: EmailSignUpViewModel!
    var timer: Timer?
    var leftSeconds = 180
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var emailConfirmButton: UIButton!
    @IBOutlet weak var emailAuthCodeView: UIView!
    @IBOutlet weak var authCodeTextField: UITextField!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var checkAuthCodeButton: UIButton!
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
            .withUnretained(self)
            .bind { owner, _ in
                let email = owner.emailTextField.text ?? ""
                owner.viewModel.checkEmail(email: email)
            }.disposed(by: rx.disposeBag)
        
        viewModel.emailSendedSubject
            .withUnretained(self)
            .subscribe(onNext: { (owner, sended) in
                if sended {
                    owner.emailConfirmButton.setTitle("재전송", for: .normal)
                    owner.emailAuthCodeView.isHidden = false
                    owner.startTimer()
                }
            }).disposed(by: rx.disposeBag)
        
        authCodeTextField.rx.text.orEmpty
            .map { $0.count == 6 }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { owner, isEnabled in
                owner.checkAuthCodeButton.setMediumButtonEnabled(isEnabled: isEnabled)
            }).disposed(by: rx.disposeBag)
        
        checkAuthCodeButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.timer?.invalidate()
                owner.timer = nil
                let code = owner.authCodeTextField.text ?? ""
                let email = owner.emailTextField.text ?? ""
                owner.validateAuthNumber(code: code, email: email)
            }).disposed(by: rx.disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.passwordTextSubject)
            .disposed(by: rx.disposeBag)
        
        passwordEyeButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { _ in
                self.passwordEyeButton.eyeButtonTapped(textField: self.passwordTextField)
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
                self.confirmPasswordEyeButton.eyeButtonTapped(textField: self.confirmPasswordTextField)
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
                let name = self.nameTextField.text ?? ""
                let email = self.emailTextField.text ?? ""
                let password = self.passwordTextField.text ?? ""
                self.viewModel.moveToSignUp(
                    name: name,
                    email: email,
                    password: password
                )
            }).disposed(by: rx.disposeBag)
    }
    
    private func setNavigationBar() {
        self.navigationItem.titleView = NavigationTitleView(title: "이메일 회원가입")
        self.navigationItem.rightBarButtonItem = NavigationRightBarButtonItem(type: .close, viewController: self)
    }
    
    func startTimer() {
        leftSeconds = 180
        //기존에 타이머 동작중이면 중지 처리
        if let timer = timer, timer.isValid {
            timer.invalidate()
        }
        
        //1초 간격 타이머 시작
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        if leftSeconds > 0 {
            leftSeconds -= 1
            let timerString = String(format:"%02d:%02d", Int(leftSeconds/60), leftSeconds%60)
            timeLabel.text = timerString
        } else {
            timer?.invalidate()
            timer = nil
            timeLabel.text = "00:00"
        }
    }
    
    func validateAuthNumber(code: String, email: String) {
        userInfoProvider.rx.request(.validateEmail(code: code, email: email))
            .mapObject(FindPasswordResponseModel.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                if response.result == "SUCCESS" {
                    owner.authSuccess()
                } else {
                    ToastManager.show(
                        "올바른 인증번호를 입력해주세요.",
                        positionType: .withBottomSheet
                    )
                }
            }, onError: { error in
                print("\(error)")
            }).disposed(by: rx.disposeBag)
    }
    
    func authSuccess() {
        emailConfirmButton.setTitle("인증완료", for: .normal)
        emailConfirmButton.setMediumButtonEnabled(isEnabled: false)
        emailTextField.isUserInteractionEnabled = false
        emailAuthCodeView.isHidden = true
    }
}

extension EmailSignUpViewController: UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

