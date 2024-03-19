//
//  FindPasswordCell.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/09/10.
//

import UIKit
import RxSwift

class FindPasswordCell: UICollectionViewCell {
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var authCodeView: UIView!
    @IBOutlet weak var authCodeTextField: UITextField!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var checkAuthCodeButton: UIButton!
    @IBOutlet weak var resetPasswordView: UIView!
    @IBOutlet weak var passwordContainerView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordEyeButton: UIButton!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var confirmPasswordContainerView: UIView!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordEyeButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var resetPasswordButton: UIButton!
    
    
    var viewModel: FindIDPasswordViewModel?
    var timer: Timer?
    var leftSeconds = 180
    var token = ""
    var smsSendedSubject = BehaviorSubject<Bool>(value: false)
    var phoneNumberSubject = BehaviorSubject<String>(value: "")
    
    lazy var phoneNumberIsValidSubject: Observable<Bool> = {
        phoneNumberSubject
            .filter { $0 != "" }
            .map { $0.hasPrefix("010") && $0.count == 11 }
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(viewModel: FindIDPasswordViewModel) {
        self.viewModel = viewModel
        
        phoneNumberTextField.rx.text
            .map { String($0?.prefix(11) ?? "") }
            .bind(to: phoneNumberTextField.rx.text)
            .disposed(by: rx.disposeBag)
        
        phoneNumberTextField.rx.text.orEmpty
            .bind(to: phoneNumberSubject)
            .disposed(by: rx.disposeBag)
        
        phoneNumberIsValidSubject
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { (owner, isValid) in
                owner.sendButton.setMediumButtonEnabled(isEnabled: isValid)
            }).disposed(by: rx.disposeBag)
        
        sendButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                owner.phoneNumberTextField.resignFirstResponder()
                let phoneNumberWithDash = owner.phoneNumberTextField.text?.insertDash()
                owner.viewModel?.requestSMS(phoneNumber: phoneNumberWithDash, resultSubject: owner.smsSendedSubject)
            }).disposed(by: rx.disposeBag)
        
        smsSendedSubject
            .withUnretained(self)
            .subscribe(onNext: { (owner, sended) in
                if sended {
                    owner.sendButton.setTitle("재전송", for: .normal)
                    owner.authCodeView.isHidden = false
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
                owner.validateAuthNumber()
            }).disposed(by: rx.disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .filter { $0 != "" }
            .map { $0.isValidPassword() }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { owner, isValid in
                owner.passwordErrorLabel.isHidden = isValid
                owner.passwordContainerView.setTextFieldErrorBorder(showError: !isValid)
                owner.viewModel?.passwordIsValidSubject.onNext(isValid)
            }).disposed(by: rx.disposeBag)
        
        passwordEyeButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.passwordEyeButton.eyeButtonTapped(textField: owner.passwordTextField)
            }).disposed(by: rx.disposeBag)
        
        confirmPasswordEyeButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.confirmPasswordEyeButton.eyeButtonTapped(textField: owner.confirmPasswordTextField)
            }).disposed(by: rx.disposeBag)
        
        confirmPasswordTextField.rx.text.orEmpty
            .map { $0 == self.passwordTextField.text }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { owner, isSame in
                owner.errorLabel.isHidden = isSame
                owner.confirmPasswordContainerView.setTextFieldErrorBorder(showError: !isSame)
                owner.viewModel?.confirmPasswordIsValidSubjext.onNext(isSame)
            }).disposed(by: rx.disposeBag)
        
        viewModel.resetButtonEnableSubject
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { owner, isEnabled in
                owner.resetPasswordButton.setEnabled(isEnabled: isEnabled)
            }).disposed(by: rx.disposeBag)
        
        resetPasswordButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.resetPassword()
            }).disposed(by: rx.disposeBag)
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
    
    /// 인증번호 유효성 확인
    func validateAuthNumber() {
        let code = authCodeTextField.text ?? ""
        let phoneNumber = phoneNumberTextField.text?.insertDash() ?? ""
        
        userInfoProvider.rx.request(.findPassword(code: code, phoneNumber: phoneNumber))
            .mapObject(FindPasswordResponseModel.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                if response.result == "SUCCESS" {
                    owner.authSuccess()
                    owner.token = response.data?.first?.value ?? ""
                } else {
                    ToastManager.show(
                        "올바른 인증번호를 입력해주세요.",
                        positionType: .withButton
                    )
                }
            }, onError: { error in
                print("\(error)")
            }).disposed(by: rx.disposeBag)
    }
    
    func authSuccess() {
        sendButton.setTitle("인증완료", for: .normal)
        sendButton.setMediumButtonEnabled(isEnabled: false)
        phoneNumberTextField.isUserInteractionEnabled = false
        authCodeView.isHidden = true
        resetPasswordView.isHidden = false
        resetPasswordButton.isHidden = false
        resetPasswordButton.setEnabled(isEnabled: false)
    }
    
    func resetPassword() {
        let password = passwordTextField.text ?? ""
        let phoneNumber = phoneNumberTextField.text?.insertDash() ?? ""
        
        userInfoProvider.rx.request(.resetPassword(password: password, phoneNumber: phoneNumber, token: token))
            .mapObject(SendSMSResponseModel.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                if response.result == "SUCCESS" {
                    owner.showSuccessPopUp()
                } else {
                    response.message.toast(positionType: .withButton)
                }
            }).disposed(by: rx.disposeBag)
    }
    
    func showSuccessPopUp() {
        let alert = UIAlertController.createOneButtonPopup(title: "비밀번호 변경이 완료되었습니다.")
        guard let currentVC = (viewModel?.sceneCoordinator as? SceneCoordinator)?.currentVC else { return }
        currentVC.present(alert, animated: true)
    }
}
