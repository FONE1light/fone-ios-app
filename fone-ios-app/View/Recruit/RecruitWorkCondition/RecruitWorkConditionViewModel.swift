//
//  RecruitWorkConditionViewModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 12/7/23.
//

import UIKit
import RxSwift
import RxRelay
import PanModal

struct RecruitWorkConditionInfo: Codable {
    let workingCity, workingDistrict: String?
    let workingStartDate, workingEndDate: String?
    let selectedDays: [String]?
    let workingStartTime, workingEndTime: String?
    let salaryType: String?
    let salary: Int?
}

struct RegionOption: Options {
    var title: String?
    var serverParameter: String?
}

final class RecruitWorkConditionViewModel: CommonViewModel {
    let disposeBag = DisposeBag()
    var jobType: Job?
    
    let allOption = RegionOption(title: "전체", serverParameter: "전체")
    let salaryType = PublishRelay<SalaryType>()
    
    var recruitContactLinkInfo: RecruitContactLinkInfo?
    var recruitBasicInfo: RecruitBasicInfo?
    var recruitConditionInfo: RecruitConditionInfo?
    var recruitWorkInfo: RecruitWorkInfo?
    
    init(sceneCoordinator: SceneCoordinatorType, jobType: Job?, recruitContactLinkInfo: RecruitContactLinkInfo?, recruitBasicInfo: RecruitBasicInfo?, recruitConditionInfo: RecruitConditionInfo?, recruitWorkInfo: RecruitWorkInfo?) {
        super.init(sceneCoordinator: sceneCoordinator)
        
        self.jobType = jobType
        self.recruitContactLinkInfo = recruitContactLinkInfo
        self.recruitBasicInfo = recruitBasicInfo
        self.recruitConditionInfo = recruitConditionInfo
        self.recruitWorkInfo = recruitWorkInfo
    }
    
    func getRegions(button: UIButton, handler: @escaping (UIAction) -> ()) {
        jobOpeningInfoProvider.rx.request(.getRegions)
            .mapObject(Result<RegionsModel>.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                if let regions = response.data?.regions {
                    var regionsActions: [UIAction] = []
                    for region in regions {
                        let action = UIAction(title: "\(region)", handler: handler)
                        regionsActions.append(action)
                    }
                    button.menu = UIMenu(title: "근무지역",
                                                 options: .singleSelection,
                                                 children: regionsActions)
                    button.showsMenuAsPrimaryAction = true
                }
                
            }).disposed(by: disposeBag)
    }
    
    func getDistricts(button: UIButton, handler: @escaping (UIAction) -> ()) {
        jobOpeningInfoProvider.rx.request(.getRegions)
            .mapObject(Result<RegionsModel>.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                if let regions = response.data?.regions {
                    var regionsActions: [UIAction] = []
                    for region in regions {
                        let action = UIAction(title: "\(region)", handler: handler)
                        regionsActions.append(action)
                    }
                    button.menu = UIMenu(title: "근무지역",
                                                 options: .singleSelection,
                                                 children: regionsActions)
                    button.showsMenuAsPrimaryAction = true
                }
                
            }).disposed(by: disposeBag)
    }
    
    func showSalaryTypeBottomSheet() {
        sceneCoordinator.transition(to: .salaryTypeBottomSheet(sceneCoordinator, salaryType), using: .customModal, animated: true)
    }
    
    func moveToNextStep(recruitWorkConditionInfo: RecruitWorkConditionInfo) {
        let recruitDetailInfoViewModel = RecruitDetailInfoViewModel(sceneCoordinator: sceneCoordinator, jobType: jobType, recruitContactLinkInfo: recruitContactLinkInfo, recruitBasicInfo: recruitBasicInfo, recruitConditionInfo: recruitConditionInfo, recruitWorkInfo: recruitWorkInfo, recruitWorkConditionInfo: recruitWorkConditionInfo)
        let recuirtDetailInfoScene = Scene.recruitDetailInfo(recruitDetailInfoViewModel)
        sceneCoordinator.transition(to: recuirtDetailInfoScene, using: .push, animated: true)
    }
}
