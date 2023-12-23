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
    
    // TODO: 회원가입시 자신이 직업 선택한 분야로 초기값 지정(STAFF->STAFF, 나머지는 ACTOR)
    // Dropdown에서 선택한 jobType(ACTOR 혹은 STAFF)
    var selectedJobType = BehaviorRelay<Job>(value: .actor)
    
    // sortButton 상태(UI+연결화면), filterButton 연결 화면, 플로팅 버튼 상태(UI+연결화면)
    let sortButtonStateDic: [JobSegmentType: JobOpeningSortOptions] = [
        .jobOpening: .recent,
        .profile: .recent
    ]
    
    var jobOpeningsContent: [JobOpeningContent]?
    var reloadTableView = PublishSubject<Void>()
    
    override init(sceneCoordinator: SceneCoordinatorType) {
        super.init(sceneCoordinator: sceneCoordinator)
        
        selectedJobType
            .withUnretained(self)
            .bind { owner, jobType in
                owner.fetchList()
            }.disposed(by: disposeBag)
    }
    
    // JobSegmentType(프로필/모집)과 JobType(ACTOR/STAFF)을 알아야 api 쏘므로 ViewModel에  selectedTab, selectedJobType 필요
    func fetchList() {
        jobOpeningInfoProvider.rx.request(.jobOpenings(type: selectedJobType.value))
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
