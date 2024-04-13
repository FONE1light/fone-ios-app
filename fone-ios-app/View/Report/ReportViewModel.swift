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
    var inconveniences: [Int] = []
    var reportType: JobSegmentType = .profile
    
    init(sceneCoordinator: SceneCoordinatorType, profileImageURL: String?, nickname: String?, userJob: String?, from: JobSegmentType?, typeId: Int?) {
        self.profileImageURL = profileImageURL
        self.nickname = nickname
        self.userJob = userJob
        self.from = from
        self.typeId = typeId
        
        super.init(sceneCoordinator: sceneCoordinator)
    }
    
    func getInconvenienceString(tag: Int) -> String {
        switch tag {
        case 1, 12: return "권리침해 및 명의 도용 · 사칭을 해요."
        case 2, 13: return "폭력적 위협 또는 홍보를 해요."
        case 3: return "불법 또는 규제 상품을 판매해요."
        case 4, 15: return "보호집단에 대한 혐오 발언을 해요."
        case 5, 16: return "나체 이미지 또는 음란물을 올려요."
        case 6, 17: return "스팸 및 사기."
        case 7, 18: return "기타"
        case 11: return "게시글의 정보가 너무 부족해요."
        case 14: return "거짓된 정보를 게시했어요."
        default: return ""
        }
    }
    
    func submitReport(details: String?, type: String?) {
        let inconveniences = self.inconveniences.map { getInconvenienceString(tag: $0)
        }
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
