//
//  RecruitDetailViewController.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 11/12/23.
//

import UIKit

enum JobHuntingDetailSection: Int, CaseIterable {
    case author = 0
//    case profileList // ADDED
//    /// 배우 정보 / 스태프 정보
//    case actorStaffInfo // ADDED TODO: actor/staff 처리
//    /// 상세 요강
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
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setCollectionView()
    }
    
    func bindViewModel() {
        
    }
    
    private func setNavigationBar() {
        navigationItem.titleView = NavigationTitleView(title: "배우 모집")
        navigationItem.leftBarButtonItem = NavigationLeftBarButtonItem(
            type: .back,
            viewController: self
        )
    }
    
    private func setCollectionView() {
        tableView.dataSource = self
        tableView.register(with: AuthorTableViewCell.self)
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
            return cell
            
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
