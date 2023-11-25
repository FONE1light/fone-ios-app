//
//  HomeViewModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/09/11.
//

import Foundation
import RxSwift
import Moya

class HomeViewModel: CommonViewModel {
    var disposeBag = DisposeBag()
    var homeInfoDataSubject = BehaviorSubject<HomeInfoData?>(value: nil)
    
    override init(sceneCoordinator: SceneCoordinatorType) {
        super.init(sceneCoordinator: sceneCoordinator)
        
        fetchHome()
    }
    
    func fetchHome(isRetry: Bool = false) {
        homeInfoProvider.rx.request(.fetchHome)
            .mapObject(HomeInfo.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                self.homeInfoDataSubject.onNext(response.data)
            }, onError: { error in
                print("\(error)")
            }).disposed(by: disposeBag)
    }
}
