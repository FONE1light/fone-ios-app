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
    
    private let selectedFilterOptionsJobOpening = BehaviorSubject<FilterOptions?>(value: nil)
    private let selectedFilterOptionsProfile = BehaviorSubject<FilterOptions?>(value: nil)
    
    var sortButtonStateDic: [JobSegmentType: JobOpeningSortOptions] = [
        .jobOpening: .recent,
        .profile: .recent
    ]
    
    private var jobOpeningsPage = 0
    private var profilesPage = 0
    private let pageSize = 10
    
    private var isLoading = false
    
    private var jobOpeningsContent: [JobOpeningContent] = []
    var profilesContent: [ProfileContent] = []

    var reloadTableView = PublishSubject<[JobOpeningContent]>()
    var reloadCollectionView = PublishSubject<Void>()
    
    override init(sceneCoordinator: SceneCoordinatorType) {
        super.init(sceneCoordinator: sceneCoordinator)
        
        Observable
            .combineLatest(selectedJobType, selectedSortOption, selectedFilterOptionsJobOpening, selectedFilterOptionsProfile)
            .skip(1) // FIXME: 첫 실행 시 왜 두 번 불리는지 확인, 수정
            .withUnretained(self)
            .bind { owner, result in
                let (jobType, option, filterOptionsJobOpening, filterOptionsProfile) = result
                print("✅\(jobType), \(owner.selectedTab.value), \(option), \(filterOptionsJobOpening), \(filterOptionsProfile)")
                var filterOptions: FilterOptions?
                
                switch owner.selectedTab.value {
                case .jobOpening: filterOptions = filterOptionsJobOpening
                case .profile: filterOptions = filterOptionsProfile
                }
                
                owner.initList(segmentType: owner.selectedTab.value)
                owner.fetchList(
                    jobType: jobType,
                    segmentType: owner.selectedTab.value,
                    sortOption: option,
                    filterOptions: filterOptions
                )
            }.disposed(by: disposeBag)
    }

    func showFilter(_ tabType: JobSegmentType) {
        switch tabType {
        case .jobOpening:
            let filterViewModel = FilterJobOpeningViewModel(sceneCoordinator: sceneCoordinator, filterOptionsSubject: selectedFilterOptionsJobOpening)
            let filterScene = Scene.filter(filterViewModel)
            sceneCoordinator.transition(to: filterScene, using: .fullScreenModal, animated: true)
        case .profile:
            let filterProfileViewModel = FilterProfileViewModel(sceneCoordinator: sceneCoordinator, filterOptionsSubject: selectedFilterOptionsProfile)
            let filterProfileScene = Scene.filterProfile(filterProfileViewModel)
            sceneCoordinator.transition(to: filterProfileScene, using: .fullScreenModal, animated: true)
        }
    }
    
    // JobSegmentType(프로필/모집)과 JobType(ACTOR/STAFF)을 알아야 api 쏘므로 ViewModel에  selectedTab, selectedJobType 필요
    private func fetchList(
        jobType: Job,
        segmentType selectedTab: JobSegmentType,
        sortOption: JobOpeningSortOptions,
        filterOptions: FilterOptions? = nil
    ) {
        isLoading = true
        
        let sort = sortOption.serverParameter ?? ""
        
        let filterRequest = FilterRequest(
            type: jobType.name,
            sort: sort,
            page: jobOpeningsPage,
            ageMax: filterOptions?.ageMax,
            ageMin: filterOptions?.ageMin,
            stringCategories: filterOptions?.stringCategories,
            stringGenders: filterOptions?.stringGenders,
            stringDomains: filterOptions?.stringDomains
        )
        
        switch selectedTab {
        case .jobOpening: fetchJobOpenings(filterRequest)
        case .profile: fetchProfiles(filterRequest)
        }
    }
    
    private func fetchJobOpenings(_ filterRequest: FilterRequest) {
        print("🔥filterRequest \(filterRequest)")
        jobOpeningInfoProvider.rx.request(.jobOpenings(jobOpeningFilterRequest: filterRequest))
            .mapObject(Result<JobOpeningsData>.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                print("🔥response \(response)")
                owner.isLoading = false
                guard let newContent = response.data?.jobOpenings?.content else { 
                    owner.jobOpeningsPage = owner.jobOpeningsPage - 1 // 증가시킨 페이지번호 원복
                    return
                }
                
                // 추가 로드했는데 없는 경우(=마지막 항목까지 노출 완료)
                if newContent.count == 0, owner.jobOpeningsPage > 0 {
                    owner.jobOpeningsPage = owner.jobOpeningsPage - 1 // 증가시킨 페이지번호 원복
                    return
                }
                
                // 화면에 노출시킬 유효한 데이터들
                if owner.jobOpeningsPage == 0 {
                    owner.jobOpeningsContent = newContent
                } else {
                    owner.jobOpeningsContent.append(contentsOf: newContent)
                }
                owner.reloadTableView.onNext(owner.jobOpeningsContent)
            },
                       onError: { [weak self] error in
                error.localizedDescription.toast()
                print(error.localizedDescription)
                guard let self = self else { return }
                self.isLoading = false
                self.jobOpeningsPage = self.jobOpeningsPage - 1 // 원복
            }).disposed(by: disposeBag)
    }
    
    private func fetchProfiles(_ filterRequest: FilterRequest) {
        profileInfoProvider.rx.request(.profiles(profileFilterRequest: filterRequest))
            .mapObject(Result<ProfilesData>.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                print(response)
                owner.isLoading = false
                guard let newContent = response.data?.profiles?.content else {
                    owner.profilesPage = owner.profilesPage - 1 // 증가시킨 페이지번호 원복
                    return
                }
                
                // 추가 로드했는데 없는 경우(=마지막 항목까지 노출 완료)
                if newContent.count == 0, owner.profilesPage > 0 {
                    owner.profilesPage = owner.profilesPage - 1 // 증가시킨 페이지번호 원복
                    return
                }
                
                // 화면에 노출시킬 유효한 데이터들
                if owner.profilesPage == 0 {
                    owner.profilesContent = newContent
                } else {
                    owner.profilesContent.append(contentsOf: newContent)
                }
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
