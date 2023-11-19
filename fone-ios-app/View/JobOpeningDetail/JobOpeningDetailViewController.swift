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
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let content = viewModel.jobOpeningDetail else { return UICollectionViewCell() }
        switch indexPath.section {
        case JobOpeningDetailSection.author.rawValue:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as AuthorCell
            cell.configure(createdAt: content.createdAt, viewCount: content.viewCount, profileUrl: content.profileURL, nickname: content.nickname, userJob: content.userJob)
            return cell
        case JobOpeningDetailSection.title.rawValue:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as TitleCell
            cell.configrue(categories: content.categories, title: content.title)
            return cell
        case JobOpeningDetailSection.image.rawValue:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as DetailImageCell
            return cell
        case JobOpeningDetailSection.recruitCondition.rawValue:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as RecruitConditionCell
            cell.configure(type: content.type, deadLine: content.deadline, dday: content.dday, casting: content.casting ?? "", domains: content.domains, numberOfRecruits: content.numberOfRecruits, gender: content.gender, ageMin: content.ageMin, ageMax: content.ageMax, career: content.career)
            return cell
        case JobOpeningDetailSection.info.rawValue:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as WorkInfoCell
            cell.configure(produce: content.work.produce, title: content.work.workTitle, director: content.work.director, genre: content.work.genre, logline: content.work.logline ?? "")
            return cell
        case JobOpeningDetailSection.workCondition.rawValue:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as WorkConditionCell
            return cell
        case JobOpeningDetailSection.summary.rawValue:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as SummaryCell
            let summary = viewModel.jobOpeningDetail?.work.details ?? ""
            cell.configure(item: summary)
            return cell
        case JobOpeningDetailSection.contactInfo.rawValue:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as ContactInfoCell
            cell.configure(manager: content.work.manager, email: content.work.email)
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
            height = TitleCell.cellHeight(viewModel.jobOpeningDetail?.title)
        case JobOpeningDetailSection.image.rawValue:
            height = width / 375 * 400
        case JobOpeningDetailSection.recruitCondition.rawValue:
            height = 244
        case JobOpeningDetailSection.info.rawValue:
            height = WorkInfoCell.cellHeight(viewModel.jobOpeningDetail?.work.logline)
        case JobOpeningDetailSection.workCondition.rawValue:
            height = 233
        case JobOpeningDetailSection.summary.rawValue:
            height = SummaryCell.cellHeight(viewModel.jobOpeningDetail?.work.details)
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
