//
//  SignUpSuccessViewModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 10/20/23.
//

import Foundation
import RxSwift

class SignUpSuccessViewModel: CommonViewModel {
    var disposeBag = DisposeBag()
    
    // 이전 화면에서 넘어온 데이터
    var signInInfo: SignInInfo?
    
    func signIn() {
        guard let emailSignInInfo = signInInfo?.emailSignInInfo else { return }
        userInfoProvider.rx.request(.emailSignIn(emailSignInInfo: emailSignInInfo))
            .mapObject(EmailSignInResponseModel.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                if response.result == "SUCCESS" {
                    owner.moveToHome()
                } else {
                    response.message.toast(positionType: .withButton)
                }
            }, onError: { error in
                print(error.localizedDescription)
                "\(error)".toast(positionType: .withButton)
            }).disposed(by: disposeBag)
        
    }
    
    private func moveToHome() {
        // TODO: Home 진입 시 필요한 토큰 등 데이터 채우기
        guard let coordinator = self.sceneCoordinator as? SceneCoordinator else { return }
        
        let homeScene = Scene.home(coordinator)
        coordinator.transition(to: homeScene, using: .root, animated: true)
    }
}
