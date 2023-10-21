//
//  FindIDPasswordViewModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/08/07.
//

import Foundation
import RxSwift

class FindIDPasswordViewModel: CommonViewModel {
    var disposeBag = DisposeBag()
    
    func requestSMS(phoneNumber: String?, resultSubject: BehaviorSubject<Bool>) {
        guard let phoneNumber = phoneNumber else { return }
        
        userInfoProvider.rx.request(.sendSMS(phoneNumber: phoneNumber))
            .mapObject(SendSMSResponseModel.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                let result = response.result == "SUCCESS"
                resultSubject.onNext(result)
                if result {
                    ToastManager.show(
                        "인증번호를 전송하였습니다.\n(인증번호: 000000)",
                        positionType: .withButton
                    )
                } else {
                    ToastManager.show(response.message, positionType: .withButton)
                }
            }).disposed(by: disposeBag)
    }
}
