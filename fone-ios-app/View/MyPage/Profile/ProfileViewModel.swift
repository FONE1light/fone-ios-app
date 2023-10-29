//
//  ProfileViewModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/12.
//

import Foundation
import RxSwift
import RxCocoa

class ProfileViewModel: CommonViewModel {
    var disposeBag = DisposeBag()
    
    var nicknameAvailbleState = BehaviorRelay<NicknameAvailableState>(value: .cannotCheck)
    
    func checkNicknameDuplication(_ nickname: String) {
        guard nickname.count >= 3 else { return }
        userInfoProvider.rx.request(.checkNicknameDuplication(nickname: nickname))
            .mapObject(CheckNicknameDuplicationModel.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                if response.data?.isDuplicate == true {
                    owner.nicknameAvailbleState.accept(.duplicated)
                } else {
                    owner.nicknameAvailbleState.accept(.available)
                    "사용할 수 있는 닉네임입니다.".toast(positionType: .withButton)
                }
            }, onError: { error in
                print("\(error)")
                self.nicknameAvailbleState.accept(.available)
                error.localizedDescription.toast(positionType: .withButton)
            }).disposed(by: disposeBag)
    }
    
    func checkNicknameAvailbleState(_ nickname: String?) {
        if let nickname = nickname,
           nickname.count >= 3 {
            self.nicknameAvailbleState.accept(.canCheck)
        } else {
            self.nicknameAvailbleState.accept(.cannotCheck)
        }
    }
}
