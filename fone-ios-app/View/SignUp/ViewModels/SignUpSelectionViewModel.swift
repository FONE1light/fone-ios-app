//
//  SignUpSelectionViewModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 10/20/23.
//

import Foundation

class SignUpSelectionViewModel: CommonViewModel {
    // 현재 화면에서 사용하는 값
    var job: Job?
    var interests: [Category]?
    
    // 이전 화면에서 넘어온 데이터
    var signInInfo: EmailSignInInfo?
    var socialSingUpInfo: (accessToken: String, loginType: String, email: String)? // FIXME: 회원가입에서 사용하기 좋은 형태로 구조 변경
}

extension SignUpSelectionViewModel {
    func moveToSignUpPersonalInfo() {
        let sceneCoordinator = sceneCoordinator
        let personalInfoViewModel = SignUpPersonalInfoViewModel(sceneCoordinator: sceneCoordinator)
        let job = job?.serverName
        let interests = interests?.map { $0.serverName }
        personalInfoViewModel.signInInfo = signInInfo
        personalInfoViewModel.signUpSelectionInfo = SignUpSelectionInfo(
            job: job,
            interests: interests
        )
        let signUpScene = Scene.signUpPersonalInfo(personalInfoViewModel)
        sceneCoordinator.transition(to: signUpScene, using: .push, animated: true)
    }
}
