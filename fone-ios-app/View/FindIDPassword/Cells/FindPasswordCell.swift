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
    @IBOutlet weak var authCodeView: UIView!
    @IBOutlet weak var authCodeTextField: UITextField!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var checkAuthCodeButton: UIButton!
    @IBOutlet weak var resetPasswordView: UIView!
    @IBOutlet weak var resetPasswordButton: UIButton!
    
    var viewModel: FindIDPasswordViewModel?
    var timer: Timer?
    var leftSeconds = 180
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
            .subscribe(onNext: { (owner, _) in
                owner.timer?.invalidate()
                owner.timer = nil
                owner.validateAuthNumber()
                owner.resetPasswordView.isHidden = false
                owner.resetPasswordButton.isHidden = false
                owner.resetPasswordButton.setEnabled(isEnabled: true)
            }).disposed(by: rx.disposeBag)
        
        resetPasswordButton.rx.tap
            .subscribe(onNext: {
                self.showSuccessPopUp()
            }).disposed(by: rx.disposeBag)
    }
    
    func startTimer() {
        //기존에 타이머 동작중이면 중지 처리
        if timer != nil && timer!.isValid {
            timer!.invalidate()
            leftSeconds = 180
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
        // TODO: 인증번호 확인 API, 결과 따라 분기
        if authCodeTextField.text == "000000" {
            timeLabel.text = ""
            sendButton.setTitle("인증완료", for: .normal)
            sendButton.setMediumButtonEnabled(isEnabled: false)
            phoneNumberTextField.isUserInteractionEnabled = false
            authCodeView.isHidden = true
        } else {
            ToastManager.show(
                "올바른 인증번호를 입력해주세요.",
                positionType: .withButton
            )
        }
    }
    
    func showSuccessPopUp() {
        let alert = UIAlertController.init(title: "", message: "비밀번호 변경이 완료되었습니다.", preferredStyle: .alert)
        alert.view.tintColor = UIColor.gray_161616
        let action = UIAlertAction(title: "확인", style: .default)
        alert.addAction(action)
        let sceneCoordinator = viewModel?.sceneCoordinator as? SceneCoordinator
        let currentVC = sceneCoordinator?.currentVC
        currentVC?.present(alert, animated: true)
    }
}
