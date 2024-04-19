//
//  FilterViewModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 12/25/23.
//

import RxSwift

struct FilterOptions {
    let genders: [GenderType]
    let age: [FilterAge]
    let categories: [Category]
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
    
    var ageMax: Int {
        calculateMaximum() ?? 200
    }
    
    var ageMin: Int {
        calculateMinimum() ?? 0
    }
    
    private func calculateMaximum() -> Int? {
        // `age`로 최댓값 계산
        let maxes = age.map { $0.ageMax }
        return maxes.max()
    }
    
    private func calculateMinimum() -> Int? {
        // `age`로 최솟값 계산
        let mins = age.map { $0.ageMin }
        return mins.min()
    }
}

final class FilterViewModel: CommonViewModel {
    
    private let filterOptionsSubject: BehaviorSubject<FilterOptions?>

    init(sceneCoordinator: SceneCoordinatorType, filterOptionsSubject: BehaviorSubject<FilterOptions?>) {
        self.filterOptionsSubject = filterOptionsSubject
        
        super.init(sceneCoordinator: sceneCoordinator)
    }
    
    func applyFilter(_ filterOptions: FilterOptions) {
        self.filterOptionsSubject.onNext(filterOptions)
    }
    
}
