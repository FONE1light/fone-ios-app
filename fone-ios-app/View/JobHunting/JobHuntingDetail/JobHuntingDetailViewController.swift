//
//  JobHuntingDetailViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 12/13/23.
//

import UIKit
import RxSwift
import MessageUI

enum JobHuntingDetailSection: Int, CaseIterable {
    case author = 0
    /// 프로필 이미지 리스트
    case profileList
    /// 배우 정보 / 스태프 정보
    case actorStaffInfo
    /// 상세 요강
    case summary
    /// 주요 경력
    case mainCareer
    /// 분야
    case categories
    /// 본 정보는 ~
    case footer
}

class JobHuntingDetailViewController: UIViewController, ViewModelBindableType, ReportableType, MFMailComposeViewControllerDelegate {
    
    var viewModel: JobHuntingDetailViewModel!
    var disposeBag = DisposeBag()
    
    var profileImageURL: String?
    var nickname: String?
    var userJob: String?
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var contactButton: CustomButton!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.bounces = false
            tableView.separatorStyle = .none
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setNavigationBar()
        setCollectionView()
    }
    
    func bindViewModel() {
        setReportInfo()
        
        saveButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.viewModel.saveProfile()
            }.disposed(by: rx.disposeBag)
        
        viewModel.saveSubject
            .withUnretained(self)
            .subscribe(onNext: { owner, isSaved in
                owner.setSaveButtonStatus(saved: isSaved)
            }).disposed(by: rx.disposeBag)
        
        setSaveButtonStatus(saved: viewModel.jobHuntingDetail.isWant ?? false)
        
        contactButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                let contactType =  owner.viewModel.jobHuntingDetail.registerContactLinkInfo?.contactMethod
                let contact = owner.viewModel.jobHuntingDetail.registerContactLinkInfo?.contact ?? ""
                if contactType == ContactTypeOptions.email.serverParameter {
                    if MFMailComposeViewController.canSendMail() {
                        owner.sendEmail(to: contact)
                    } else {
                        owner.showMailErrorPopup()
                    }
                } else {
                    if let url = URL(string: contact) {
                        UIApplication.shared.open(url, options: [:])
                    }
                }
            }.disposed(by: rx.disposeBag)
    }
    
    private func setupUI() {
        contactButton.xibInit("연락하기", type: .contact)
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
        setReportInfo()
    }
    
    private func setReportInfo() {
        self.profileImageURL = viewModel.jobHuntingDetail.userProfileURL
        self.nickname = viewModel.jobHuntingDetail.userNickname
        self.userJob = viewModel.jobHuntingDetail.userJob
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
    
    private func setSaveButtonStatus(saved: Bool) {
        saveButton.imageView?.image = saved ? UIImage(resource: .heartOn) : UIImage(resource: .heart02Off)
        saveButton.titleLabel?.textColor = saved ? .gray_161616 : .gray_555555
    }
    
    private func sendEmail(to contact: String) {
        let composeViewController = MFMailComposeViewController()
                composeViewController.mailComposeDelegate = self
        composeViewController.setToRecipients([contact])
        self.present(composeViewController, animated: true, completion: nil)
    }
    
    private func showMailErrorPopup() {
            let message = "메일을 보내려면 'Mail' 앱이 필요합니다. App Store에서 해당 앱을 복원하거나 이메일 설정을 확인하고 다시 시도해주세요."
            let alert = UIAlertController.createTwoBlackButtonPopup(
                title: message,
                cancelButtonText: "취소",
                continueButtonText: "App Store"
            ) { _ in
                if let url = URL(string: "https://apps.apple.com/kr/app/mail/id1108187098"), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            
            present(alert, animated: true)
    }
}


extension JobHuntingDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        JobHuntingDetailSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let profile = viewModel.jobHuntingDetail
        
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
            let urls = profile.registerBasicInfo?.profileImages?.prefix(3) ?? []
            
            cell.configure(
                title: profile.registerBasicInfo?.hookingComment,
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
            switch viewModel.jobType {
            case .actor:
                let cell = tableView.dequeueReusableCell(for: indexPath) as ActorInfoTableViewCell
                guard let actorInfo = viewModel.actorInfo else { return cell }
                
                cell.configure(
                    name: actorInfo.name,
                    gender: actorInfo.gender,
                    birthYear: actorInfo.birthYear,
                    age: actorInfo.age,
                    height: actorInfo.height,
                    weight: actorInfo.weight,
                    email: actorInfo.email,
                    specialty: actorInfo.specialty
                )
                return cell
                
            case .staff:
                let cell = tableView.dequeueReusableCell(for: indexPath) as StaffInfoTableViewCell
                guard let staffInfo = viewModel.staffInfo else { return cell }
                
                cell.configure(
                    name: staffInfo.name,
                    gender: staffInfo.gender,
                    birthYear: staffInfo.birthYear,
                    age: staffInfo.age,
                    domains: staffInfo.domains,
                    email: staffInfo.email,
                    specialty: staffInfo.specialty
                )
                return cell
                
            default: return UITableViewCell()
            }
            
        case JobHuntingDetailSection.summary.rawValue:
            let cell = tableView.dequeueReusableCell(for: indexPath) as SummaryTableViewCell
            let summary = profile.registerDetailContentInfo?.details ?? ""
            
            cell.configure(item: summary)
            return cell
            
        case JobHuntingDetailSection.mainCareer.rawValue:
            let cell = tableView.dequeueReusableCell(for: indexPath) as MainCareerTableViewCell
            let career = CareerType.getType(serverName: profile.registerCareerInfo?.career)?.name ?? ""
            
            cell.configure(years: career, detail: profile.registerCareerInfo?.careerDetail)
            return cell
            
        case JobHuntingDetailSection.categories.rawValue:
            let cell = tableView.dequeueReusableCell(for: indexPath) as CategoriesTableViewCell
            let categories = profile.registerInterestInfo?.categories?
                .compactMap { Category.getType(serverName: $0) }
            guard let categories = categories else { return cell }
            
            cell.configure(categories)
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(for: indexPath) as FooterTableViewCell
            return cell
        }
    }
}
