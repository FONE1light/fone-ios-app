//
//  SignUpPersonalInfoViewModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 10/20/23.
//

import Foundation
import RxSwift
import RxCocoa

enum NicknameAvailableState {
    /// 중복확인 가능(버튼 활성화)
    case cannotCheck
    /// 중복확인 불가능(버튼 비활성화)
    case canCheck
    /// 닉네임 중복
    case duplicated
    /// 닉네임 사용 가능
    case available
}

class SignUpPersonalInfoViewModel: CommonViewModel {
    var disposeBag = DisposeBag()
    
    var signInInfo: EmailSignInInfo?
    var signUpSelectionInfo: SignUpSelectionInfo?
    
    var nickname: String?
    var birthday: String?
    var gender: String?
    var profileUrl: String?
    
    var nicknameAvailbleState = BehaviorRelay<NicknameAvailableState>(value: .cannotCheck)
    
    func checkNicknameDuplication(_ nickname: String) {
        guard nickname.count >= 3 else { return }
        userInfoProvider.rx.request(.checkNicknameDuplication(nickname: nickname))
            .mapObject(CheckNicknameDuplicationModel.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                print("received!")
                print("response: \(response)")
                if response.data.isDuplicate {
                    owner.nicknameAvailbleState.accept(.duplicated)
                } else {
                    owner.nickname = nickname
                    owner.nicknameAvailbleState.accept(.available)
                    "사용할 수 있는 닉네임입니다.".toast(positionType: .withButton)
                }
            }, onError: { error in
                print("\(error)")
                self.nicknameAvailbleState.accept(.available)
                error.localizedDescription.toast(positionType: .withButton)
            }).disposed(by: disposeBag)
    }
}

extension SignUpPersonalInfoViewModel {
    /// 생년월일을 형식에 맞게 수정하여 반환
    /// - 마지막은 숫자(유저가 직접 dash를 지우는 일이 없도록 함)
    /// - 4글자, 6글자 초과 시 dash 추가
    /// - 8글자까지 입력 가능
    func formatBirthString(_ birth: String?) -> String? {
        guard let birth = birth else { return nil }

        if birth.last == "-" {
            return String(birth.prefix(birth.count - 1))
        }
        
        var birthNumbers = birth.replacingOccurrences(of: "-", with: "")
        birthNumbers = String(birthNumbers.prefix(8))
        
        var newBirthString = birthNumbers
        
        if birthNumbers.count > 6 {
            newBirthString.insert("-", at: newBirthString.index(newBirthString.startIndex, offsetBy: 6))
        }
        
        if birthNumbers.count > 4 {
            newBirthString.insert("-", at: newBirthString.index(newBirthString.startIndex, offsetBy: 4))
        }
        
        return newBirthString
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
