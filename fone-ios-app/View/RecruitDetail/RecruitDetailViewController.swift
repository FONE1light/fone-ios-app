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
        collectionView.register(CompetitionModule.self)
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
//        case RecruitDetailSection.image.rawValue:
//            height = width / 375 * 400
//        case RecruitDetailSection.recruitCondition.rawValue:
//            height = 244
//        case RecruitDetailSection.info.rawValue:
//            height = 234
//        case RecruitDetailSection.workCondition.rawValue:
//            height = 233
//        case RecruitDetailSection.summary.rawValue:
//            height = 450
//        case RecruitDetailSection.contactInfo.rawValue:
//            height = 118
        default:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as CompetitionModule
            cell.setModuelInfo(info: nil)
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
            height = 118
        default:
            height = 0
        }
        
        return CGSize(width: width, height: height)
    }
}
