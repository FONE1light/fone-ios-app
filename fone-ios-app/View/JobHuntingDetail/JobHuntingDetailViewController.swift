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
//    /// 주요 경력
    case mainCareer // ADDED
    /// 분야
    case categories // ADDED
    /// 본 정보는 ~
    case footer
}

class JobHuntingDetailViewController: UIViewController, ViewModelBindableType {
    var viewModel: JobHuntingDetailViewModel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
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
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AuthorCell.self)
//        collectionView.register(TitleCell.self)
//        collectionView.register(DetailImageCell.self)
//        collectionView.register(RecruitConditionCell.self)
//        collectionView.register(WorkInfoCell.self)
//        collectionView.register(WorkConditionCell.self)
        collectionView.register(SummaryCell.self)
        collectionView.register(MainCareerCell.self)
        collectionView.register(CategoriesCell.self)
//        collectionView.register(ContactInfoCell.self)
        collectionView.register(FooterCell.self)
    }
}

extension JobHuntingDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // FIXME: 값 없는 경우 섹션 삭제.
        return JobHuntingDetailSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if section == JobHuntingDetailSection.image.rawValue {
//            guard let viewModel = viewModel else { return 0 }
//            let itemCount = viewModel.jobHuntingDetail?.imageUrls?.count == 0 ? 0 : 1
//            return itemCount
//        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let content = viewModel.jobHuntingDetail else { return UICollectionViewCell() }
        switch indexPath.section {
        case JobHuntingDetailSection.author.rawValue:
            guard let authorInfo = viewModel.authorInfo else { return UICollectionViewCell() }
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as AuthorCell
            cell.configure(authorInfo: authorInfo)
            return cell
//        case JobHuntingDetailSection.title.rawValue:
//            guard let titleInfo = viewModel.titleInfo else { return UICollectionViewCell() }
//            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as TitleCell
//            cell.configrue(titleInfo: titleInfo)
//            return cell
//        case JobHuntingDetailSection.image.rawValue:
//            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as DetailImageCell
//            return cell
//        case JobHuntingDetailSection.recruitCondition.rawValue:
//            guard let recruitCondition = viewModel.recruitCondition else { return UICollectionViewCell() }
//            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as RecruitConditionCell
//            cell.configure(recruitCondition: recruitCondition)
//            return cell
//        case JobHuntingDetailSection.info.rawValue:
//            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as WorkInfoCell
//            cell.configure(produce: content.work?.produce, title: content.work?.workTitle, director: content.work?.director, genre: content.work?.genre, logline: content.work?.logline)
//            return cell
//        case JobHuntingDetailSection.workCondition.rawValue:
//            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as WorkConditionCell
//            cell.configure(salaryType: content.work?.salaryType, salary: content.work?.salary, location: content.work?.workingLocation, period: content.work?.workingDate, workDays: content.work?.selectedDays, workingTime: content.work?.workingTime)
//            return cell
        case JobHuntingDetailSection.summary.rawValue:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as SummaryCell
            let summary = viewModel.jobHuntingDetail?.work?.details ?? ""
            cell.configure(item: summary)
            return cell
            
        case JobHuntingDetailSection.mainCareer.rawValue:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as MainCareerCell
            let mainCareer = viewModel.jobHuntingDetail?.work?.details ?? ""
            cell.configure(item: mainCareer)
            return cell
            
        case JobHuntingDetailSection.categories.rawValue:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as CategoriesCell
//            let categories = content.categories
            let categories: [Category] = [.shortFilm, .viral, .independentFilm, .webDrama]
            cell.configure(categories)
            return cell
            
//        case JobHuntingDetailSection.contactInfo.rawValue:
//            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as ContactInfoCell
//            cell.configure(manager: content.work?.manager, email: content.work?.email)
//            return cell
        default:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as FooterCell
            return cell
        }
    }
}

extension JobHuntingDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let viewModel = viewModel else { return .zero }
        
        let width: Double = UIScreen.main.bounds.width
        var height: Double = 250
        switch indexPath.section {
        case JobHuntingDetailSection.author.rawValue:
            height = 79
//        case JobHuntingDetailSection.title.rawValue:
//            height = TitleCell.cellHeight(viewModel.jobHuntingDetail?.title)
//        case JobHuntingDetailSection.image.rawValue:
//            height = width / 375 * 400
//        case JobHuntingDetailSection.recruitCondition.rawValue:
//            height = 244
//        case JobHuntingDetailSection.info.rawValue:
//            height = WorkInfoCell.cellHeight(viewModel.jobHuntingDetail?.work?.logline)
//        case JobHuntingDetailSection.workCondition.rawValue:
//            height = 233
        case JobHuntingDetailSection.summary.rawValue:
            height = SummaryCell.cellHeight(viewModel.jobHuntingDetail?.work?.details)
        case JobHuntingDetailSection.mainCareer.rawValue:
            height = MainCareerCell.cellHeight(viewModel.jobHuntingDetail?.work?.details)
        case JobHuntingDetailSection.categories.rawValue:
            let categories = viewModel.jobHuntingDetail?.categories?
                .compactMap { Category.getType(serverName: $0) }
            guard let categories = categories else { return CGSize(width: width, height: 0) }
            height = CategoriesCell.cellHeight(categories)
            // FIXME: height 자동 계산 방법, 혹은 tableView로 변경 혹은 tableView로 새로 만들며 코드로 짜기
            
//            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as CategoriesCell
//            cell.selectionBlock.setSelections([Category.shortFilm, Category.viral])
//            let estimatedSize = cell.systemLayoutSizeFitting(CGSize(width: 50, height: 50))
//            height = estimatedSize.height
        case JobHuntingDetailSection.footer.rawValue:
            height = 187
        default:
            height = 0
        }
        
        return CGSize(width: width, height: height)
    }
}
