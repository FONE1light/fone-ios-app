//
//  CompetitionViewModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/26.
//

import UIKit
import RxSwift
import RxCocoa

class CompetitionViewModel: CommonViewModel {
    
    private var disposeBag = DisposeBag()
    var competitionScraps = PublishRelay<[CompetitionScrap]?>()
    
    override init(sceneCoordinator: SceneCoordinatorType) {
        super.init(sceneCoordinator: sceneCoordinator)
        
        fetchCompetitionScraps()
    }
    
    private func fetchCompetitionScraps() {
        competitionInfoProvider.rx.request(.scraps)
            .mapObject(Result<CompetitionsData>.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(
                onNext: { owner, response in
                    let competitionsContent = response.data?.competitions?.content
                    let competitions = competitionsContent?.map { competition in
                        return CompetitionScrap(
                            id: competition.id,
                            title: competition.title,
                            coorporation: competition.agency,
                            isScrap: competition.isScrap,
                            leftDays: competition.screeningDDay,
                            viewCount: competition.viewCount
                        )
                    }
                    
                    owner.competitionScraps.accept(competitions)
                },
                onError: { error in
                    error.showToast(modelType: CompetitionsData.self)
                }).disposed(by: disposeBag)
    }
    
    func toggleScrap(id: Int?) {
        guard let id = id else { return }
        competitionInfoProvider.rx.request(.scrapCompetition(competitionId: id))
            .mapObject(Result<CompetitionContent>.self) // 빈 json
            .asObservable()
            .withUnretained(self)
            .subscribe (
                onNext: { owner, response in
                    if response.result?.isSuccess != true {
                        "스크랩을 실패했습니다.".toast()
                    }
                },
                onError: { error in
                    error.showToast(modelType: CompetitionContent.self)
                }).disposed(by: disposeBag)
    }
}

extension CompetitionViewModel {
    /// 공모전 상세로 이동
    func moveToCompetitionDetail(id: Int) {
        // TODO: 구현
        print("id=\(id)인 공모전 상세로 이동")
    }
}
