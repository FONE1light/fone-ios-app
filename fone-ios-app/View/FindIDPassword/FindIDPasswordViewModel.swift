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
    var passwordIsValidSubject = BehaviorSubject<Bool>(value: false)
    var confirmPasswordIsValidSubjext = BehaviorSubject<Bool>(value: false)
    
    lazy var resetButtonEnableSubject: Observable<Bool> = {
        Observable.combineLatest(passwordIsValidSubject, confirmPasswordIsValidSubjext)
            .map { $0 && $1 }
    }()
    
    func requestSMS(phoneNumber: String?, resultSubject: BehaviorSubject<Bool>) {
        guard let phoneNumber = phoneNumber else { return }
        
        userInfoProvider.rx.request(.sendSMS(phoneNumber: phoneNumber))
            .mapObject(SendSMSResponseModel.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                let result = response.result == "SUCCESS"
                resultSubject.onNext(result)
                ToastManager.show(response.message, positionType: .withButton)
            }).disposed(by: disposeBag)
    }
}
