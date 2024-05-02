//
//  RecruitConditionInfoViewModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 12/5/23.
//

import Foundation
import RxSwift
import RxRelay

struct RecruitConditionInfo: Codable {
    let casting: String?
    let domains: [String]?
    let numberOfRecruits: Int?
    let gender: String?
    let ageMin, ageMax: Int?
    let careers: [String]?
}

final class RecruitConditionInfoViewModel: CommonViewModel {
    var disposeBag = DisposeBag()
    var jobType: Job?
    var recruitContactLinkInfo: RecruitContactLinkInfo?
    var recruitBasicInfo: RecruitBasicInfo?
    let selectedDomains = BehaviorRelay<[Selection]>(value: [])
    
    init(sceneCoordinator: SceneCoordinatorType, jobType: Job?, recruitContactLinkInfo: RecruitContactLinkInfo?, recruitBasicInfo: RecruitBasicInfo?) {
        super.init(sceneCoordinator: sceneCoordinator)
        
        self.jobType = jobType
        self.recruitContactLinkInfo = recruitContactLinkInfo
        self.recruitBasicInfo = recruitBasicInfo
    }
    
    func validateRole(recruitConditionInfo: RecruitConditionInfo) {
        validationProvider.rx.request(.validateRole(recruitConditionInfo: recruitConditionInfo))
            .mapObject(Result<String>.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(
                onNext: { owner, response in
                    if response.result?.isSuccess == true {
                        owner.moveToNextStep(recruitConditionInfo: recruitConditionInfo)
                    } else {
                        response.message?.toast(positionType: .withButton)
                    }
                },
                onError: { error in
                    error.showToast(modelType: String.self, positionType: .withButton)
                }
            ).disposed(by: disposeBag)
    }
    
    func moveToNextStep(recruitConditionInfo: RecruitConditionInfo) {
        let recruitWorkInfoViewModel = RecruitWorkInfoViewModel(sceneCoordinator: sceneCoordinator, jobType: jobType, recruitContactLinkInfo: recruitContactLinkInfo, recruitBasicInfo: recruitBasicInfo, recruitConditionInfo: recruitConditionInfo)
        let recruitWorkInfoScene = Scene.recruitWorkInfo(recruitWorkInfoViewModel)
        sceneCoordinator.transition(to: recruitWorkInfoScene, using: .push, animated: true)
    }
}
