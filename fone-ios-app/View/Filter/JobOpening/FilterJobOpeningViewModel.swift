//
//  FilterJobOpeningViewModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 12/25/23.
//

import RxSwift

struct FilterOptions {
    let genders: [GenderType]
    let ages: [FilterAge]
    let categories: [Category]
    var domains: [Domain]? = nil
}

extension FilterOptions {
    var stringGenders: String? {
        let serverNameGenders = genders.compactMap { $0.serverName }
        return serverNameGenders.commaInserted
    }
    
    var stringCategories: String? {
        let serverNameCategories = categories.compactMap { $0.serverName }
        return serverNameCategories.commaInserted
    }
    
    var stringDomains: String? {
        let serverNameDomains = domains?.compactMap { $0.serverName }
        return serverNameDomains?.commaInserted
    }
    
    var ageMax: Int {
        calculateMaximum() ?? 200
    }
    
    var ageMin: Int {
        calculateMinimum() ?? 0
    }
    
    private func calculateMaximum() -> Int? {
        // `ages`로 최댓값 계산
        let maxes = ages.map { $0.ageMax }
        return maxes.max()
    }
    
    private func calculateMinimum() -> Int? {
        // `ages`로 최솟값 계산
        let mins = ages.map { $0.ageMin }
        return mins.min()
    }
}

final class FilterJobOpeningViewModel: CommonViewModel {
    
    let filterOptionsSubject: BehaviorSubject<FilterOptions?>

    init(sceneCoordinator: SceneCoordinatorType, filterOptionsSubject: BehaviorSubject<FilterOptions?>) {
        self.filterOptionsSubject = filterOptionsSubject
        
        super.init(sceneCoordinator: sceneCoordinator)
    }
    
    func applyFilter(_ filterOptions: FilterOptions) {
        self.filterOptionsSubject.onNext(filterOptions)
    }
    
}
