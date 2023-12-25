//
//  JobOpeningHuntingViewModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/3/23.
//

import UIKit
import RxCocoa

class JobOpeningHuntingViewModel: CommonViewModel {
    // TODO: API 호출 넣어도 아래 `selectedTab` 필요 없으면 삭제
    var selectedTab = PublishRelay<JobSegmentType>()
    
    // Dropdown에서 선택한 jobType(ACTOR 혹은 STAFF)
    var selectedJobType = PublishRelay<Job>()
    
    // sortButton 상태(UI+연결화면), filterButton 연결 화면, 플로팅 버튼 상태(UI+연결화면)
    let sortButtonStateDic: [JobSegmentType: JobOpeningSortOptions] = [
        .jobOpening: .recent,
        .profile: .recent
    ]
    
    func showFilter() {
        let filterViewModel = FilterViewModel(sceneCoordinator: sceneCoordinator)
        let filterScene = Scene.filter(filterViewModel)
        sceneCoordinator.transition(to: filterScene, using: .fullScreenModal, animated: true)
    }
    
    // JobSegmentType(프로필/모집)과 JobType(ACTOR/STAFF)을 알아야 api 쏘므로 ViewModel에  selectedTab, selectedJobType 필요
//    func fetchList()
}
