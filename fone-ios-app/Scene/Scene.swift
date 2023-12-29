//
//  Scene.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/08/07.
//

import UIKit

enum Scene {
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
    
    // 마이페이지 내부
    case profile(ProfileViewModel) // 프로필 수정
    case scrap(ScrapViewModel)     // 스크랩
    case competition(CompetitionViewModel) // 공모전 // TODO: 구인구직, 공모전 뷰 컨 UI 범위 확인 후 삭제
    case savedProfiles(SavedProfilesTabBarViewModel) // 찜한 프로필
    case myRegistrations(MyRegistrationsViewModel) // 나의 등록내역
    
    // 구인구직
    case jobOpeningDetail(JobOpeningDetailViewModel) // 모집 상세
    case recruitBasicInfo(RecruitBasicInfoViewModel) // 모집 글쓰기1
    case recruitConditionInfo(RecruitConditionInfoViewModel) // 모집 글쓰기2
    case recruitWorkInfo(RecruitWorkInfoViewModel) // 모집 글쓰기3
    case recruitWorkCondition(RecruitWorkConditionViewModel) // 모집 글쓰기4
    case recruitDetailInfo(RecruitDetailInfoViewModel) // 모집 글쓰기5
    case recruitContactInfo(RecruitContactInfoViewModel) // 모집 글쓰기5
    
    case jobHuntingDetail(JobHuntingDetailViewModel) // 프로필 상세
    case registerBasicInfo(RegisterBasicInfoViewModel) // 프로필 등록하기1
    case registerDetailInfoActor(RegisterDetailInfoActorViewModel) // 프로필 등록하기2 - 배우
    case registerDetailInfoStaff(RegisterDetailInfoStaffViewModel) // 프로필 등록하기2 - 스태프
    case registerDetailContent(RegisterDetailContentViewModel) // 프로필 등록하기3
    case registerCareer(RegisterCareerViewModel) // 프로필 등록하기4
    case registerInterest(RegisterInterestViewModel) // 프로필 등록하기5
    
    case jobHuntingProfiles(JobHuntingProfilesViewModel) // 프로필 상세 > 이미지 더보기
    
    case filter(FilterViewModel)

    // 모달
    case reportBottomSheet(SceneCoordinatorType) // 신고하기 바텀시트
    case jobOpeningSortBottomSheet(JobOpeningSortBottomSheetViewModel) // 구인구직 탭 > 정렬 바텀시트
    case profilePreview(ProfilePreviewViewModel) // 프로필 이미지 크게 보기
    case snsWebViewController(SNSWebViewModel) // 개인 SNS(웹)
}

extension Scene {
    func instantiate() -> UIViewController {
        switch self {
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
            
            DispatchQueue.main.async {
                myPageVC.bind(viewModel: myPageViewModel)
            }
            
            return myPageVC
            
        case .profile(let profileViewModel):
            var profileVC = ProfileViewController()
            
            DispatchQueue.main.async {
                profileVC.bind(viewModel: profileViewModel)
            }
            
            return profileVC
            
        case .scrap(let scrapViewModel):
            var scrapVC = ScrapViewController()
            
            DispatchQueue.main.async {
                scrapVC.bind(viewModel: scrapViewModel)
            }
            
            return scrapVC
            
        case .competition(let competitionViewModel):
            var competitionVC = CompetitionViewController()
            
            DispatchQueue.main.async {
                competitionVC.bind(viewModel: competitionViewModel)
            }
            
            return competitionVC
            
        case .savedProfiles(let savedProfilesTabBarViewModel):
            var savedProfilesVC = SavedProfilesTabBarController()
            
            DispatchQueue.main.async {
                savedProfilesVC.bind(viewModel: savedProfilesTabBarViewModel)
            }
            
            return savedProfilesVC
            
        case .myRegistrations(let myRegistrationsViewModel):
            var myRegistrationsVC = MyRegistrationsViewController()
            
            DispatchQueue.main.async {
                myRegistrationsVC.bind(viewModel: myRegistrationsViewModel)
            }
            
            return myRegistrationsVC
            
        case .jobOpeningDetail(let recruitDetailViewModel):
            var jobOpeningDetailVC = JobOpeningDetailViewController()
            
            DispatchQueue.main.async {
                jobOpeningDetailVC.bind(viewModel: recruitDetailViewModel)
                jobOpeningDetailVC.collectionView.reloadData()
            }
            
            return jobOpeningDetailVC
            
        case .recruitBasicInfo(let recruitBasicInfoViewModel):
            var recruitBasicInfoVC = RecruitBasicInfoViewController()
            
            DispatchQueue.main.async {
                recruitBasicInfoVC.bind(viewModel: recruitBasicInfoViewModel)
            }
            
            return recruitBasicInfoVC
            
        case .recruitConditionInfo(let recruitConditionInfoViewModel):
            var recruitConditionInfoVC = RecruitConditionInfoViewController()
            
            DispatchQueue.main.async {
                recruitConditionInfoVC.bind(viewModel: recruitConditionInfoViewModel)
            }
            
            return recruitConditionInfoVC
            
        case .recruitWorkInfo(let recruitWorkInfoViewModel):
            var recruitWorkInfoVC = RecruitWorkInfoViewController()
            
            DispatchQueue.main.async {
                recruitWorkInfoVC.bind(viewModel: recruitWorkInfoViewModel)
            }
            
            return recruitWorkInfoVC
            
        case .recruitWorkCondition(let recruitWorkConditionViewModel):
            var recruitWorkConditionVC = RecruitWorkConditionViewController()
            
            DispatchQueue.main.async {
                recruitWorkConditionVC.bind(viewModel: recruitWorkConditionViewModel)
            }
            
            return recruitWorkConditionVC
            
        case .recruitDetailInfo(let recruitDetailInfoViewModel):
            var recruitDetailInfoVC = RecruitDetailInfoViewController()
            
            DispatchQueue.main.async {
                recruitDetailInfoVC.bind(viewModel: recruitDetailInfoViewModel)
            }
            
            return recruitDetailInfoVC
            
        case .recruitContactInfo(let recruitContactInfoViewModel):
            var recruitContactInfoVC = RecruitContactInfoViewController()
            
            DispatchQueue.main.async {
                recruitContactInfoVC.bind(viewModel: recruitContactInfoViewModel)
            }
            
            return recruitContactInfoVC
            
        case .jobHuntingDetail(let jobHuntingDetailViewModel):
            var jobHuntingDetailVC = JobHuntingDetailViewController()
            
            jobHuntingDetailVC.bind(viewModel: jobHuntingDetailViewModel)
            
            return jobHuntingDetailVC
            
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
            
        case .filter(let filterViewModel):
            var filterVC = FilterViewController()
            
            filterVC.bind(viewModel: filterViewModel)
            
            return filterVC

        case .reportBottomSheet(let sceneCoordinator):
            let bottomSheet = ReportBottomSheet()
            let bottomSheetVC = BottomSheetViewController(view: bottomSheet, sceneCoordinator: sceneCoordinator)

            return bottomSheetVC
            
        case .jobOpeningSortBottomSheet(let jobOpeningSortBottomSheetViewModel):
            var jobOpeningSortBottomSheetVC = JobOpeningSortBottomSheetViewController()
            
            jobOpeningSortBottomSheetVC.bind(viewModel: jobOpeningSortBottomSheetViewModel)
            
//            return jobOpeningSortBottomSheetVC // 노출X
            let bottomSheetVC = BottomSheetViewController(view: jobOpeningSortBottomSheetVC.view, sceneCoordinator: jobOpeningSortBottomSheetViewModel.sceneCoordinator)
            
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
        }
    }
}
