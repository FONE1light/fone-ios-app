//
//  MyPageViewModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/17.
//

import RxSwift
import RxRelay

class MyPageViewModel: CommonViewModel {
    
    let userInfo = BehaviorRelay<User?>(value: nil)
    
    private let disposeBag = DisposeBag()
    
    func fetchMyPage() {
        userInfoProvider.rx.request(.fetchMyPage)
            .mapObject(Result<UserInfoModel>.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(
                onNext: { owner, response in
                    if response.result?.isSuccess == true {
                        owner.userInfo.accept(response.data?.user)
                    } else {
                        response.message?.toast()
                    }
                },
            onError: { error in
                error.showToast(modelType: String.self)
                
            }).disposed(by: disposeBag)
    }
    
    func logout() {
        let loginType = SocialLoginType.getType(string: userInfo.value?.loginType)
        let logoutBottomSheetViewModel = LogoutBottomSheetViewModel(sceneCoordinator: sceneCoordinator, loginType: loginType)
        let scene = Scene.logoutBottomSheet(logoutBottomSheetViewModel)
        sceneCoordinator.transition(to: scene, using: .customModal, animated: true)
    }
    
    func signout() {
        let loginType = SocialLoginType.getType(string: userInfo.value?.loginType)
            let signoutBottomSheetViewModel = SignoutBottomSheetViewModel(sceneCoordinator: sceneCoordinator, loginType: loginType)
        let scene = Scene.signoutBottomSheet(signoutBottomSheetViewModel)
        sceneCoordinator.transition(to: scene, using: .customModal, animated: true)
    }
}
