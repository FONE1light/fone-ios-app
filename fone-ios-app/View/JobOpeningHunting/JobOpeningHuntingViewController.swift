
//  JobOpeningHuntingViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/3/23.
//

import UIKit
import Then
import SnapKit
import RxSwift


class JobOpeningHuntingViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: JobOpeningHuntingViewModel!
    var hasViewModel = false
    
    private let segmentedControl = JobUISegmentedControl()
    
    private let sortButton = JobOpeningSortButton(width: 103)
    
    private let filterButton = UIButton().then {
        let image = UIImage(named: "Slider")
        $0.setImage(image, for: .normal)
    }
    
    // TODO: API 재요청 시점 따라 refresh 조치
    private lazy var tableViewJob = UITableView().then {
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
        $0.dataSource = self
        $0.register(with: JobPostCell.self)
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
        sortButton.tap
            .withUnretained(self)
            .bind { owner, _ in
                print("open BottomSheet")
                if let bottomSheet = owner.segmentedControl.selectedSegmentType?.bottomSheet {
                    // FIXME: 실기기 iOS 17.1에서 미노출, Simulator iOS 17.0에서 노출
                    // FIXME: 높이 늘어나는 것 해결(UIView-Encapsulated-Layout-Height)
                    owner.presentPanModal(view: bottomSheet)
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
            type: .back,
            viewController: self
        )
//        self.navigationItem.leftBar
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
    
    private func setupUI() {
        self.view.backgroundColor = .gray_EEEFEF
        
        [
            segmentedControl,
            filterButton,
            sortButton,
            tableViewJob,
            collectionViewProfile
        ]
            .forEach { view.addSubview($0) }
        
        
        segmentedControl.selectedSegmentType = .jobOpening
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
    }
}

extension JobOpeningHuntingViewController {
    @objc private func changeTab(segment: JobUISegmentedControl) {
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
}

// MARK: - TableView
extension JobOpeningHuntingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as JobPostCell
        
        if indexPath.row % 2 == 0 {
            cell.configure(
                job: .staff,
                categories: [.featureFilm, .youtube],
                deadline: "2023.01.20",
                coorporate: "성균관대학교 영상학과",
                gender: "남자",
                period: "일주일",
                field: "미술"
            )
        } else {
            
            cell.configure(
                job: .actor,
                categories: [.ottDrama, .shortFilm],
                deadline: "2023.01.20",
                coorporate: "성균관대학교 영상학과",
                gender: "남자",
                period: "일주일",
                casting: "수영선수"
            )
            
        }
        
        return cell
    }

}


extension JobOpeningHuntingViewController: UICollectionViewDataSource {
    
    // MARK: cell count
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profiles.count
    }
    
    // MARK: cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as MyPageProfileCell
        let profile = profiles[indexPath.row]
        
        cell.configure(
            image: nil,
            name: profile.name,
            age: profile.age,
            isSaved: profile.isSaved
        )
        
        return cell
    }

}

// MARK: - CollectionView
extension JobOpeningHuntingViewController: UICollectionViewDelegateFlowLayout {
    // MARK: cellSize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let defaultHeight = 223.0 // FIXME: 셀크기로
        let itemWidth = (UIScreen.main.bounds.width - 16*2 - 14) / 2
        return CGSize(width: itemWidth, height: defaultHeight)
    }
    
    // MARK: minimumSpacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 26
    }
}

