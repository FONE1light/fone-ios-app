
//  JobOpeningHuntingViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/3/23.
//

import UIKit
import Then
import SnapKit
import RxSwift
import DropDown

class JobOpeningHuntingViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: JobOpeningHuntingViewModel!
    var hasViewModel = false
    var disposeBag = DisposeBag()
    
    private let dropDown = DropDown()
    private let segmentedControl = JobUISegmentedControl()
    
    private let sortButton = JobOpeningSortButton(width: 103)
    
    private let filterButton = UIButton().then {
        let image = UIImage(named: "Slider")
        $0.setImage(image, for: .normal)
    }
    
    private var isShownFloating = false
    private var floatingButton = FloatingButton()
    private var floatingSelectionView = FloatingStackView().then {
        $0.isHidden = true
    }
    
    private lazy var floatingDimView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds) // FIXME: 영역 재설정 (self.view.frame도 X)
        view.backgroundColor = .black_000000
        view.alpha = 0.3
        view.isHidden = true

        self.view.insertSubview(view, belowSubview: floatingSelectionView)

        return view
    }()
    
    // TODO: API 재요청 시점 따라 refresh 조치
    private lazy var tableViewJob = UITableView().then {
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
        $0.dataSource = self
        $0.delegate = self
        $0.register(with: JobCell.self)
        $0.backgroundColor = .gray_EEEFEF
    }
    
    private var profiles: [Profile] = [
        Profile(imageUrl: nil, name: "황우슬혜", age: "1985년생 (38살)", isSaved: true, birthYear: nil, job: nil),
        Profile(imageUrl: nil, name: "황우슬혜", age: "1985년생 (38살)", isSaved: false, birthYear: nil, job: nil),
        Profile(imageUrl: nil, name: "황우슬혜", age: "1985년생 (38살)", isSaved: true, birthYear: nil, job: nil),
        Profile(imageUrl: nil, name: "황우슬혜", age: "1985년생 (38살)", isSaved: false, birthYear: nil, job: nil),
        Profile(imageUrl: nil, name: "황우슬혜", age: "1985년생 (38살)", isSaved: true, birthYear: nil, job: nil),
        Profile(imageUrl: nil, name: "황우슬혜", age: "1985년생 (38살)", isSaved: true, birthYear: nil, job: nil),
        Profile(imageUrl: nil, name: "황우슬혜", age: "1985년생 (38살)", isSaved: false, birthYear: nil, job: nil),
        Profile(imageUrl: nil, name: "황우슬혜", age: "1985년생 (38살)", isSaved: true, birthYear: nil, job: nil),
        Profile(imageUrl: nil, name: "황우슬혜", age: "1985년생 (38살)", isSaved: true, birthYear: nil, job: nil)
    ]
    
    // TODO: API 재요청 시점 따라 refresh 조치
    private lazy var collectionViewProfile: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 24
        layout.minimumInteritemSpacing = 14
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(with: MyPageProfileCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundColor = .gray_EEEFEF
        collectionView.isHidden = true
        return collectionView
    }()
    
    func bindViewModel() {
        // MARK: Bind viewModel
        viewModel.selectedJobType
            .withUnretained(self)
            .bind { owner, jobType in
                if let jobTypeDropdown = owner.navigationItem.leftBarButtonItem?.customView as? JobTypeDropdown {
                    jobTypeDropdown.setLabel(jobType.name)
                    jobTypeDropdown.switchSelectionState()
                }
            }.disposed(by: disposeBag)
        
        viewModel.selectedTab.withUnretained(self)
            .bind { (owner: JobOpeningHuntingViewController, tabType: JobSegmentType) in
                owner.segmentedControl.selectedSegmentType = tabType
                
                // sortButton 상태(UI+연결화면), 플로팅 버튼 상태(UI+연결화면), tableView/collectionView 변경
                owner.viewModel.selectedSortOption.accept(owner.viewModel.sortButtonStateDic[tabType] ?? .recent)
                owner.floatingButton.changeMode(tabType)
                owner.floatingSelectionView.changeMode(tabType)
                
                switch tabType {
                case .jobOpening:
                    owner.tableViewJob.isHidden = false
                    owner.collectionViewProfile.isHidden = true
                case .profile:
                    owner.tableViewJob.isHidden = true
                    owner.collectionViewProfile.isHidden = false
                }
            }.disposed(by: self.disposeBag)
        
        collectionViewProfile.rx.itemSelected
            .withUnretained(self)
            .bind { owner, indexPath in
                guard owner.collectionViewProfile.cellForItem(at: indexPath) 
                        is MyPageProfileCell else { return }
                
                owner.goJobHuntingDetail(jobHuntingId: 41, type: .actor) // FIXME: 우선 41, ACTOR로 고정, cell에서 id, job 가져오기
            }.disposed(by: rx.disposeBag)
        
        viewModel.reloadTableView
            .withUnretained(self)
            .bind { owner, _ in
                owner.tableViewJob.reloadData()
            }.disposed(by: disposeBag)
        
        viewModel.reloadCollectionView
            .withUnretained(self)
            .bind { owner, _ in
                owner.collectionViewProfile.reloadData()
            }.disposed(by: disposeBag)
        
        // MARK: Button tap
        // customView로 설정한 UIBarButtonItem은
        // barButtonItem에 설정하는 userInteraction이 응답하지 않아서
        // customView 자체에 action을 적용해야함
        if let jobTypeDropdown = navigationItem.leftBarButtonItem?.customView as? JobTypeDropdown {
            jobTypeDropdown.buttonTap
                .withUnretained(self)
                .bind { owner, _ in
                    owner.dropDown.show()
                    jobTypeDropdown.switchSelectionState()
                }.disposed(by: rx.disposeBag)
        }

        sortButton.tap
            .withUnretained(self)
            .bind { owner, _ in
                guard let selectedSegmentType = owner.segmentedControl.selectedSegmentType else { return }
                
                owner.viewModel.showSortBottomSheet(segmentType: selectedSegmentType)
                
            }.disposed(by: rx.disposeBag)
        
        viewModel.selectedSortOption
            .withUnretained(self)
            .bind { owner, option in
                owner.sortButton.setLabel(option.title)
                owner.viewModel.sortButtonStateDic[owner.viewModel.selectedTab.value] = option
            }.disposed(by: disposeBag)
        
        filterButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.viewModel.showFilter()
            }.disposed(by: disposeBag)
        
        floatingButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.floatingDimView.isHidden = !owner.floatingDimView.isHidden
                owner.floatingSelectionView.switchHiddenState()
            }.disposed(by: rx.disposeBag)
        
        floatingSelectionView.actorButtonTap
            .withUnretained(self)
            .bind { owner, _ in
                guard let tabType = owner.segmentedControl.selectedSegmentType else { return }
                
                switch tabType {
                case .jobOpening:
                    owner.moveToRecruitBasicInfo(of: .actor)
                case .profile:
                    owner.moveToRegisterProfile(of: .actor)
                }
            }.disposed(by: rx.disposeBag)
        
        floatingSelectionView.staffButtonTap
            .withUnretained(self)
            .bind { owner, _ in
                guard let tabType = owner.segmentedControl.selectedSegmentType else { return }
                
                switch tabType {
                case .jobOpening:
                    owner.moveToRecruitBasicInfo(of: .staff)
                case .profile:
                    owner.moveToRegisterProfile(of: .staff)
                }
                
            }.disposed(by: rx.disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        
        setupUI()
        setConstraints()
        
    }
    
    private func setNavigationBar() {
        
        self.navigationItem.titleView = NavigationTitleView(title: "")
        
        self.navigationItem.leftBarButtonItem = NavigationLeftBarButtonItem(
            type: .jobType,
            viewController: self
        )
        
        setupDropdownButton()
        
        self.navigationItem.rightBarButtonItem = NavigationRightBarButtonItem(
            type: .notification,
            viewController: self
        )
        
        self.navigationController?.navigationBar.applyShadow(shadowType: .shadowIt2)
        
        let barAppearance = UINavigationBarAppearance().then {
            $0.backgroundColor = .white_FFFFFF
        }
        
        navigationItem.scrollEdgeAppearance = barAppearance
    }
    
    private func setupDropdownButton() {
        
        let dropDownAnchorView = UIView()
        view.addSubview(dropDownAnchorView)
        dropDownAnchorView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-11)
            $0.leading.equalTo(view.snp.leading).inset(16)
        }
        
        dropDown.do {
            $0.dataSource = ["ACTOR", "STAFF"]
            $0.width = 149
            $0.anchorView = dropDownAnchorView
        }
        
        DropDown.appearance().textFont = .font_b(17)
        DropDown.appearance().textColor = .gray_161616
        DropDown.appearance().selectionBackgroundColor = .gray_F8F8F8
        DropDown.appearance().setupCornerRadius(5)
        DropDown.appearance().cellHeight = 44
        DropDown.appearance().backgroundColor = .white_FFFFFF
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            guard let jobType = Job.getType(name: item) else { return }
            self.viewModel.selectedJobType.accept(jobType)
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .gray_EEEFEF
        segmentedControl.selectedSegmentType = .jobOpening
        
        [
            segmentedControl,
            filterButton,
            sortButton,
            tableViewJob,
            collectionViewProfile,
            
            floatingButton,
            floatingSelectionView
        ]
            .forEach { view.addSubview($0) }
        
        view.bringSubviewToFront(floatingButton)
        
        segmentedControl.addTarget(
            self,
            action: #selector(changeTab),
            for: .valueChanged
        )
    }
    
    private func setConstraints() {
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(22)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(42)
        }
        
        filterButton.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.centerY.equalTo(sortButton)
            $0.trailing.equalToSuperview().offset(-15)
        }
        
        sortButton.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(14)
            $0.leading.equalToSuperview().offset(16)
        }
        
        tableViewJob.snp.makeConstraints {
            $0.top.equalTo(sortButton.snp.bottom).offset(24)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        collectionViewProfile.snp.makeConstraints {
            $0.top.bottom.equalTo(tableViewJob)
            $0.leading.trailing.equalTo(tableViewJob).inset(16)
        }
        
        floatingButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(15)
            $0.bottom.equalToSuperview().inset(30)
            $0.size.equalTo(48)
        }
        
        floatingSelectionView.snp.makeConstraints {
            $0.bottom.equalTo(floatingButton.snp.top).offset(-6)
            $0.trailing.equalTo(floatingButton.snp.trailing)
        }
        
    }
}

extension JobOpeningHuntingViewController {
    @objc private func changeTab(segment: JobUISegmentedControl) {
        if let type = segment.selectedSegmentType {
            viewModel.selectedTab.accept(type)
        }
        switch segment.selectedSegmentType {
        case .jobOpening:
            tableViewJob.isHidden = false
            collectionViewProfile.isHidden = true
        case .profile:
            tableViewJob.isHidden = true
            collectionViewProfile.isHidden = false
        default: break
        }
    }
    
    private func moveToRecruitBasicInfo(of jobType: Job) {
        let recruitBasicInfoViewModel = RecruitBasicInfoViewModel(sceneCoordinator: viewModel.sceneCoordinator)
        recruitBasicInfoViewModel.jobType = jobType
        
        let recruitScene = Scene.recruitBasicInfo(recruitBasicInfoViewModel)
        viewModel.sceneCoordinator.transition(to: recruitScene, using: .push, animated: true)
    }
    
    /// 프로필 등록 - 배우
    private func moveToRegisterProfile(of jobType: Job) {
        let registerBasicInfoViewModel = RegisterBasicInfoViewModel(sceneCoordinator: viewModel.sceneCoordinator)
        registerBasicInfoViewModel.jobType = jobType
        
        let registerScene = Scene.registerBasicInfo(registerBasicInfoViewModel)
        viewModel.sceneCoordinator.transition(to: registerScene, using: .push, animated: true)
    }
}

// MARK: - TableView
extension JobOpeningHuntingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.jobOpeningsContent?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as JobCell
        
        guard let content = viewModel.jobOpeningsContent, content.count > 0 else { return cell }
        cell.configure(
            id: content[indexPath.row].id,
            jobType: content[indexPath.row].type,
            profileUrl: content[indexPath.row].profileURL,
            isVerified: content[indexPath.row].isVerified,
            categories: content[indexPath.row].categories,
            isScrap: content[indexPath.row].isScrap,
            title: content[indexPath.row].title,
            dDay: content[indexPath.row].dday,
            genre: content[indexPath.row].work?.genres?.first,
            domain: content[indexPath.row].domains?.first,
            produce: content[indexPath.row].work?.produce
        )
        
        cell.bookmarkButtonTap
            .withUnretained(self)
            .bind { owner, _ in
                cell.toggleBookmarkButton()
                // TODO: jobOpeningID 이용 북마크(스크랩) api 호출
            }.disposed(by: cell.disposeBag)

        return cell
    }
}

extension JobOpeningHuntingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(for: indexPath) as JobCell
        guard let id = cell.id, let type = cell.jobType else { return }
        goJobOpeningDetail(jobOpeningId: id, type: type)
    }
    
    func goJobOpeningDetail(jobOpeningId: Int, type: Job) {
        jobOpeningInfoProvider.rx.request(.jobOpeningDetail(jobOpeningId: jobOpeningId, type: type))
            .mapObject(JobOpeningInfo.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                guard let jobOpening = response.data?.jobOpening else {
                    response.message.toast()
                    return }
                let viewModel = JobOpeningDetailViewModel(sceneCoordinator: owner.viewModel.sceneCoordinator, jobOpeningDetail: jobOpening)
                let detailScene = Scene.jobOpeningDetail(viewModel)
                owner.viewModel.sceneCoordinator.transition(to: detailScene, using: .push, animated: true)
                
            },
            onError: { error in
                print(error)
            }).disposed(by: rx.disposeBag)
    }
}

extension JobOpeningHuntingViewController {
    // FIXME: jobHuntingInfoProvider 제작(API 연결)
    func goJobHuntingDetail(jobHuntingId: Int, type: Job) {
        jobOpeningInfoProvider.rx.request(.jobOpeningDetail(jobOpeningId: jobHuntingId, type: type))
            .mapObject(JobOpeningInfo.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                guard let jobOpening = response.data?.jobOpening else { return }
                let viewModel = JobHuntingDetailViewModel(sceneCoordinator: owner.viewModel.sceneCoordinator, jobHuntingDetail: jobOpening)
                // FIXME: API 응답 따라서 JobHuntingDetailViewModel 내부에서 jobType 식별, 혹은 밖(여기)에서 selectedJobType으로 지정
                viewModel.jobType = .actor
//                viewModel.jobType = owner.viewModel.selectedJobType.value
                let detailScene = Scene.jobHuntingDetail(viewModel)
                owner.viewModel.sceneCoordinator.transition(to: detailScene, using: .push, animated: true)
                
            }).disposed(by: rx.disposeBag)
    }
}

extension JobOpeningHuntingViewController: UICollectionViewDataSource {
    
    // MARK: cell count
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.profilesContent?.count ?? 0
    }
    
    // MARK: cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as MyPageProfileCell
        
        guard let profile = viewModel.profilesContent?[indexPath.row] else { return cell }
        
        let birthYear = profile.birthday?.birthYear(separator: "-")
        cell.configure(
            image: profile.profileURL,
            name: profile.name,
            birthYear: birthYear,
            age: profile.age,
            isSaved: profile.isWant
        )
        
        return cell
    }
    
}

// MARK: - CollectionView
extension JobOpeningHuntingViewController: UICollectionViewDelegateFlowLayout {
    // MARK: cellSize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let defaultHeight = 242.0
        let itemWidth = (UIScreen.main.bounds.width - 16*2 - 14) / 2
        return CGSize(width: itemWidth, height: defaultHeight)
    }
    
}

