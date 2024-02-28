//
//  RegisterInterestViewModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/28/23.
//

import UIKit
import RxSwift

class RegisterInterestViewModel: CommonViewModel {
    private let disposeBag = DisposeBag()
    var jobType: Job?
}

extension RegisterInterestViewModel {
    
    func validate(categories: [String]?) {
        let interestRequest = InterestRequest(categories: categories)
        
        profileInfoProvider.rx.request(.validateInterst(request: interestRequest))
            .mapObject(Result<EmptyData>.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(
                onNext: { owner, response in
                    if response.result?.isSuccess == true {
//                        owner.register()
                    } else {
                        response.message?.toast(positionType: .withButton)
                    }
                },
                onError: { error in
                    error.showToast(modelType: String.self, positionType: .withButton)
                }
            ).disposed(by: disposeBag)
    }
    
    private func register() {
        // TODO: API 호출
        
        var isSucceeded = true
        if isSucceeded {
            showSuccessPopUp()
        } else {
            "게시물 등록에 실패했습니다. 다시 시도해주세요.".toast(positionType: .withButton)
        }
    }
}

// MARK: - 화면 전환 관련
extension RegisterInterestViewModel {
    private func showSuccessPopUp() {
        let message = "등록에 성공하였습니다"
        let alert = UIAlertController.createOneButtonPopup(title: message) { [weak self] _ in
            guard let self = self else { return }
            self.popToJobOpening()
        }
        guard let currentVC = (sceneCoordinator as? SceneCoordinator)?.currentVC else { return }
        currentVC.present(alert, animated: true) {
            // 바깥의 dim view 선택 시 동작 설정
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
