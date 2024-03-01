//
//  RegisterDetailInfoActorViewModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/19/23.
//

import UIKit
import RxSwift

class RegisterDetailInfoActorViewModel: CommonViewModel {
    
    private let disposeBag = DisposeBag()
    
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
            jobType: .actor,
            registerContactLinkInfo: registerContactLinkInfo,
            registerBasicInfo: registerBasicInfo,
            registerDetailInfo: registerDetailInfo
        )
        
        let scene = Scene.registerDetailContent(registerDetailContentViewModel)
        sceneCoordinator.transition(to: scene, using: .push, animated: true)
    }
}
