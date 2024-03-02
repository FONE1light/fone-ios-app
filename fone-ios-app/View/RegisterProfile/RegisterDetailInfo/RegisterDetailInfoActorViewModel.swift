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
        registerDetailContentViewModel.jobType = .actor
        
        let scene = Scene.registerDetailContent(registerDetailContentViewModel)
        sceneCoordinator.transition(to: scene, using: .push, animated: true)
    }
}
