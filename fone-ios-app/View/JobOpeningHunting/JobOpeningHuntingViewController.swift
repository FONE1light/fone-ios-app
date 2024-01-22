
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
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .black_000000
        view.alpha = 0.3
        view.isHidden = true
        // 닫기
        view.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(dismissDimView)
            )
        )
        
        if let tabBar = UIApplication.tabBar {
            UIApplication.viewOfKeyWindow?.insertSubview(view, aboveSubview: tabBar)
        }

        return view
    }()
    
    private lazy var tableViewJob = UITableView().then {
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
        $0.dataSource = self
        $0.delegate = self
        $0.register(with: JobCell.self)
        $0.backgroundColor = .gray_EEEFEF
    }
    
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
                guard let cell = owner.collectionViewProfile.cellForItem(at: indexPath)
                        as? MyPageProfileCell,
                let id = cell.id,
                let jobType = Job.getType(name: cell.jobType) else { return }
                
                owner.viewModel.goJobHuntingDetail(jobHuntingId: id, type: jobType)
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
                owner.scrollToTop()
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
                
                // 만약 push로 화면 이동한 후라서 UITabBar가 맨 위에 올라와 있다면 dim view와 버튼 들을 tabBar 앞으로 보내기 위해 순서 변경 필요
                if let viewOfKeyWindow = UIApplication.viewOfKeyWindow,
                   viewOfKeyWindow.subviews.last is UITabBar {
                    viewOfKeyWindow.exchangeSubview(at: 4, withSubviewAt: 3) // FloatingStackView
                    viewOfKeyWindow.exchangeSubview(at: 3, withSubviewAt: 2) // FloatingButton
                    viewOfKeyWindow.exchangeSubview(at: 2, withSubviewAt: 1) // UIView(Dim view)
                }
            }.disposed(by: disposeBag)
        
        floatingSelectionView.actorButtonTap
            .withUnretained(self)
            .bind { owner, _ in
                guard let tabType = owner.segmentedControl.selectedSegmentType else { return }
                
                switch tabType {
                case .jobOpening:
                    owner.viewModel.moveToRecruitBasicInfo(of: .actor)
                case .profile:
                    owner.viewModel.moveToRegisterProfile(of: .actor)
                }
            }.disposed(by: rx.disposeBag)
        
        floatingSelectionView.staffButtonTap
            .withUnretained(self)
            .bind { owner, _ in
                guard let tabType = owner.segmentedControl.selectedSegmentType else { return }
                
                switch tabType {
                case .jobOpening:
                    owner.viewModel.moveToRecruitBasicInfo(of: .staff)
                case .profile:
                    owner.viewModel.moveToRegisterProfile(of: .staff)
                }
                
            }.disposed(by: rx.disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        
        setupUI()
        setConstraints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        floatingButton.isHidden = false
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        [
            floatingButton,
            floatingSelectionView,
            floatingDimView
        ]
            .forEach {
                $0.isHidden = true
            }
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
            collectionViewProfile
        ]
            .forEach { view.addSubview($0) }
        
        segmentedControl.addTarget(
            self,
            action: #selector(changeTab),
            for: .valueChanged
        )
        
        // 플로팅 버튼과 뷰
        [
            floatingButton,
            floatingSelectionView
        ]
            .forEach {
                UIApplication.viewOfKeyWindow?.addSubview($0)
            }
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
        
        // 플로팅 버튼과 뷰
        floatingButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(15)
            $0.bottom.equalToSuperview().inset(UIView.tabBarHeight + 30)
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
    
    // TODO: hidden 처리 말고 dismiss?
    // 가능하다면 viewController 만들고 애니메이션 없는 modal 형식으로 띄우도록 구조 바꿔서(아래 뷰가 보여야 하므로 push는 X)
    @objc private func dismissDimView() {
        [
            floatingSelectionView,
            floatingDimView
        ]
            .forEach {
                $0.isHidden = true
            }
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
        viewModel.goJobOpeningDetail(jobOpeningId: id, type: type)
    }
}


// MARK: - CollectionView
extension JobOpeningHuntingViewController: UICollectionViewDataSource {
    
    // MARK: cell count
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.profilesContent?.count ?? 0
    }
    
    // MARK: cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as MyPageProfileCell
        
        guard viewModel.profilesContent?.count ?? 0 > 0,
            let profile = viewModel.profilesContent?[indexPath.row] else { return cell }
        
        let birthYear = profile.birthday?.birthYear(separator: "-")
        cell.configure(
            id: profile.id,
            jobType: profile.type,
            image: profile.representativeImageURL,
            name: profile.name,
            birthYear: birthYear,
            age: profile.age,
            isSaved: profile.isWant
        )
        
        return cell
    }
    
}

extension JobOpeningHuntingViewController: UICollectionViewDelegateFlowLayout {
    // MARK: cellSize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let defaultHeight = 242.0
        let itemWidth = (UIScreen.main.bounds.width - 16*2 - 14) / 2
        return CGSize(width: itemWidth, height: defaultHeight)
    }
}

// MARK: - Scroll offset detection(tableView, collectionView)
extension JobOpeningHuntingViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var scrollViewContentSize: CGFloat = 0
        
        switch scrollView {
        case is UITableView:
            scrollViewContentSize = tableViewJob.contentSize.height
        case is UICollectionView:
            scrollViewContentSize = collectionViewProfile.contentSize.height
        default:
            return
        }
        let contentOffset = scrollView.contentOffset.y
        let scrollViewFrameSize = scrollView.frame.size.height // == tableViewJob.bounds.size.height
        
        if scrollViewContentSize - contentOffset <= scrollViewFrameSize * 1.2 {
            viewModel.loadMore()
        }
    }
    
    private func scrollToTop() {
        
        switch viewModel.selectedTab.value {
        case .jobOpening:
            guard tableViewJob.numberOfRows(inSection: 0) > 0 else { return }
            tableViewJob.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        case .profile:
            guard collectionViewProfile.numberOfItems(inSection: 0) > 0 else { return }
            collectionViewProfile.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }
}
