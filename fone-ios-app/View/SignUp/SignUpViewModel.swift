//
//  SignUpViewModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/08/15.
//

import Foundation
import RxSwift

class SignUpViewModel: CommonViewModel {
    var disposeBag = DisposeBag()
    
    func fetchMyPage() {
        userInfoProvider.rx.request(.fetchMyPage)
            .mapObject(UserInfoModel.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                print("received!")
                print("response: \(response)")
                
            }, onError: { error in
                print("\(error)")
            }).disposed(by: disposeBag)
    }
    
    func checkNicknameDuplication(_ nickname: String) {
        userInfoProvider.rx.request(.checkNicknameDuplication(nickname: nickname))
            .mapObject(CheckNicknameDuplicationModel.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                print("received!")
                print("response: \(response)")
                
            }, onError: { error in
                print("\(error)")
            }).disposed(by: disposeBag)
    }
}
