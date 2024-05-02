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
    
    private var registerContactLinkInfo: RegisterContactLinkInfo
    private var registerBasicInfo: RegisterBasicInfo
    private var registerDetailInfo: RegisterDetailInfo
    
    init(
        sceneCoordinator: SceneCoordinatorType,
        jobType: Job?,
        registerContactLinkInfo: RegisterContactLinkInfo,
        registerBasicInfo: RegisterBasicInfo,
        registerDetailInfo: RegisterDetailInfo
    ) {
        self.jobType = jobType
        self.registerContactLinkInfo = registerContactLinkInfo
        self.registerBasicInfo = registerBasicInfo
        self.registerDetailInfo = registerDetailInfo
        super.init(sceneCoordinator: sceneCoordinator)
    }
    
    func validate(details: String?) {
        let detailContentRequest = RegisterDetailContentInfo(details: details)
        
        profileInfoProvider.rx.request(.validateDetailContent(request: detailContentRequest))
            .mapObject(Result<EmptyData>.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(
                onNext: { owner, response in
                    if response.result?.isSuccess == true {
                        owner.moveToRegisterCareer(detailContentRequest)
                    } else {
                        response.message?.toast(positionType: .withButton)
                    }
                },
                onError: { error in
                    error.showToast(modelType: String.self, positionType: .withButton)
                }
            ).disposed(by: disposeBag)
    }
    
    private func moveToRegisterCareer(_ registerDetailContentInfo: RegisterDetailContentInfo) {
        let sceneCoordinator = sceneCoordinator
        let registerCareerViewModel = RegisterCareerViewModel(
            sceneCoordinator: sceneCoordinator,
            jobType: jobType,
            registerContactLinkInfo: registerContactLinkInfo,
            registerBasicInfo: registerBasicInfo,
            registerDetailInfo: registerDetailInfo,
            registerDetailContentInfo: registerDetailContentInfo
        )
        
        let scene = Scene.registerCareer(registerCareerViewModel)
        sceneCoordinator.transition(to: scene, using: .push, animated: true)
        
    }
}

