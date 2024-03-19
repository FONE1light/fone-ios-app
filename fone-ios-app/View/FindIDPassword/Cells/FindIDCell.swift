//
//  FindIDCell.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/09/10.
//

import UIKit
import RxSwift

class FindIDCell: UICollectionViewCell {
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var authCodeView: UIView!
    @IBOutlet weak var authCodeTextField: UITextField!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var checkAuthCodeButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var goToLoginButton: UIButton!
    
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
            .subscribe(onNext: { (owner, _) in
                owner.timer?.invalidate()
                owner.timer = nil
                owner.validateAuthNumber()
            }).disposed(by: rx.disposeBag)
        
        goToLoginButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                guard let sceneCoordinator = owner.viewModel?.sceneCoordinator else { return }
                let loginViewModel = LoginViewModel(sceneCoordinator: sceneCoordinator)
                let loginScene = Scene.login(loginViewModel)
                sceneCoordinator.transition(to: loginScene, using: .root, animated: true)
            }).disposed(by: rx.disposeBag)
    }
    
    func startTimer() {
        leftSeconds = 180
        //기존에 타이머 동작중이면 중지 처리
        if let timer = timer, timer.isValid {
            timer.invalidate()
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
        let code = authCodeTextField.text ?? ""
        let phoneNumber = phoneNumberTextField.text?.insertDash() ?? ""
        
        userInfoProvider.rx.request(.findID(code: code, phoneNumber: phoneNumber))
            .mapObject(FindIDResponseModel.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                if response.result == "SUCCESS" {
                    if let data = response.data {
                        owner.showFindIDResult(data: data)
                    }
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
    
    func showFindIDResult(data: FindIDResponseData) {
        var resultString = ""
        switch data.loginType {
        case "PASSWORD": // FIXME: loginType enum으로 수정
            resultString = "이메일은 \(data.email) 입니다."
        case "KAKAO":
            resultString = "이미 카카오톡 계정으로 가입한 회원입니다."
        case "GOOGLE":
            resultString = "이미 구글 계정으로 가입한 회원입니다."
        case "APPLE":
            resultString = "이미 애플 계정으로 가입한 회원입니다."
        default:
            resultString = ""
        }
        
        resultLabel.isHidden = false
        resultLabel.text = resultString
        sendButton.setTitle("인증완료", for: .normal)
        sendButton.setMediumButtonEnabled(isEnabled: false)
        phoneNumberTextField.isUserInteractionEnabled = false
        authCodeView.isHidden = true
        goToLoginButton.isHidden = false
        goToLoginButton.setEnabled(isEnabled: true)
    }
}
