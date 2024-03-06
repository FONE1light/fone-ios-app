//
//  RecruitWorkConditionViewModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 12/7/23.
//

import Foundation
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
    var regions: [String] = []
    var selectedRegion = PublishRelay<String>()
    var showRegionBottomSheetSubject = PublishSubject<Void>()
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
    
    func getRegions() {
        jobOpeningInfoProvider.rx.request(.getRegions)
            .mapObject(Result<RegionsModel>.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                if let regions = response.data?.regions {
                    owner.regions = regions
                    owner.showRegionBottomSheetSubject.onNext(())
                    owner.showRegionsBottomSheet()
                }
                
            }).disposed(by: disposeBag)
    }
    
    /// 지역 바텀시트 노출
    func showRegionsBottomSheet() {
//        let regionsBottomSheetViewModel = RegionsBottomSheetViewModel(
//            sceneCoordinator: sceneCoordinator,
//            selectedItem: "전체",
//            list: regions
//        ) { [weak self] selectedText in
//            guard let self = self else { return }
//            self.selectedRegion.accept(selectedText)
//            self.sceneCoordinator.close(animated: true)
//        }
//        let scene = Scene.regionsBottomSheet(regionsBottomSheetViewModel)
//        sceneCoordinator.transition(to: scene, using: .customModal, animated: true)
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
