//
//  RegisterBasicInfoViewModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/18/23.
//

import UIKit
import RxSwift

class RegisterBasicInfoViewModel: CommonViewModel {
    
    let disposeBag = DisposeBag()
    var jobType: Job?
    
    private var registerContactLinkInfo: RegisterContactLinkInfo
    
    init(
        sceneCoordinator: SceneCoordinatorType,
        jobType: Job?,
        registerContactLinkInfo: RegisterContactLinkInfo
    ) {
        self.jobType = jobType
        self.registerContactLinkInfo = registerContactLinkInfo
        super.init(sceneCoordinator: sceneCoordinator)
    }
    
    func uploadImages(images: [UIImage], completion: @escaping ([String]) -> ())  {
        guard !images.isEmpty else {
            completion([])
            return
        }
        
        let imageDatas = images.map {
            $0.jpegData(compressionQuality: 0.1)?.base64EncodedString() ?? ""
        }
        
        let imageInfo: [ImageInfoToUpload] = imageDatas.map { ImageInfoToUpload(
            imageData: $0,
            resource: "/image-upload/user-profile",
            stageVariables: StageVariables(stage: "prod"))
        }
        
        let imageUploadRequestModel = ImageUploadRequestModel(images: imageInfo)
        imageUploadProvider.rx.request(.uploadImage(images: imageUploadRequestModel))
            .mapObject(ImageUploadResponseModel.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                if response.result?.isSuccess == true {
                    let imageUrls = (response.data ?? []).map { $0.imageUrl ?? "" }
                    completion(imageUrls)
                } else {
                    response.message?.toast(positionType: .withButton)
                }
            }, onError: { error in
                error.localizedDescription.toast(positionType: .withButton)
            }).disposed(by: disposeBag)
    }
    
    func validate(name: String?, hookingComment: String?, profileImages: [String]?) {
        let basicInfoRequest = RegisterBasicInfo(
            name: name,
            hookingComment: hookingComment,
            profileImages: profileImages,
            representativeImageURL: profileImages?.first
        )
        
        profileInfoProvider.rx.request(.validateBasicInfo(request: basicInfoRequest))
            .mapObject(Result<String>.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(
                onNext: { owner, response in
                    if response.result?.isSuccess == true {
                        owner.moveToRegisterDetailInfo(basicInfoRequest)
                    } else {
                        response.message?.toast(positionType: .withButton)
                    }
                },
                onError: { error in
                    error.showToast(modelType: String.self, positionType: .withButton)
                }
            ).disposed(by: disposeBag)
    }
    
    private func moveToRegisterDetailInfo(_ registerBasicInfo: RegisterBasicInfo) {
        let sceneCoordinator = sceneCoordinator
        
        var scene: Scene
        
        switch jobType {
        case .actor:
            let registerDetailInfoViewModel = RegisterDetailInfoActorViewModel(
                sceneCoordinator: sceneCoordinator,
                registerContactLinkInfo: registerContactLinkInfo,
                registerBasicInfo: registerBasicInfo
            )
            scene = Scene.registerDetailInfoActor(registerDetailInfoViewModel)
        case .staff:
            let registerDetailInfoStaffViewModel = RegisterDetailInfoStaffViewModel(
                sceneCoordinator: sceneCoordinator,
                registerContactLinkInfo: registerContactLinkInfo,
                registerBasicInfo: registerBasicInfo
            )
            scene = Scene.registerDetailInfoStaff(registerDetailInfoStaffViewModel)
        default: return
        }
        
        sceneCoordinator.transition(to: scene, using: .push, animated: true)
    }
}
