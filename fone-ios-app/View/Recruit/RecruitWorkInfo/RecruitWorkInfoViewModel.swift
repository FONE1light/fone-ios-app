//
//  RecruitWorkInfoViewModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 12/7/23.
//

import Foundation
import RxSwift

struct RecruitWorkInfo: Codable {
    let produce: String?
    let workTitle: String?
    let director: String?
    let genres: [String]?
    let logline: String?
}

final class RecruitWorkInfoViewModel: CommonViewModel {
    var disposeBag = DisposeBag()
    var jobType: Job?
    var recruitContactLinkInfo: RecruitContactLinkInfo?
    var recruitBasicInfo: RecruitBasicInfo?
    var recruitConditionInfo: RecruitConditionInfo?
    
    init(sceneCoordinator: SceneCoordinatorType, jobType: Job?, recruitContactLinkInfo: RecruitContactLinkInfo?, recruitBasicInfo: RecruitBasicInfo?, recruitConditionInfo: RecruitConditionInfo?) {
        super.init(sceneCoordinator: sceneCoordinator)
        
        self.jobType = jobType
        self.recruitContactLinkInfo = recruitContactLinkInfo
        self.recruitBasicInfo = recruitBasicInfo
        self.recruitConditionInfo = recruitConditionInfo
    }
    
    func validateProject(recruitWorkInfo: RecruitWorkInfo) {
        validationProvider.rx.request(.validateProject(recruitWorkInfo: recruitWorkInfo))
            .mapObject(Result<String>.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(
                onNext: { owner, response in
                    if response.result?.isSuccess == true {
                        owner.moveToNextStep(recruitWorkInfo: recruitWorkInfo)
                    } else {
                        response.message?.toast(positionType: .withButton)
                    }
                },
                onError: { error in
                    error.showToast(modelType: String.self, positionType: .withButton)
                }
            ).disposed(by: disposeBag)
    }
    
    func moveToNextStep(recruitWorkInfo: RecruitWorkInfo) {
        let recruitWorkConditionViewModel = RecruitWorkConditionViewModel(sceneCoordinator: sceneCoordinator, jobType: jobType, recruitContactLinkInfo: recruitContactLinkInfo, recruitBasicInfo: recruitBasicInfo, recruitConditionInfo: recruitConditionInfo, recruitWorkInfo: recruitWorkInfo)
        let recuirtWorkConditionScene = Scene.recruitWorkCondition(recruitWorkConditionViewModel)
        sceneCoordinator.transition(to: recuirtWorkConditionScene, using: .push, animated: true)
    }
}
