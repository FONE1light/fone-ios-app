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
    var disposeBag = DisposeBag()
    
    // TODO: 회원가입시 자신이 직업 선택한 분야로 초기값 지정(STAFF->STAFF, 나머지는 ACTOR)
    // Dropdown에서 선택한 jobType(ACTOR 혹은 STAFF)
    var selectedJobType = BehaviorRelay<Job>(value: .actor)
    
    var selectedTab = BehaviorRelay<JobSegmentType>(value: .jobOpening)
    
    var selectedSortOption = BehaviorRelay<JobOpeningSortOptions>(value: .recent)
    
    var sortButtonStateDic: [JobSegmentType: JobOpeningSortOptions] = [
        .jobOpening: .recent,
        .profile: .recent
    ]
    
    var jobOpeningsContent: [JobOpeningContent]?
    var profilesContent: [ProfileContent]?
    var reloadTableView = PublishSubject<Void>()
    var reloadCollectionView = PublishSubject<Void>()
    
    override init(sceneCoordinator: SceneCoordinatorType) {
        super.init(sceneCoordinator: sceneCoordinator)
        
        Observable
            .combineLatest(selectedJobType, selectedSortOption)
            .withUnretained(self)
            .bind { owner, result in
                let (jobType, option) = result
                
                print("✅\(jobType), \(owner.selectedTab.value), \(option)")
                owner.fetchList(
                    jobType: jobType,
                    segmentType: owner.selectedTab.value,
                    sortOption: option
                )
            }.disposed(by: disposeBag)
            
    }
    
    // JobSegmentType(프로필/모집)과 JobType(ACTOR/STAFF)을 알아야 api 쏘므로 ViewModel에  selectedTab, selectedJobType 필요
    func fetchList(
        jobType: Job,
        segmentType selectedTab: JobSegmentType,
        sortOption: JobOpeningSortOptions
    ) {
        let sort = sortOption.serverParameter ?? []
        
        switch selectedTab {
        case .jobOpening: fetchJobOpenings(jobType: jobType, sort: sort)
        case .profile: fetchProfiles(jobType: jobType, sort: sort)
        }
    }
    
    private func fetchJobOpenings(jobType: Job, sort: [String]) {
        jobOpeningInfoProvider.rx.request(.jobOpenings(type: jobType, sort: sort))
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
    
    private func fetchProfiles(jobType: Job, sort: [String]) {
        profileInfoProvider.rx.request(.profiles(type: jobType, sort: sort))
            .mapObject(Result<ProfileData>.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                print(response)
                owner.profilesContent = response.data?.profiles?.content
                owner.reloadCollectionView.onNext(())
            },
                       onError: { error in
                print(error.localizedDescription)
            }).disposed(by: disposeBag)
    }
}

extension JobOpeningHuntingViewModel {
    func showSortBottomSheet(segmentType: JobSegmentType) {
        let jobOpeningSortBottomSheetViewModel = JobOpeningSortBottomSheetViewModel(
            sceneCoordinator: sceneCoordinator,
            selectedItem: selectedSortOption.value,
            list: segmentType.sortList
        ) { [weak self] selectedText in
            guard let self = self else { return }
            guard let option = JobOpeningSortOptions.getType(title: selectedText) else { return }
            self.selectedSortOption.accept(option)
            self.sceneCoordinator.close(animated: true)
        }
        let scene = Scene.jobOpeningSortBottomSheet(jobOpeningSortBottomSheetViewModel)
        sceneCoordinator.transition(to: scene, using: .customModal, animated: true)
    }
}
