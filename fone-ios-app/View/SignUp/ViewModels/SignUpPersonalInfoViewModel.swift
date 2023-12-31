//
//  SignUpPersonalInfoViewModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 10/20/23.
//

import UIKit
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
    
    // 이전 화면에서 넘어온 데이터
    var signInInfo: SignInInfo?
    var signUpSelectionInfo: SignUpSelectionInfo?
    
    // 현재 화면에서 사용하는 값
    var nickname: String?
    var birthday: String?
    var gender: GenderType?
    var profileUrl: String?
    
    var nicknameAvailbleState = BehaviorRelay<NicknameAvailableState>(value: .cannotCheck)
    var profileImage = PublishRelay<UIImage>()
    
    func checkNicknameDuplication(_ nickname: String) {
        guard nickname.count >= 3 && nickname.count <= 8 else { return }
        userInfoProvider.rx.request(.checkNicknameDuplication(nickname: nickname))
            .mapObject(CheckNicknameDuplicationModel.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                if response.data?.isDuplicate == false {
                    owner.nickname = nickname
                    owner.nicknameAvailbleState.accept(.available)
                    "사용할 수 있는 닉네임입니다.".toast(positionType: .withButton)
                } else {
                    owner.nicknameAvailbleState.accept(.duplicated)
                }
            }, onError: { error in
                error.localizedDescription.toast(positionType: .withButton)
            }).disposed(by: disposeBag)
    }
}

extension SignUpPersonalInfoViewModel {
    /// 닉네임을 형식에 맞게 수정하여 반환
    /// - 8글자까지 입력 가능
    func formatNickname(_ nickname: String?) -> String? {
        guard let nickname = nickname else { return nil }
        
        return nickname.prefixString(8)
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

extension SignUpPersonalInfoViewModel {
    func uploadProfileImage(_ pickedImage: UIImage) {
        // 필요 시 compressionQuality 조정
        let imageData = pickedImage.jpegData(compressionQuality: 0.1)?.base64EncodedString() ?? ""
        let imageInfo = ImageInfoToUpload(
            imageData: imageData,
            resource: "/image-upload/user-profile",
            stageVariables: StageVariables(stage: "prod")
        )
        
        let imageUploadRequestModel = ImageUploadRequestModel(images: [imageInfo])
        imageUploadProvider.rx.request(.uploadImage(images: imageUploadRequestModel))
            .mapObject(ImageUploadResponseModel.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                if response.result == "SUCCESS" {
                    owner.profileUrl = response.data?.first?.imageUrl
                    owner.profileImage.accept(pickedImage)
                } else {
                    response.message?.toast(positionType: .withButton)
                }
            }, onError: { error in
                error.localizedDescription.toast(positionType: .withButton)
            }).disposed(by: disposeBag)
    }
}

extension SignUpPersonalInfoViewModel {
    func moveToSignUpPhoneNumber() {
        let sceneCoordinator = sceneCoordinator
        let phoneNumberViewModel = SignUpPhoneNumberViewModel(sceneCoordinator: sceneCoordinator)
        phoneNumberViewModel.signInInfo = signInInfo
        phoneNumberViewModel.signUpSelectionInfo = signUpSelectionInfo
        phoneNumberViewModel.signUpPersonalInfo = SignUpPersonalInfo(
            nickname: nickname,
            birthday: birthday,
            gender: gender?.name,
            profileURL: profileUrl
        )
        
        let signUpScene = Scene.signUpPhoneNumber(phoneNumberViewModel)
        sceneCoordinator.transition(to: signUpScene, using: .push, animated: true)
    }
}
