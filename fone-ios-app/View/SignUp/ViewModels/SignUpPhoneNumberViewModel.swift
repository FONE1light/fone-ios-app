//
//  SignUpPhoneNumberViewModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/10.
//

import Foundation
import RxSwift
import RxCocoa

enum PhoneNumberAvailableState {
    /// 인증번호 발송(버튼 활성화)
    case cannotCheck
    /// 인증번호 발송 불가능(버튼 비활성화)
    case canCheck
    /// 인증번호 발송 완료('재전송' 표시)
    case sent
    /// 인증 완료
    case available
}

enum AuthNumberState {
    case cannotCheck
    case canCheck
    case authorized
}

class SignUpPhoneNumberViewModel: CommonViewModel {
    
    var disposeBag = DisposeBag()
    
    // 이전 화면에서 넘어온 데이터
    var signInInfo: EmailSignInInfo?
    var signUpSelectionInfo: SignUpSelectionInfo?
    var signUpPersonalInfo: SignUpPersonalInfo?
    
    // 현재 화면에서 사용하는 값
    var phoneNumber: String?
    var agreeToTermsOfServiceTermsOfUse: Bool?
    var agreeToPersonalInformation: Bool?
    var isReceiveMarketing: Bool?
    
    var phoneNumberAvailbleState = BehaviorRelay<PhoneNumberAvailableState>(value: .cannotCheck)
    
    var authNumberState = BehaviorRelay<AuthNumberState>(value: .cannotCheck)
    var stringLeftSeconds = PublishRelay<String>()
    
    private var timer: Timer?
    private var leftSeconds = 180
    
    /// 휴대전화번호가 유효한지(자릿수 체크) 확인
    func checkPhoneNumberState(_ phoneNumber: String?) {
        if let phoneNumber = phoneNumber,
           phoneNumber.count == 11 {
            self.phoneNumberAvailbleState.accept(.canCheck)
        } else {
            self.phoneNumberAvailbleState.accept(.cannotCheck)
        }
    }
    
    /// 휴대전화번호를 형식에 맞게 수정하여 반환
    /// - 11글자까지 입력 가능
    func formatPhoneNumberString(_ phoneNumber: String?) -> String? {
        guard let phoneNumber = phoneNumber else { return nil }
        
        var newPhoneNumber = phoneNumber.replacingOccurrences(of: "-", with: "")
        newPhoneNumber = newPhoneNumber.prefixString(11)
        
        return newPhoneNumber
    }
    
    /// 인증번호를 검증할 수 있는지 아닌지 확인
    func checkAuthNumberState(_ authNumber: String?) {
        guard authNumber?.count == 6 else {
            authNumberState.accept(.cannotCheck)
            return
        }
        authNumberState.accept(.canCheck)
    }
    
    /// 인증번호 전송
    func sendAuthNumber() {
        ToastManager.show(
            "인증번호를 전송하였습니다.\n(인증번호: 000000)",
            positionType: .withButton
        )
        // TODO: 인증번호 전송 API
        
        startTimer()
        
        phoneNumberAvailbleState.accept(.sent)
    }
    
    /// 인증번호 유효성 확인
    func validateAuthNumber(phoneNumber: String?, authNumber: String?) {
        // TODO: 인증번호 확인 API, 결과 따라 분기
        if authNumber == "000000" {
            phoneNumberAvailbleState.accept(.available)
            authNumberState.accept(.authorized)
            self.phoneNumber = phoneNumber
        } else {
            ToastManager.show(
                "올바른 인증번호를 입력해주세요.",
                positionType: .withButton
            )
        }
    }
    
    func signUp() {
        // TODO: 구조 고려해서 채우기
        let emailSignUpInfo = EmailSignUpInfo(
//            name: signInInfo?.name ?? "",
            name: "<SIGNININFO.NAME>",
            email: signInInfo?.email ?? "",
            password: signInInfo?.password ?? "",
            
            job: signUpSelectionInfo?.job ?? "",
            interests: signUpSelectionInfo?.interests ?? [],
            
            nickname: signUpPersonalInfo?.nickname ?? "",
            birthday: signUpPersonalInfo?.birthday ?? "",
            gender: signUpPersonalInfo?.gender ?? "",
            profileUrl: signUpPersonalInfo?.profileURL ?? "",
            
            phoneNumber: phoneNumber ?? "",
            agreeToTermsOfServiceTermsOfUse: agreeToTermsOfServiceTermsOfUse ?? false,
            agreeToPersonalInformation: agreeToPersonalInformation ?? false,
            isReceiveMarketing: isReceiveMarketing ?? false,
            token: "<ACCESSTOKEN?>", // accessToken?
            identifier: "<USER.IDENTIFIER?>"// user.identifier
        )
        
        userInfoProvider.rx.request(.emailSignUp(emailSignUpInfo))
            .mapObject(EmailSignUpResponseModel.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                print("received!")
                print("response: \(response)")
                // TODO: 화면 이동 로직 위치 재고 - VC or VM
                if response.result == "SUCCESS" {
                    let successViewModel = SignUpSuccessViewModel(sceneCoordinator: self.sceneCoordinator)
                    let signUpScene = Scene.signUpSuccess(successViewModel)
                    self.sceneCoordinator.transition(to: signUpScene, using: .push, animated: true)
                } else {
                    response.message.toast(positionType: .withButton)
                }
            }, onError: { error in
                "\(error)".toast(positionType: .withButton)
            }).disposed(by: disposeBag)
        
    }
}

extension SignUpPhoneNumberViewModel {
    
    private func startTimer() {
        leftSeconds = 180
        
        // 기존에 타이머 동작중이면 중지 처리
        if let timer = timer, timer.isValid {
            timer.invalidate()
        }
        
        // 1초 간격 타이머 시작
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTime() {
        if leftSeconds > 0 {
            leftSeconds -= 1
            let timerString = String(format:"%02d:%02d", Int(leftSeconds/60), leftSeconds%60)
            stringLeftSeconds.accept(timerString)
        } else {
            timer?.invalidate()
            timer = nil
            stringLeftSeconds.accept("00:00")
        }
    }
}
