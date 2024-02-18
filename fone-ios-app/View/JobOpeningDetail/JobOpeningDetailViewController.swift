//
//  RecruitDetailViewController.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 11/12/23.
//

import UIKit

enum JobOpeningDetailSection: Int, CaseIterable {
    case author = 0
    case title
    case image
    case recruitCondition
    case info
    case workCondition
    case summary
    case contactInfo
    case footer
}

class JobOpeningDetailViewController: UIViewController, ViewModelBindableType {
    var viewModel: JobOpeningDetailViewModel!
    
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
        navigationItem.rightBarButtonItem = NavigationRightBarButtonItem(
            type: .more,
            viewController: self
        )
    }
    
    private func setCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AuthorCell.self)
        collectionView.register(TitleCell.self)
        collectionView.register(DetailImageCell.self)
        collectionView.register(RecruitConditionCell.self)
        collectionView.register(WorkInfoCell.self)
        collectionView.register(WorkConditionCell.self)
        collectionView.register(SummaryCell.self)
        collectionView.register(ContactInfoCell.self)
        collectionView.register(FooterCell.self)
    }
}

extension JobOpeningDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return JobOpeningDetailSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == JobOpeningDetailSection.image.rawValue {
            guard let viewModel = viewModel else { return 0 }
            let itemCount = viewModel.jobOpeningDetail?.recruitBasicInfo?.imageUrls?.count == 0 ? 0 : 1
            return itemCount
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let content = viewModel.jobOpeningDetail else { return UICollectionViewCell() }
        switch indexPath.section {
        case JobOpeningDetailSection.author.rawValue:
            guard let authorInfo = viewModel.authorInfo else { return UICollectionViewCell() }
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as AuthorCell
            cell.configure(authorInfo: authorInfo)
            return cell
        case JobOpeningDetailSection.title.rawValue:
            guard let titleInfo = viewModel.titleInfo else { return UICollectionViewCell() }
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as TitleCell
            cell.configrue(titleInfo: titleInfo)
            return cell
        case JobOpeningDetailSection.image.rawValue:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as DetailImageCell
            cell.configure(imageUrls: viewModel.jobOpeningDetail?.recruitBasicInfo?.imageUrls ?? [])
            return cell
        case JobOpeningDetailSection.recruitCondition.rawValue:
            guard let recruitCondition = viewModel.recruitCondition else { return UICollectionViewCell() }
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as RecruitConditionCell
            cell.configure(recruitCondition: recruitCondition)
            return cell
        case JobOpeningDetailSection.info.rawValue:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as WorkInfoCell
            cell.configure(produce: content.recruitWorkInfo?.produce, title: content.recruitWorkInfo?.workTitle, director: content.recruitWorkInfo?.director, genres: content.recruitWorkInfo?.genres, logline: content.recruitWorkInfo?.logline)
            return cell
        case JobOpeningDetailSection.workCondition.rawValue:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as WorkConditionCell
            cell.configure(salaryType: content.recruitWorkConditionInfo?.salaryType, salary: content.recruitWorkConditionInfo?.salary, city: content.recruitWorkConditionInfo?.workingCity, district: content.recruitWorkConditionInfo?.workingDistrict, period: content.workingDate, workDays: content.recruitWorkConditionInfo?.selectedDays, startTime: content.recruitWorkConditionInfo?.workingStartTime, endTime: content.recruitWorkConditionInfo?.workingEndTime)
            return cell
        case JobOpeningDetailSection.summary.rawValue:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as SummaryCell
            let summary = viewModel.jobOpeningDetail?.recruitDetailInfo?.details ?? ""
            cell.configure(item: summary)
            return cell
        case JobOpeningDetailSection.contactInfo.rawValue:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as ContactInfoCell
            cell.configure(manager: content.recruitContactInfo?.manager, email: content.recruitContactInfo?.email)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as FooterCell
            return cell
        }
    }
}

extension JobOpeningDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let viewModel = viewModel else { return .zero }
        
        let width: Double = UIScreen.main.bounds.width
        var height: Double = 250
        switch indexPath.section {
        case JobOpeningDetailSection.author.rawValue:
            height = 79
        case JobOpeningDetailSection.title.rawValue:
            height = TitleCell.cellHeight(viewModel.jobOpeningDetail?.recruitBasicInfo?.title)
        case JobOpeningDetailSection.image.rawValue:
            height = width / 375 * 400
        case JobOpeningDetailSection.recruitCondition.rawValue:
            height = 244
        case JobOpeningDetailSection.info.rawValue:
            height = WorkInfoCell.cellHeight(viewModel.jobOpeningDetail?.recruitWorkInfo?.logline)
        case JobOpeningDetailSection.workCondition.rawValue:
            height = 213
        case JobOpeningDetailSection.summary.rawValue:
            height = SummaryCell.cellHeight(viewModel.jobOpeningDetail?.recruitDetailInfo?.details)
        case JobOpeningDetailSection.contactInfo.rawValue:
            height = 118
        case JobOpeningDetailSection.footer.rawValue:
            height = 187
        default:
            height = 0
        }
        
        return CGSize(width: width, height: height)
    }
}
