//
//  RegisterDetailInfoStaffViewModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/28/23.
//

import UIKit
import RxRelay
import RxSwift

class RegisterDetailInfoStaffViewModel: CommonViewModel {
    
    private let disposeBag = DisposeBag()
    let selectedDomains = BehaviorRelay<[Selection]>(value: [])
    
    func validate(detailInfoRequest: DetailInfoRequest) {
        profileInfoProvider.rx.request(.validateDetailInfo(request: detailInfoRequest))
            .mapObject(Result<EmptyData>.self)
            .asObservable()
            .withUnretained(self)
            .subscribe (
                onNext: { owner, response in
                    if response.result?.isSuccess == true {
                        owner.moveToRegisterDetailContent()
                    } else {
                        response.message?.toast(positionType: .withButton)
                    }
                },
                onError: { error in
                    error.showToast(modelType: String.self, positionType: .withButton)
                }).disposed(by: disposeBag)
    }
    
    private func moveToRegisterDetailContent() {
        let sceneCoordinator = sceneCoordinator
        let registerDetailContentViewModel = RegisterDetailContentViewModel(sceneCoordinator: sceneCoordinator)
        registerDetailContentViewModel.jobType = .staff
        
        let scene = Scene.registerDetailContent(registerDetailContentViewModel)
        sceneCoordinator.transition(to: scene, using: .push, animated: true)
    }
}
