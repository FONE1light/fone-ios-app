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
    /// 재전송
    case resend
    /// 인증 완료
    case available
}

class SignUpPhoneNumberViewModel: CommonViewModel {
    
    var phoneNumberAvailbleState = BehaviorRelay<PhoneNumberAvailableState>(value: .cannotCheck)
    
    func checkPhoneNumberState(_ phoneNumber: String?) {
        if let phoneNumber = phoneNumber,
           phoneNumber.count == 11 {
            self.phoneNumberAvailbleState.accept(.canCheck)
        } else {
            self.phoneNumberAvailbleState.accept(.cannotCheck)
        }
    }
    
    
}
