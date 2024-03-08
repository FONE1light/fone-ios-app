//
//  MyPageViewModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/17.
//

import RxSwift

class MyPageViewModel: CommonViewModel {
    
    let userInfo = PublishSubject<User?>()
    
    private let disposeBag = DisposeBag()
    
    func fetchMyPage() {
        userInfoProvider.rx.request(.fetchMyPage)
            .mapObject(Result<UserInfoModel>.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(
                onNext: { owner, response in
                    if response.result?.isSuccess == true {
                        owner.userInfo.onNext(response.data?.user)
                    } else {
                        response.message?.toast()
                    }
                },
            onError: { error in
                error.showToast(modelType: String.self)
                
            }).disposed(by: disposeBag)
    }
}
