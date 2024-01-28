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
//        if section == JobOpeningDetailSection.image.rawValue {
//            guard let viewModel = viewModel else { return 0 }
//            let itemCount = viewModel.jobOpeningDetail?.imageUrls?.count == 0 ? 0 : 1
//            return itemCount
//        }
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
            cell.configure(imageUrls: [
                "https://m.media-amazon.com/images/M/MV5BMDBmYTZjNjUtN2M1MS00MTQ2LTk2ODgtNzc2M2QyZGE5NTVjXkEyXkFqcGdeQXVyNzAwMjU2MTY@._V1_.jpg",
                "https://images.ctfassets.net/3m6gg2lxde82/1M3pgRmfLqMWjUpzGUz22T/b6fcf28828426cef8b208f56fed350c7/cillian-murphy-oppenheimer.png",
                "https://ymcinema.com/wp-content/uploads/2023/06/IMAX-Presents-A-Rare-BTS-Look-of-Oppenheimer.001.jpeg",
                "https://static1.srcdn.com/wordpress/wp-content/uploads/2023/08/oppenheimer-imax-cillian-murphy.jpg",
                "https://i0.wp.com/ymcinema.com/wp-content/uploads/2023/06/IMAX-Presents-A-Rare-BTS-Look-of-Oppenheimer.007.jpeg?ssl=1",
                "https://pyxis.nymag.com/v1/imgs/2b8/7f3/1a86390fd159126aaff357a3fb6c108410-oppenheimer-process-01.jpg",
                "https://m.media-amazon.com/images/M/MV5BMjQ2YTY0ZjItOGE3NS00MjAwLThhMDMtYTc4YjRkY2VjNDBlXkEyXkFqcGdeQXVyMTE0MzQwMjgz._V1_.jpg",
                "https://blog.frame.io/wp-content/uploads/2023/08/trc-oppenheimer-bts-christopher-nolan-with-cillian-murphy.jpg",
                "https://www.motionpictures.org/wp-content/uploads/2023/04/GF-11507_MSG.jpg"
            ])
            return cell
        case JobOpeningDetailSection.recruitCondition.rawValue:
            guard let recruitCondition = viewModel.recruitCondition else { return UICollectionViewCell() }
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as RecruitConditionCell
            cell.configure(recruitCondition: recruitCondition)
            return cell
        case JobOpeningDetailSection.info.rawValue:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as WorkInfoCell
            cell.configure(produce: content.work?.produce, title: content.work?.workTitle, director: content.work?.director, genres: content.work?.genres, logline: content.work?.logline)
            return cell
        case JobOpeningDetailSection.workCondition.rawValue:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as WorkConditionCell
            cell.configure(salaryType: content.work?.salaryType, salary: content.work?.salary, location: content.work?.workingLocation, period: content.work?.workingDate, workDays: content.work?.selectedDays, workingTime: content.work?.workingTime)
            return cell
        case JobOpeningDetailSection.summary.rawValue:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as SummaryCell
            let summary = viewModel.jobOpeningDetail?.work?.details ?? ""
            cell.configure(item: summary)
            return cell
        case JobOpeningDetailSection.contactInfo.rawValue:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as ContactInfoCell
            cell.configure(manager: content.work?.manager, email: content.work?.email)
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
            height = WorkInfoCell.cellHeight(viewModel.jobOpeningDetail?.work?.logline)
        case JobOpeningDetailSection.workCondition.rawValue:
            height = 213
        case JobOpeningDetailSection.summary.rawValue:
            height = SummaryCell.cellHeight(viewModel.jobOpeningDetail?.work?.details)
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
