//
//  JobOpeningHuntingViewModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/3/23.
//

import UIKit
import RxCocoa
import RxSwift

class JobOpeningHuntingViewModel: CommonViewModel {
    // TODO: API 호출 넣어도 아래 `selectedTab` 필요 없으면 삭제
    var selectedTab = PublishRelay<JobSegmentType>()
    var disposeBag = DisposeBag()
    
    // Dropdown에서 선택한 jobType(ACTOR 혹은 STAFF)
    var selectedJobType = PublishRelay<Job>()
    
    // sortButton 상태(UI+연결화면), filterButton 연결 화면, 플로팅 버튼 상태(UI+연결화면)
    let sortButtonStateDic: [JobSegmentType: JobOpeningSortOptions] = [
        .jobOpening: .recent,
        .profile: .recent
    ]
    
    var jobOpeningsContent: [JobOpeningContent]?
    var reloadTableView = PublishSubject<Void>()
    
    // JobSegmentType(프로필/모집)과 JobType(ACTOR/STAFF)을 알아야 api 쏘므로 ViewModel에  selectedTab, selectedJobType 필요
    func fetchList() {
        // TODO: type 지정
//        jobOpeningInfoProvider.rx.request(.jobOpenings(type: .actor))
        jobOpeningInfoProvider.rx.request(.jobOpenings(type: .staff))
            .mapObject(JobOpeningsInfo.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                print(response)
                owner.jobOpeningsContent = response.data?.jobOpenings?.content
                owner.reloadTableView.onNext(())
            },
                       onError: { error in
                print(error.localizedDescription)
            }).disposed(by: disposeBag)
        
    }
}
