//
//  RegisterDetailContentViewModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/26/23.
//

import RxSwift

class RegisterDetailContentViewModel: CommonViewModel {
    
    private let disposeBag = DisposeBag()
    var jobType: Job?
    
    func validate(details: String?) {
        let detailContentRequest = DetailContentRequest(details: details)
        
        profileInfoProvider.rx.request(.validateDetailContent(request: detailContentRequest))
            .mapObject(Result<EmptyData>.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(
                onNext: { owner, response in
                    if response.result?.isSuccess == true {
                        owner.moveToRegisterCareer()
                    } else {
                        response.message?.toast(positionType: .withButton)
                    }
                },
                onError: { error in
                    error.showToast(modelType: String.self, positionType: .withButton)
                }
            ).disposed(by: disposeBag)
    }
    
    private func moveToRegisterCareer() {
        let sceneCoordinator = sceneCoordinator
        let registerCareerViewModel = RegisterCareerViewModel(sceneCoordinator: sceneCoordinator)
        registerCareerViewModel.jobType = jobType
        
        let scene = Scene.registerCareer(registerCareerViewModel)
        sceneCoordinator.transition(to: scene, using: .push, animated: true)
        
    }
}

