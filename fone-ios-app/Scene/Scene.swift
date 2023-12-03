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
    case jobOpeningDetail(JobOpeningDetailViewModel)
    case recruitBasicInfo(RecruitBasicInfoViewModel) // 모집 글쓰기1
    case recruitConditionInfo // 모집 글쓰기2
    case registerBasicInfo(RegisterBasicInfoViewModel) // 프로필 등록하기1
    case registerDetailInfo(RegisterDetailInfoViewModel) // 프로필 등록하기2
    case registerDetailContent(RegisterDetailContentViewModel) // 프로필 등록하기3
    case registerCareer(RegisterCareerViewModel) // 프로필 등록하기4
    case registerInterest(RegisterInterestViewModel) // 프로필 등록하기5
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
            
        case .recruitConditionInfo:
            var recruitConditionInfoVC = RecruitConditionInfoViewController()
            
            return recruitConditionInfoVC
            
        case .registerBasicInfo(let registerBasicInfoViewModel):
            var registerBasicInfoVC = RegisterBasicInfoViewController()
            
            DispatchQueue.main.async {
                registerBasicInfoVC.bind(viewModel: registerBasicInfoViewModel)
            }
            
            return registerBasicInfoVC
            
        case .registerDetailInfo(let registerDetailInfoViewModel):
            var registerDetailInfoVC = RegisterDetailInfoViewController()
            
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
        }
    }
}
