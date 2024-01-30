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
                            title: competition.title,
                            coorporation: competition.agency,
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
}
