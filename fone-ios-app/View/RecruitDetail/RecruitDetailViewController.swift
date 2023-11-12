//
//  RecruitDetailViewController.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 11/12/23.
//

import UIKit

enum RecruitDetailSection: Int, CaseIterable {
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

class RecruitDetailViewController: UIViewController, ViewModelBindableType {
    var viewModel: RecruitDetailViewModel!

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func bindViewModel() {
        setNavigationBar()
        setCollectionView()
    }
    
    private func setNavigationBar() {
        navigationController?.hidesBarsOnSwipe = false
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

extension RecruitDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return RecruitDetailSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case RecruitDetailSection.author.rawValue:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as AuthorCell
            return cell
        case RecruitDetailSection.title.rawValue:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as TitleCell
            return cell
        case RecruitDetailSection.image.rawValue:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as DetailImageCell
            return cell
        case RecruitDetailSection.recruitCondition.rawValue:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as RecruitConditionCell
            return cell
        case RecruitDetailSection.info.rawValue:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as WorkInfoCell
            return cell
        case RecruitDetailSection.workCondition.rawValue:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as WorkConditionCell
            return cell
        case RecruitDetailSection.summary.rawValue:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as SummaryCell
            return cell
        case RecruitDetailSection.contactInfo.rawValue:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as ContactInfoCell
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as FooterCell
            return cell
        }
    }
}

extension RecruitDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: Double = UIScreen.main.bounds.width
        var height: Double = 250
        switch indexPath.section {
        case RecruitDetailSection.author.rawValue:
            height = 79
        case RecruitDetailSection.title.rawValue:
            height = 116
        case RecruitDetailSection.image.rawValue:
            height = width / 375 * 400
        case RecruitDetailSection.recruitCondition.rawValue:
            height = 244
        case RecruitDetailSection.info.rawValue:
            height = 234
        case RecruitDetailSection.workCondition.rawValue:
            height = 233
        case RecruitDetailSection.summary.rawValue:
            height = 450
        case RecruitDetailSection.contactInfo.rawValue:
            height = 118 // FIXME: 라벨 높이에 따라 높이 수정
        case RecruitDetailSection.footer.rawValue:
            height = 187
        default:
            height = 0
        }
        
        return CGSize(width: width, height: height)
    }
}
