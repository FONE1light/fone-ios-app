//
//  RecruitContactInfoViewModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 12/13/23.
//

import UIKit
import RxSwift
import Moya

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
    
    func validateManager(recruitContactInfo: RecruitContactInfo) {
        validationProvider.rx.request(.validateManager(recruitContactInfo: recruitContactInfo))
            .mapObject(Result<String>.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(
                onNext: { owner, response in
                    if response.result?.isSuccess == true {
                        owner.createJobOpenings(recruitContactInfo: recruitContactInfo)
                    } else {
                        response.message?.toast(positionType: .withButton)
                    }
                },
                onError: { error in
                    error.showToast(modelType: String.self, positionType: .withButton)
                }
            ).disposed(by: disposeBag)
    }
    
    func createJobOpenings(recruitContactInfo: RecruitContactInfo) {
        let jobOpeningRequest = JobOpeningRequest(recruitContactLinkInfo: recruitContactLinkInfo, recruitBasicInfo: recruitBasicInfo, recruitConditionInfo: recruitConditionInfo, recruitWorkInfo: recruitWorkInfo, recruitWorkConditionInfo: recruitWorkConditionInfo, recruitDetailInfo: recruitDetailInfo, recruitContactInfo: recruitContactInfo, jobType: jobType)
        jobOpeningInfoProvider.rx.request(.createJobOpenings(jobOpeningRequest: jobOpeningRequest))
            .mapObject(JobOpeningData.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                print(response)
                owner.showSuccessPopUp()
            }, onError: { error in
                print(error)
                guard let response = (error as? MoyaError)?.response,
                      let errorData = try? response.mapObject(Result<String>.self) else { return }
                errorData.message?.toast(positionType: .withButton)
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
