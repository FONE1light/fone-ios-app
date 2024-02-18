//
//  RecruitDetailInfoViewModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 12/10/23.
//

import Foundation
import RxSwift
import Moya

struct RecruitDetailInfo: Codable {
    let details: String?
}

final class RecruitDetailInfoViewModel: CommonViewModel {
    let disposeBag = DisposeBag()
    var jobType: Job?
    var recruitContactLinkInfo: RecruitContactLinkInfo?
    var recruitBasicInfo: RecruitBasicInfo?
    var recruitConditionInfo: RecruitConditionInfo?
    var recruitWorkInfo: RecruitWorkInfo?
    var recruitWorkConditionInfo: RecruitWorkConditionInfo?
    
    init(sceneCoordinator: SceneCoordinatorType, jobType: Job?, recruitContactLinkInfo: RecruitContactLinkInfo?, recruitBasicInfo: RecruitBasicInfo?, recruitConditionInfo: RecruitConditionInfo?, recruitWorkInfo: RecruitWorkInfo?, recruitWorkConditionInfo: RecruitWorkConditionInfo?) {
        super.init(sceneCoordinator: sceneCoordinator)
        
        self.jobType = jobType
        self.recruitContactLinkInfo = recruitContactLinkInfo
        self.recruitBasicInfo = recruitBasicInfo
        self.recruitConditionInfo = recruitConditionInfo
        self.recruitWorkInfo = recruitWorkInfo
        self.recruitWorkConditionInfo = recruitWorkConditionInfo
    }
    
    func validateSummary(recruitDetailInfo: RecruitDetailInfo) {
        validationProvider.rx.request(.validateSummary(recruitDetailInfo: recruitDetailInfo))
            .mapObject(Result<String?>.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                if response.result == "SUCCESS" {
                    owner.moveToNextStep(recruitDetailInfo: recruitDetailInfo)
                }
            }, onError: { error in
                if let data = (error as? MoyaError)?.response?.data {
                    let decoder = JSONDecoder()
                    do {
                        let result = try decoder.decode(Result<String>.self, from: data)
                        result.message?.toast(positionType: .withButton)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    func moveToNextStep(recruitDetailInfo: RecruitDetailInfo) {
        let recruitContactInfoViewModel = RecruitContactInfoViewModel(sceneCoordinator: sceneCoordinator, jobType: jobType, recruitContactLinkInfo: recruitContactLinkInfo, recruitBasicInfo: recruitBasicInfo, recruitConditionInfo: recruitConditionInfo, recruitWorkInfo: recruitWorkInfo, recruitWorkConditionInfo: recruitWorkConditionInfo, recruitDetailInfo: recruitDetailInfo)
        let recuirtContactInfoScene = Scene.recruitContactInfo(recruitContactInfoViewModel)
        sceneCoordinator.transition(to: recuirtContactInfoScene, using: .push, animated: true)
    }
}
