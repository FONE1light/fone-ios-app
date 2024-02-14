//
//  RecruitContactInfoViewModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 12/13/23.
//

import UIKit
import RxSwift

struct RecruitContactInfo: Codable {
    let manager, email: String?
}

final class RecruitContactInfoViewModel: CommonViewModel {
    let disposeBag = DisposeBag()
    var jobType: Job?
    var recruitContactLinkInfo: RecruitContactLinkInfo?
    var recruitBasicInfo: RecruitBasicInfo?
    var recruitConditionInfo: RecruitConditionInfo?
    var recruitWorkInfo: RecruitWorkInfo?
    var recruitWorkConditionInfo: RecruitWorkConditionInfo?
    var recruitDetailInfo: RecruitDetailInfo?
    
    init(sceneCoordinator: SceneCoordinatorType, jobType: Job?, recruitContactLinkInfo: RecruitContactLinkInfo?, recruitBasicInfo: RecruitBasicInfo?, recruitConditionInfo: RecruitConditionInfo?, recruitWorkInfo: RecruitWorkInfo?, recruitWorkConditionInfo: RecruitWorkConditionInfo?, recruitDetailInfo: RecruitDetailInfo) {
        super.init(sceneCoordinator: sceneCoordinator)
        
        self.jobType = jobType
        self.recruitContactLinkInfo = recruitContactLinkInfo
        self.recruitBasicInfo = recruitBasicInfo
        self.recruitConditionInfo = recruitConditionInfo
        self.recruitWorkInfo = recruitWorkInfo
        self.recruitWorkConditionInfo = recruitWorkConditionInfo
        self.recruitDetailInfo = recruitDetailInfo
    }
    
    func createJobOpenings(recruitContactInfo: RecruitContactInfo) {
        let jobOpeningRequest = JobOpeningRequest(recruitBasicInfo: recruitBasicInfo, recruitConditionInfo: recruitConditionInfo, recruitWorkInfo: recruitWorkInfo, recruitWorkConditionInfo: recruitWorkConditionInfo, recruitDetailInfo: recruitDetailInfo, recruitContactInfo: recruitContactInfo, jobType: jobType)
        jobOpeningInfoProvider.rx.request(.createJobOpenings(jobOpeningRequest: jobOpeningRequest))
            .mapObject(JobOpeningContent.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                print(response)
                owner.showSuccessPopUp()
            }, onError: { error in
                print(error)
            }).disposed(by: disposeBag)
    }
}

// MARK: - 화면 전환 관련
extension RecruitContactInfoViewModel {
    private func showSuccessPopUp() {
        let message = "등록에 성공하였습니다"
        let alert = UIAlertController.createOneButtonPopup(title: message) { [weak self] _ in
            guard let self = self else { return }
            self.popToJobOpening()
        }
        guard let currentVC = (sceneCoordinator as? SceneCoordinator)?.currentVC else { return }
        currentVC.present(alert, animated: true) {
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(
                UITapGestureRecognizer(
                    target: self,
                    action: #selector(self.popToJobOpening)
                )
            )
        }
    }
    
    @objc private func popToJobOpening() {
        guard let currentVC = (sceneCoordinator as? SceneCoordinator)?.currentVC,
              let navigationController = currentVC.navigationController else { return }
        
        currentVC.dismiss(animated: false) {
            for vc in navigationController.viewControllers {
                if let jobOpeningHuntingVC = vc as? JobOpeningHuntingViewController {
                    navigationController.popToViewController(jobOpeningHuntingVC, animated: true)
                }
            }
        }
    }
}
