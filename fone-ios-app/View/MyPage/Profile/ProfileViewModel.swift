//
//  ProfileViewModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/12.
//

import UIKit
import RxSwift
import RxCocoa
import Moya

class ProfileViewModel: CommonViewModel {
    var disposeBag = DisposeBag()
    
    var profileUrl: String?
    var profileImage = PublishRelay<UIImage>()
    
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
            }, onError: { [weak self] error in
                error.showToast(modelType: User.self, positionType: .withButton)
                
                guard let self = self else { return }
                guard let response = (error as? MoyaError)?.response,
                      let errorData = try? response.mapObject(Result<User>.self) else { return }
                if errorData.errorCode == "DuplicateUserNicknameException" {
                    self.nicknameAvailbleState.accept(.duplicated)
                }
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
    
    func modifyInfo(_ userInfo: UserInfo) {
        userInfoProvider.rx.request(.modifyUserInfo(userInfo: userInfo))
            .mapObject(Result<User>.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                if response.result == "SUCCESS" {
                    "수정이 완료되었습니다.".toast(positionType: .withButton)
                } else {
                    response.message?.toast(positionType: .withButton)
                }
            }, onError: { error in
                guard let response = (error as? MoyaError)?.response,
                      let errorData = try? response.mapObject(Result<String>.self) else { return }
                errorData.message?.toast(positionType: .withButton)
            }).disposed(by: disposeBag)
    }
}

extension ProfileViewModel {
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
                    "[실패] 사진이 업로드 되지 않았습니다.".toast(positionType: .withButton)
                    print(response.message ?? "")
                }
            }, onError: { error in
                "[실패] 사진이 업로드 되지 않았습니다.".toast(positionType: .withButton)
                print(error)
            }).disposed(by: disposeBag)
    }
}
