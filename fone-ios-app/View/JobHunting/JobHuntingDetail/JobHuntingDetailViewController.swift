//
//  JobHuntingDetailViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 12/13/23.
//

import UIKit
import RxSwift

enum JobHuntingDetailSection: Int, CaseIterable {
    case author = 0
    /// 프로필 이미지 리스트
    case profileList // ADDED
    /// 배우 정보 / 스태프 정보
    case actorStaffInfo // ADDED TODO: actor/staff 처리
    /// 상세 요강
    case summary
    /// 주요 경력
    case mainCareer // ADDED
    /// 분야
    case categories // ADDED
    /// 본 정보는 ~
    case footer
}

class JobHuntingDetailViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: JobHuntingDetailViewModel!
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.bounces = false
            tableView.separatorStyle = .none
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setCollectionView()
        
        viewModel.fetchJobHuntingDetail()
    }
    
    func bindViewModel() {
        
    }
    
    private func setNavigationBar() {
        navigationItem.titleView = NavigationTitleView(title: "\(viewModel.jobType?.koreanName ?? "") 프로필")
        navigationItem.leftBarButtonItem = NavigationLeftBarButtonItem(
            type: .back,
            viewController: self
        )
        navigationItem.rightBarButtonItem = NavigationRightBarButtonItem(
            type: .more,
            viewController: self
        )
    }
    
    private func setCollectionView() {
        tableView.dataSource = self
        tableView.register(with: AuthorTableViewCell.self)
        tableView.register(with: ProfileListTableViewCell.self)
        tableView.register(with: ActorInfoTableViewCell.self)
        tableView.register(with: StaffInfoTableViewCell.self)
        tableView.register(with: SummaryTableViewCell.self)
        tableView.register(with: MainCareerTableViewCell.self)
        tableView.register(with: CategoriesTableViewCell.self)
        tableView.register(with: FooterTableViewCell.self)
    }
}


extension JobHuntingDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        JobHuntingDetailSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let content = viewModel.jobHuntingDetail else { return UITableViewCell() }
        switch indexPath.row {
        case JobHuntingDetailSection.author.rawValue:
            guard let authorInfo = viewModel.authorInfo else { return UITableViewCell() }
            let cell = tableView.dequeueReusableCell(for: indexPath) as AuthorTableViewCell
            cell.configure(authorInfo: authorInfo)
            cell.instagramButtonTap
                .withUnretained(self)
                .bind { owner, _ in
                    owner.viewModel.moveToSNSWebView(authorInfo.instagramUrl)
                }.disposed(by: cell.disposeBag)
            cell.youtubeButtonTap
                .withUnretained(self)
                .bind { owner, _ in
                    owner.viewModel.moveToSNSWebView(authorInfo.youtubeUrl)
                }.disposed(by: cell.disposeBag)
            return cell
            
        case JobHuntingDetailSection.profileList.rawValue:
            
            let cell = tableView.dequeueReusableCell(for: indexPath) as ProfileListTableViewCell
            let urls = viewModel.mockUrls?.prefix(3) ?? []
            
            cell.configure(
                title: "제가 평범한 할머니로 보이시나요?",
                imageUrls: Array(urls)
            )
            cell.viewMoreButtonTap
                .withUnretained(self)
                .bind { owner, _ in
                    owner.viewModel.moveToJobHuntingProfiles()
                }.disposed(by: cell.disposeBag)
            
            cell.imageButtonTaps
                .enumerated()
                .forEach { index, buttonTap in
                    buttonTap
                        .withUnretained(self)
                        .bind { owner, _ in
                            owner.viewModel.showProfilePreviewBottomSheet(of: index)
                        }.disposed(by: cell.disposeBag)
                }
            
            return cell
            
        case JobHuntingDetailSection.actorStaffInfo.rawValue:
//            guard let authorInfo = viewModel.authorInfo else { return UITableViewCell() }
            switch viewModel.jobType {
            case .actor:
                let cell = tableView.dequeueReusableCell(for: indexPath) as ActorInfoTableViewCell
                // FIXME: 실 데이터 넣기
                cell.configure(
                    name: "박신혜",
                    gender: .WOMAN,
                    birthYear: "2002년 (21살)",
                    height: "170cm",
                    weight: "60kg",
                    email: "de91jko@naver.com",
                    specialty: "줄넘기/실뜨기/달리기"
                )
                return cell
            case .staff:
                
                let cell = tableView.dequeueReusableCell(for: indexPath) as StaffInfoTableViewCell
                // FIXME: 실 데이터 넣기
                cell.configure(
                    name: "박신혜",
                    gender: .WOMAN,
                    birthYear: "2002년 (21살)",
                    domain: "음악",
                    email: "de91jko@naver.com",
                    specialty: "줄넘기/실뜨기/달리기"
                )
                return cell
                
            default: return UITableViewCell()
            }
            
        case JobHuntingDetailSection.summary.rawValue:
            let cell = tableView.dequeueReusableCell(for: indexPath) as SummaryTableViewCell
            let summary = viewModel.jobHuntingDetail?.work?.details ?? ""
            cell.configure(item: summary)
            return cell
            
        case JobHuntingDetailSection.mainCareer.rawValue:
            let cell = tableView.dequeueReusableCell(for: indexPath) as MainCareerTableViewCell
            let mainCareer = viewModel.jobHuntingDetail?.work?.details ?? ""
            cell.configure(item: mainCareer)
            return cell
            
        case JobHuntingDetailSection.categories.rawValue:
            let cell = tableView.dequeueReusableCell(for: indexPath) as CategoriesTableViewCell
//            let categories = content.categories
            let categories: [Category] = [.shortFilm, .viral, .independentFilm, .webDrama]
            cell.configure(categories)
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(for: indexPath) as FooterTableViewCell
            return cell
        }
    }
}