//
//  RecruitBasicInfoViewModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 11/6/23.
//

import UIKit
import RxSwift

struct RecruitBasicInfo: Codable {
    let title: String?
    let categories: [String]?
    let recruitmentStartDate: String?
    let recruitmentEndDate: String?
    let imageUrls: [String]?
}

final class RecruitBasicInfoViewModel: CommonViewModel {
    var disposeBag = DisposeBag()
    var jobType: Job?
    var recruitContactLinkInfo: RecruitContactLinkInfo?
    var imageUrls: [String] = []
    
    init(sceneCoordinator: SceneCoordinatorType, jobType: Job?, recruitContactLinkInfo: RecruitContactLinkInfo) {
        super.init(sceneCoordinator: sceneCoordinator)
        
        self.jobType = jobType
        self.recruitContactLinkInfo = recruitContactLinkInfo
    }
    
    func moveToNextStep(recruitBasicInfo: RecruitBasicInfo) {
        let recruitConditionInfoViewModel = RecruitConditionInfoViewModel(sceneCoordinator: sceneCoordinator, jobType: jobType, recruitContactLinkInfo: recruitContactLinkInfo, recruitBasicInfo: recruitBasicInfo)
        let recuirtConditionInfoScene = Scene.recruitConditionInfo(recruitConditionInfoViewModel)
        sceneCoordinator.transition(to: recuirtConditionInfoScene, using: .push, animated: true)
    }
}

extension RecruitBasicInfoViewModel {
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
                if response.result == "SUCCESS" {
                    let imageUrls = (response.data ?? []).map { $0.imageUrl ?? "" }
                    completion(imageUrls)
                } else {
                    response.message?.toast(positionType: .withButton)
                }
            }, onError: { error in
                error.localizedDescription.toast(positionType: .withButton)
            }).disposed(by: disposeBag)
    }
}
