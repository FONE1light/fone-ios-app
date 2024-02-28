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
    
    func validate(career: String?, careerDetail: String?) {
        let careerRequest = CareerRequest(career: career, careerDetail: careerDetail)
        
        profileInfoProvider.rx.request(.validateCareer(request: careerRequest))
            .mapObject(Result<EmptyData>.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(
                onNext: { owner, response in
                    if response.result?.isSuccess == true {
                        owner.moveToRegisterInterest()
                    } else {
                        response.message?.toast(positionType: .withButton)
                    }
                },
                onError: { error in
                    error.showToast(modelType: String.self, positionType: .withButton)
                }
            ).disposed(by: disposeBag)
    }
    
    private func moveToRegisterInterest() {
        let sceneCoordinator = sceneCoordinator
        let registerInterestViewModel = RegisterInterestViewModel(sceneCoordinator: sceneCoordinator)
        registerInterestViewModel.jobType = jobType
        
        let scene = Scene.registerInterest(registerInterestViewModel)
        sceneCoordinator.transition(to: scene, using: .push, animated: true)
    }
}
