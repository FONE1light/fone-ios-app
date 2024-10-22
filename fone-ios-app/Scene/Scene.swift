//
//  Scene.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/08/07.
//

import UIKit
import RxRelay

enum Scene {
    case fakeLaunchScreen(SceneCoordinator)
    case home(SceneCoordinator)
    case login(LoginViewModel)
    case findIDPassword(FindIDPasswordViewModel)
    case signUpSelection(SignUpSelectionViewModel) // 회원가입1
    case signUpPersonalInfo(SignUpPersonalInfoViewModel) // 회원가입2
    case signUpPhoneNumber(SignUpPhoneNumberViewModel) // 회원가입3
    case signUpSuccess(SignUpSuccessViewModel) // 회원가입 완료
    case question(QuestionViewModel)
    case emailLogin(EmailLoginViewModel)
    case emailSignUp(EmailSignUpViewModel)
    case notification
    case myPage(MyPageViewModel)
    case report(ReportViewModel)
    
    // 마이페이지 내부
    case profile(ProfileViewModel) // 프로필 수정
    case scrap(ScrapViewModel)                  // 스크랩
    case scrapJob(JobViewModel)                 // 스크랩 > 구인구직 content 영역
    case scrapCompetition(CompetitionViewModel) // 스크랩 > 공모전 content 영역
    case savedProfiles(SavedProfilesTabBarViewModel)         // 찜한 프로필
    case savedProfilesContent(SavedProfilesContentViewModel) // 찜한 프로필 content 영역
    case myRegistrations(MyRegistrationsViewModel)          // 나의 등록내역
    case jobRegistrations(JobRegistrationViewModel)         // 나의 등록내역 > 모집 content 영역
    case profileRegistrations(ProfileRegistrationViewModel) // 나의 등록내역 > 프로필 content 영역
    
    // 구인구직
    case jobOpeningDetail(JobOpeningDetailViewModel) // 모집 상세
    case recruitContactLinkInfo(RecruitContactLinkInfoViewModel) // 모집 글쓰기1
    case recruitBasicInfo(RecruitBasicInfoViewModel) // 모집 글쓰기2
    case recruitConditionInfo(RecruitConditionInfoViewModel) // 모집 글쓰기3
    case recruitWorkInfo(RecruitWorkInfoViewModel) // 모집 글쓰기4
    case recruitWorkCondition(RecruitWorkConditionViewModel) // 모집 글쓰기5
    case recruitDetailInfo(RecruitDetailInfoViewModel) // 모집 글쓰기6
    case recruitContactInfo(RecruitContactInfoViewModel) // 모집 글쓰기7
    
    case jobHuntingDetail(JobHuntingDetailViewModel) // 프로필 상세
    case registerContactLinkInfo(RegisterContactLinkInfoViewModel) // 프로필 등록하기1
    case registerBasicInfo(RegisterBasicInfoViewModel) // 프로필 등록하기2
    case registerDetailInfoActor(RegisterDetailInfoActorViewModel) // 프로필 등록하기3 - 배우
    case registerDetailInfoStaff(RegisterDetailInfoStaffViewModel) // 프로필 등록하기3 - 스태프
    case registerDetailContent(RegisterDetailContentViewModel) // 프로필 등록하기4
    case registerCareer(RegisterCareerViewModel) // 프로필 등록하기5
    case registerInterest(RegisterInterestViewModel) // 프로필 등록하기6
    
    case jobHuntingProfiles(JobHuntingProfilesViewModel) // 프로필 상세 > 이미지 더보기
    
    case filterActor(FilterActorViewModel)
    case filterStaff(FilterStaffViewModel)

    // 모달
    case reportBottomSheet(ReportBottomSheetViewModel) // 신고하기 바텀시트
    case profilePreview(ProfilePreviewViewModel) // 프로필 이미지 크게 보기
    case snsWebViewController(SNSWebViewModel) // 개인 SNS(웹)
    case salaryTypeBottomSheet(SceneCoordinatorType, PublishRelay<SalaryType>)
    case optionsBottomSheet(OptionsBottomSheetViewModel) // 선택 가능 바텀시트(공통)
    case logoutBottomSheet(LogoutBottomSheetViewModel) // 마이페이지 > 로그아웃
    case signoutBottomSheet(SignoutBottomSheetViewModel) // 마이페이지 > 회원 탈퇴
}

extension Scene {
    func instantiate() -> UIViewController {
        switch self {
        case .fakeLaunchScreen(let coordinator):
            var fakeLaunchScreenVC = FakeLaunchScreenViewController(sceneCoordinator: coordinator)
            
            return fakeLaunchScreenVC
            
        case .home(let coordinator):
            let tabBarController = TabBarViewController(coordinator: coordinator)
            
            return tabBarController
            
        case .login(let loginViewModel):
            var loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
            
            DispatchQueue.main.async {
                loginVC.bind(viewModel: loginViewModel)
            }
            
            let loginNav = UINavigationController(rootViewController: loginVC)
            
            return loginNav
            
        case .findIDPassword(let findIDPasswordViewModel):
            var findIDPasswordVC = FindIDPasswordViewController(nibName: "FindIDPasswordViewController", bundle: nil)
            
            DispatchQueue.main.async {
                findIDPasswordVC.bind(viewModel: findIDPasswordViewModel)
                findIDPasswordVC.findScreenCollectionView.reloadData()
            }
            
            return findIDPasswordVC
            
        case .signUpSelection(let signUpViewModel):
            var signUpVC = SignUpSelectionViewController()
            
            DispatchQueue.main.async {
                signUpVC.bind(viewModel: signUpViewModel)
            }
            
            return signUpVC
            
        case .signUpPersonalInfo(let signUpViewModel):
            var signUpVC = SignUpPersonalInfoViewController()
            
            DispatchQueue.main.async {
                signUpVC.bind(viewModel: signUpViewModel)
            }
            
            return signUpVC
            
        case .signUpPhoneNumber(let signUpViewModel):
            var signUpVC = SignUpPhoneNumberViewController()
            
            DispatchQueue.main.async {
                signUpVC.bind(viewModel: signUpViewModel)
            }
            
            return signUpVC
            
        case .signUpSuccess(let signUpViewModel):
            var signUpVC = SignUpSuccessViewController()
            
            DispatchQueue.main.async {
                signUpVC.bind(viewModel: signUpViewModel)
            }
            
            return signUpVC
            
        case .question(let questionViewModel):
            var questionVC = QuestionViewController(nibName: "QuestionViewController", bundle: nil)
            
            DispatchQueue.main.async {
                questionVC.bind(viewModel: questionViewModel)
            }
            
            return questionVC
            
        case .emailLogin(let emailLoginViewModel):
            var emailLoginVC = EmailLoginViewController(nibName: "EmailLoginViewController", bundle: nil)
            
            DispatchQueue.main.async {
                emailLoginVC.bind(viewModel: emailLoginViewModel)
            }
            
            let emailLoginNav = UINavigationController(rootViewController: emailLoginVC)
            
            return emailLoginNav
            
        case .emailSignUp(let emailSignUpViewModel):
            var emailSignUpVC = EmailSignUpViewController(nibName: "EmailSignUpViewController", bundle: nil)
            
            DispatchQueue.main.async {
                emailSignUpVC.bind(viewModel: emailSignUpViewModel)
            }
            
            let emailSignUpNav = UINavigationController(rootViewController: emailSignUpVC)
            
            return emailSignUpNav
            
        case .notification:
            let notiVC = NotiViewController()
            
            return notiVC
            
        case .myPage(let myPageViewModel):
            var myPageVC = MyPageViewController()
            
            myPageVC.bind(viewModel: myPageViewModel)
            
            return myPageVC
            
        case .report(let reportViewModel):
            var reportVC = ReportViewController()
            
            reportVC.bind(viewModel: reportViewModel)
            
            return reportVC
            
        case .profile(let profileViewModel):
            var profileVC = ProfileViewController()
            
            DispatchQueue.main.async {
                profileVC.bind(viewModel: profileViewModel)
            }
            
            return profileVC
            
        case .scrap(let scrapViewModel):
            var scrapVC = ScrapViewController()
            
            scrapVC.bind(viewModel: scrapViewModel)
            
            return scrapVC
            
        case .scrapJob(let jobViewModel):
            var jobVC = JobViewController()
            
            DispatchQueue.main.async {
                jobVC.bind(viewModel: jobViewModel)
            }
            
            return jobVC
            
        case .scrapCompetition(let competitionViewModel):
            var competitionVC = CompetitionViewController()
            
            DispatchQueue.main.async {
                competitionVC.bind(viewModel: competitionViewModel)
            }
            
            return competitionVC
            
        case .savedProfiles(let savedProfilesTabBarViewModel):
            var savedProfilesVC = SavedProfilesTabBarController()
            
            savedProfilesVC.bind(viewModel: savedProfilesTabBarViewModel)
            
            return savedProfilesVC
            
        case .savedProfilesContent(let savedProfilesContentViewModel):
            var savedProfilesContentVC = SavedProfilesContentViewController()
            
            DispatchQueue.main.async {
                savedProfilesContentVC.bind(viewModel: savedProfilesContentViewModel)
            }
            
            return savedProfilesContentVC
            
        case .myRegistrations(let myRegistrationsViewModel):
            var myRegistrationsVC = MyRegistrationsViewController()
            
            //            DispatchQueue.main.async {
            myRegistrationsVC.bind(viewModel: myRegistrationsViewModel)
            //            }
            
            return myRegistrationsVC
            
        case .jobRegistrations(let jobRegistrationsViewModel):
            var jobRegistrationsVC = JobRegistrationViewController()
            
            DispatchQueue.main.async {
                jobRegistrationsVC.bind(viewModel: jobRegistrationsViewModel)
            }
            
            return jobRegistrationsVC
            
        case .profileRegistrations(let profileRegistrationsViewModel):
            var profileRegistrationsVC = ProfileRegistrationViewController()
            
            DispatchQueue.main.async {
                profileRegistrationsVC.bind(viewModel: profileRegistrationsViewModel)
            }
            
            return profileRegistrationsVC
            
        case .jobOpeningDetail(let recruitDetailViewModel):
            var jobOpeningDetailVC = JobOpeningDetailViewController()
            
            DispatchQueue.main.async {
                jobOpeningDetailVC.bind(viewModel: recruitDetailViewModel)
                jobOpeningDetailVC.collectionView.reloadData()
            }
            
            return jobOpeningDetailVC
            
        case .recruitContactLinkInfo(let recruitContactLinkInfoViewModel):
            var recruitContactLinkInfoVC = RecruitContactLinkInfoViewController()
            recruitContactLinkInfoVC.jobType = recruitContactLinkInfoViewModel.jobType ?? .actor
            
            DispatchQueue.main.async {
                recruitContactLinkInfoVC.bind(viewModel: recruitContactLinkInfoViewModel)
            }
            
            return recruitContactLinkInfoVC
            
        case .recruitBasicInfo(let recruitBasicInfoViewModel):
            var recruitBasicInfoVC = RecruitBasicInfoViewController()
            recruitBasicInfoVC.jobType = recruitBasicInfoViewModel.jobType ?? .actor
            
            DispatchQueue.main.async {
                recruitBasicInfoVC.bind(viewModel: recruitBasicInfoViewModel)
            }
            
            return recruitBasicInfoVC
            
        case .recruitConditionInfo(let recruitConditionInfoViewModel):
            var recruitConditionInfoVC = RecruitConditionInfoViewController()
            recruitConditionInfoVC.jobType = recruitConditionInfoViewModel.jobType ?? .actor
            
            DispatchQueue.main.async {
                recruitConditionInfoVC.bind(viewModel: recruitConditionInfoViewModel)
            }
            
            return recruitConditionInfoVC
            
        case .recruitWorkInfo(let recruitWorkInfoViewModel):
            var recruitWorkInfoVC = RecruitWorkInfoViewController()
            recruitWorkInfoVC.jobType = recruitWorkInfoViewModel.jobType ?? .actor
            
            DispatchQueue.main.async {
                recruitWorkInfoVC.bind(viewModel: recruitWorkInfoViewModel)
            }
            
            return recruitWorkInfoVC
            
        case .recruitWorkCondition(let recruitWorkConditionViewModel):
            var recruitWorkConditionVC = RecruitWorkConditionViewController()
            recruitWorkConditionVC.jobType = recruitWorkConditionViewModel.jobType ?? .actor
            
            DispatchQueue.main.async {
                recruitWorkConditionVC.bind(viewModel: recruitWorkConditionViewModel)
            }
            
            return recruitWorkConditionVC
            
        case .recruitDetailInfo(let recruitDetailInfoViewModel):
            var recruitDetailInfoVC = RecruitDetailInfoViewController()
            recruitDetailInfoVC.jobType = recruitDetailInfoViewModel.jobType ?? .actor
            
            DispatchQueue.main.async {
                recruitDetailInfoVC.bind(viewModel: recruitDetailInfoViewModel)
            }
            
            return recruitDetailInfoVC
            
        case .recruitContactInfo(let recruitContactInfoViewModel):
            var recruitContactInfoVC = RecruitContactInfoViewController()
            recruitContactInfoVC.jobType = recruitContactInfoViewModel.jobType ?? .actor
            
            DispatchQueue.main.async {
                recruitContactInfoVC.bind(viewModel: recruitContactInfoViewModel)
            }
            
            return recruitContactInfoVC
            
        case .jobHuntingDetail(let jobHuntingDetailViewModel):
            var jobHuntingDetailVC = JobHuntingDetailViewController()
            
            jobHuntingDetailVC.bind(viewModel: jobHuntingDetailViewModel)
            
            return jobHuntingDetailVC
            
        case .registerContactLinkInfo(let registerContactLinkInfoViewModel):
            var registerContactLinkInfoVC = RegisterContactLinkInfoViewController()
            
            DispatchQueue.main.async {
                registerContactLinkInfoVC.bind(viewModel: registerContactLinkInfoViewModel)
            }
            
            return registerContactLinkInfoVC
            
        case .registerBasicInfo(let registerBasicInfoViewModel):
            var registerBasicInfoVC = RegisterBasicInfoViewController()
            
            DispatchQueue.main.async {
                registerBasicInfoVC.bind(viewModel: registerBasicInfoViewModel)
            }
            
            return registerBasicInfoVC
            
        case .registerDetailInfoActor(let registerDetailInfoViewModel):
            var registerDetailInfoVC = RegisterDetailInfoActorViewController()
            
            DispatchQueue.main.async {
                registerDetailInfoVC.bind(viewModel: registerDetailInfoViewModel)
            }
            
            return registerDetailInfoVC
            
        case .registerDetailInfoStaff(let registerDetailInfoViewModel):
            var registerDetailInfoVC = RegisterDetailInfoStaffViewController()
            
            DispatchQueue.main.async {
                registerDetailInfoVC.bind(viewModel: registerDetailInfoViewModel)
            }
            
            return registerDetailInfoVC
            
        case .registerDetailContent(let registerDetailContentViewModel):
            var registerDetailContentVC = RegisterDetailContentViewController()
            
            DispatchQueue.main.async {
                registerDetailContentVC.bind(viewModel: registerDetailContentViewModel)
            }
            
            return registerDetailContentVC
            
        case .registerCareer(let registerCareerViewModel):
            var registerCareerVC = RegisterCareerViewController()
            
            DispatchQueue.main.async {
                registerCareerVC.bind(viewModel: registerCareerViewModel)
            }
            
            return registerCareerVC
            
        case .registerInterest(let registerInterestViewModel):
            var registerInterestVC = RegisterInterestViewController()
            
            DispatchQueue.main.async {
                registerInterestVC.bind(viewModel: registerInterestViewModel)
            }
            
            return registerInterestVC
            
        case .jobHuntingProfiles(let jobHuntingProfilesViewModel):
            var jobHuntingProfilesVC = JobHuntingProfilesViewController()
            
            jobHuntingProfilesVC.bind(viewModel: jobHuntingProfilesViewModel)
            
            return jobHuntingProfilesVC
            
        case .filterActor(let filterActorViewModel):
            var filterActorVC = FilterActorViewController()
            
            filterActorVC.bind(viewModel: filterActorViewModel)
            
            return filterActorVC
            
        case .filterStaff(let filterStaffViewModel):
            var filterStaffVC = FilterStaffViewController()
            
            filterStaffVC.bind(viewModel: filterStaffViewModel)
            
            return filterStaffVC
            
        case .reportBottomSheet(let reportBottomSheetViewModel):
            var reportBottomSheetVC = ReportBottomSheetViewController()
            DispatchQueue.main.async {
                reportBottomSheetVC.bind(viewModel: reportBottomSheetViewModel)
            }
            let bottomSheetVC = BottomSheetViewController(view: reportBottomSheetVC.view, sceneCoordinator: reportBottomSheetViewModel.sceneCoordinator)
            
            return bottomSheetVC
            
        case .profilePreview(let profilePreviewViewModel):
            var profilePreviewVC = ProfilePreviewViewController()
            let navControlller = UINavigationController(rootViewController: profilePreviewVC)
            
            profilePreviewVC.bind(viewModel: profilePreviewViewModel)
            
            return navControlller
            
        case .snsWebViewController(let snsWebViewModel):
            var viewController = SNSWebViewController()
            let navControlller = UINavigationController(rootViewController: viewController)
            
            viewController.bind(viewModel: snsWebViewModel)
            return navControlller
            
        case .salaryTypeBottomSheet(let sceneCoordinator, let salaryTypeRelay):
            let bottomSheet = SalaryTypeBottomSheet(frame: .zero, salaryTypeRelay: salaryTypeRelay)
            let bottomSheetVC = BottomSheetViewController(view: bottomSheet, sceneCoordinator: sceneCoordinator)
            return bottomSheetVC
            
        case .optionsBottomSheet(let optionsBottomSheetViewModel):
            var optionsBottomSheetVC = OptionsBottomSheetViewController()
            
            optionsBottomSheetVC.bind(viewModel: optionsBottomSheetViewModel)
            
            let bottomSheetVC = BottomSheetViewController(view: optionsBottomSheetVC.view, sceneCoordinator: optionsBottomSheetViewModel.sceneCoordinator)
            
            return bottomSheetVC

        case .logoutBottomSheet(let logoutBottomSheetViewModel):
            var vc = LogoutBottomSheetViewController()
            
            vc.bind(viewModel: logoutBottomSheetViewModel)
            
            let bottomSheetVC = BottomSheetViewController(view: vc.view, sceneCoordinator: logoutBottomSheetViewModel.sceneCoordinator)
            
            return bottomSheetVC
            
        case .signoutBottomSheet(let signoutBottomSheetViewModel):
            var vc = SignoutBottomSheetViewController()
            
            vc.bind(viewModel: signoutBottomSheetViewModel)
            
            let bottomSheetVC = BottomSheetViewController(view: vc.view, sceneCoordinator: signoutBottomSheetViewModel.sceneCoordinator)
            
            return bottomSheetVC
        }
    }
}
