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
    
    // sortButton 상태(UI+연결화면), filterButton 연결 화면, 플로팅 버튼 상태(UI+연결화면)
    let sortButtonStateDic: [JobSegmentType: JobOpeningSortOptions] = [
        .jobOpening: .recent,
        .profile: .recent
    ]
}
