//
//  RegisterCareerViewModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/27/23.
//

import RxSwift

class RegisterCareerViewModel: CommonViewModel {
    
    private let disposeBag = DisposeBag()
    var jobType: Job?
    
    private var registerContactLinkInfo: RegisterContactLinkInfo
    private var registerBasicInfo: RegisterBasicInfo
    private var registerDetailInfo: RegisterDetailInfo
    private var registerDetailContentInfo: RegisterDetailContentInfo
    
    init(
        sceneCoordinator: SceneCoordinatorType,
        jobType: Job?,
        registerContactLinkInfo: RegisterContactLinkInfo,
        registerBasicInfo: RegisterBasicInfo,
        registerDetailInfo: RegisterDetailInfo,
        registerDetailContentInfo: RegisterDetailContentInfo
    ) {
        self.jobType = jobType
        self.registerContactLinkInfo = registerContactLinkInfo
        self.registerBasicInfo = registerBasicInfo
        self.registerDetailInfo = registerDetailInfo
        self.registerDetailContentInfo = registerDetailContentInfo
        super.init(sceneCoordinator: sceneCoordinator)
    }
    
    func validate(career: String?, careerDetail: String?) {
        let careerRequest = RegisterCareerInfo(career: career, careerDetail: careerDetail)
        
        profileInfoProvider.rx.request(.validateCareer(request: careerRequest))
            .mapObject(Result<EmptyData>.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(
                onNext: { owner, response in
                    if response.result?.isSuccess == true {
                        owner.moveToRegisterInterest(careerRequest)
                    } else {
                        response.message?.toast(positionType: .withButton)
                    }
                },
                onError: { error in
                    error.showToast(modelType: String.self, positionType: .withButton)
                }
            ).disposed(by: disposeBag)
    }
    
    private func moveToRegisterInterest(_ registerCareerInfo: RegisterCareerInfo) {
        let sceneCoordinator = sceneCoordinator
        let registerInterestViewModel = RegisterInterestViewModel(
            sceneCoordinator: sceneCoordinator,
            jobType: jobType,
            registerContactLinkInfo: registerContactLinkInfo,
            registerBasicInfo: registerBasicInfo,
            registerDetailInfo: registerDetailInfo,
            registerDetailContentInfo: registerDetailContentInfo,
            registerCareerInfo: registerCareerInfo
        )
        
        let scene = Scene.registerInterest(registerInterestViewModel)
        sceneCoordinator.transition(to: scene, using: .push, animated: true)
    }
}
