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
    
    private var registerContactLinkInfo: RegisterContactLinkInfo
    private var registerBasicInfo: RegisterBasicInfo
    
    init(
        sceneCoordinator: SceneCoordinatorType,
        registerContactLinkInfo: RegisterContactLinkInfo,
        registerBasicInfo: RegisterBasicInfo
    ) {
        self.registerContactLinkInfo = registerContactLinkInfo
        self.registerBasicInfo = registerBasicInfo
        super.init(sceneCoordinator: sceneCoordinator)
    }
    
    func validate(detailInfoRequest: RegisterDetailInfo) {
        profileInfoProvider.rx.request(.validateDetailInfo(request: detailInfoRequest))
            .mapObject(Result<EmptyData>.self)
            .asObservable()
            .withUnretained(self)
            .subscribe (
                onNext: { owner, response in
                    if response.result?.isSuccess == true {
                        owner.moveToRegisterDetailContent(detailInfoRequest)
                    } else {
                        response.message?.toast(positionType: .withButton)
                    }
                },
                onError: { error in
                    error.showToast(modelType: String.self, positionType: .withButton)
                }).disposed(by: disposeBag)
    }
    
    private func moveToRegisterDetailContent(_ registerDetailInfo: RegisterDetailInfo) {
        let sceneCoordinator = sceneCoordinator
        let registerDetailContentViewModel = RegisterDetailContentViewModel(
            sceneCoordinator: sceneCoordinator,
            jobType: .staff,
            registerContactLinkInfo: registerContactLinkInfo,
            registerBasicInfo: registerBasicInfo,
            registerDetailInfo: registerDetailInfo
        )
        
        let scene = Scene.registerDetailContent(registerDetailContentViewModel)
        sceneCoordinator.transition(to: scene, using: .push, animated: true)
    }
}
