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
    
    private var jobOpeningsPage = 0
    private var profilesPage = 0
    private let pageSize = 10
    
    private var isLoading = false
    
    var jobOpeningsContent: [JobOpeningContent] = []
    var profilesContent: [ProfileContent] = []
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
                owner.initList(segmentType: owner.selectedTab.value)
                owner.fetchList(
                    jobType: jobType,
                    segmentType: owner.selectedTab.value,
                    sortOption: option
                )
            }.disposed(by: disposeBag)
            
    }

    func showFilter() {
        let filterViewModel = FilterViewModel(sceneCoordinator: sceneCoordinator)
        let filterScene = Scene.filter(filterViewModel)
        sceneCoordinator.transition(to: filterScene, using: .fullScreenModal, animated: true)
    }
    
    // JobSegmentType(프로필/모집)과 JobType(ACTOR/STAFF)을 알아야 api 쏘므로 ViewModel에  selectedTab, selectedJobType 필요
    func fetchList(
        jobType: Job,
        segmentType selectedTab: JobSegmentType,
        sortOption: JobOpeningSortOptions
    ) {
        isLoading = true
        
        let sort = sortOption.serverParameter ?? ""
        
        switch selectedTab {
        case .jobOpening: fetchJobOpenings(jobType: jobType, sort: sort)
        case .profile: fetchProfiles(jobType: jobType, sort: sort)
        }
    }
    
    private func fetchJobOpenings(jobType: Job, sort: String) {
        jobOpeningInfoProvider.rx.request(.jobOpenings(type: jobType, sort: sort, page: jobOpeningsPage, size: pageSize))
            .mapObject(Result<JobOpeningsData>.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                print(response)
                owner.isLoading = false
                guard let newContent = response.data?.jobOpenings?.content, newContent.count > 0 else {
                    owner.jobOpeningsPage = owner.jobOpeningsPage - 1 // 원복
                    return
                }
                owner.jobOpeningsContent.append(contentsOf: newContent)
                owner.reloadTableView.onNext(())
            },
                       onError: { [weak self] error in
                error.localizedDescription.toast()
                print(error.localizedDescription)
                guard let self = self else { return }
                self.isLoading = false
                self.jobOpeningsPage = self.jobOpeningsPage - 1 // 원복
            }).disposed(by: disposeBag)
    }
    
    private func fetchProfiles(jobType: Job, sort: String) {
        profileInfoProvider.rx.request(.profiles(type: jobType, sort: sort, page: profilesPage, size: pageSize))
            .mapObject(Result<ProfilesData>.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                print(response)
                owner.isLoading = false
                guard let newContent = response.data?.profiles?.content, newContent.count > 0 else {
                    owner.profilesPage = owner.profilesPage - 1 // 원복
                    if owner.profilesContent.isEmpty { // 탭 변경 후 받은 리스트가 빈 경우
                        owner.reloadCollectionView.onNext(())
                    }
                    return
                }
                owner.profilesContent.append(contentsOf: newContent)
                owner.reloadCollectionView.onNext(())
            },
                       onError: { [weak self] error in
                error.localizedDescription.toast()
                print(error.localizedDescription)
                guard let self = self else { return }
                self.isLoading = false
                self.profilesPage = self.profilesPage - 1 // 원복
            }).disposed(by: disposeBag)
    }
    
    func loadMore() {
        guard isLoading == false else { return }
        print("|LOAD MORE")
        switch selectedTab.value {
        case .jobOpening:
            jobOpeningsPage = jobOpeningsPage + 1
        case .profile:
            profilesPage = profilesPage + 1
        }
        fetchList(jobType: selectedJobType.value, segmentType: selectedTab.value, sortOption: selectedSortOption.value)
    }
    
    private func initList(segmentType: JobSegmentType) {
        switch segmentType {
        case .jobOpening:
            jobOpeningsPage = 0
            jobOpeningsContent = []
        case .profile:
            profilesPage = 0
            profilesContent = []
        }
    }
}

extension JobOpeningHuntingViewModel {
    func showSortBottomSheet(segmentType: JobSegmentType) {
        let optionsBottomSheetViewModel = OptionsBottomSheetViewModel(
            sceneCoordinator: sceneCoordinator,
            title: "정렬",
            selectedItem: selectedSortOption.value,
            list: segmentType.sortList
        ) { [weak self] selectedText in
            guard let self = self else { return }
            guard let option = JobOpeningSortOptions.getType(title: selectedText) else { return }
            self.selectedSortOption.accept(option)
            self.sceneCoordinator.close(animated: true)
        }
        let scene = Scene.optionsBottomSheet(optionsBottomSheetViewModel)
        sceneCoordinator.transition(to: scene, using: .customModal, animated: true)
    }
}

extension JobOpeningHuntingViewModel {
    /// 모집 등록
    func moveToComposeRecruit(of jobType: Job) {
        let recruitContactLinkInfoViewModel = RecruitContactLinkInfoViewModel(sceneCoordinator: sceneCoordinator)
        recruitContactLinkInfoViewModel.jobType = jobType
        
        let recruitComposeScene = Scene.recruitContactLinkInfo(recruitContactLinkInfoViewModel)
        sceneCoordinator.transition(to: recruitComposeScene, using: .push, animated: true)
    }
    
    /// 프로필 등록
    func moveToRegisterProfile(of jobType: Job) {
        let registerContactLinkInfoViewModel = RegisterContactLinkInfoViewModel(sceneCoordinator: sceneCoordinator)
        registerContactLinkInfoViewModel.jobType = jobType
        
        let registerScene = Scene.registerContactLinkInfo(registerContactLinkInfoViewModel)
        sceneCoordinator.transition(to: registerScene, using: .push, animated: true)
    }
}

extension JobOpeningHuntingViewModel {
    func toggleScrap(id: Int?) {
        guard let id = id else { return }
        jobOpeningInfoProvider.rx.request(.scrapJobOpening(jobOpeningId: id))
            .mapObject(Result<ScrapJobOpeningResponseResult>.self)
            .asObservable()
            .withUnretained(self)
            .subscribe (
                onNext: { owner, response in
                    if response.result?.isSuccess != true {
                        "스크랩을 실패했습니다.".toast()
                    }
                },
                onError: { error in
                    error.showToast(modelType: ScrapJobOpeningResponseResult.self)
                }).disposed(by: disposeBag)
    }
    
    func toggleWanted(id: Int?) {
        guard let id = id else { return }
        profileInfoProvider.rx.request(.profileWant(profileId: id))
            .mapObject(Result<EmptyData>.self)
            .asObservable()
            .withUnretained(self)
            .subscribe (
                onNext: { owner, response in
                    if response.result?.isSuccess != true {
                        "프로필 찜하기를 실패했습니다.".toast()
                    }
                },
                onError: { error in
                    error.showToast(modelType: ProfilesData.self)
                }).disposed(by: disposeBag)
    }
}
