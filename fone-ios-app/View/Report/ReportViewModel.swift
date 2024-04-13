//
//  ReportViewModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 4/8/24.
//

import Foundation
import RxSwift

final class ReportViewModel: CommonViewModel {
    private let disposeBag = DisposeBag()
    
    let profileImageURL: String?
    let nickname: String?
    let userJob: String?
    let from: JobSegmentType?
    let typeId: Int?
    
    var keyboardHeightBehaviorSubject = BehaviorSubject<CGFloat>(value: 0)
    
    init(sceneCoordinator: SceneCoordinatorType, profileImageURL: String?, nickname: String?, userJob: String?, from: JobSegmentType?, typeId: Int?) {
        self.profileImageURL = profileImageURL
        self.nickname = nickname
        self.userJob = userJob
        self.from = from
        self.typeId = typeId
        
        super.init(sceneCoordinator: sceneCoordinator)
    }
    
    func submitReport(details: String?, inconveniences: [String]?, type: String?) {
        let reportInfo = ReportInfo(details: details, inconveniences: inconveniences, type: type, typeId: typeId)
        reportInfoProvider.rx.request(.reports(reportInfo: reportInfo))
            .mapObject(Result<EmptyData>.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                if response.result?.isSuccess == true {
                    "제출이 완료되었습니다.".toast(positionType: .withButton)
                } else {
                    "제출에 실패하였습니다. 다시 시도해주세요.".toast(positionType: .withButton)
                }
            }, onError: { error in
                error.showToast(modelType: String.self, positionType: .withButton)
            }).disposed(by: disposeBag)
    }
}
