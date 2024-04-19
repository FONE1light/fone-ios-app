//
//  FilterProfileViewModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 4/19/24.
//

import RxSwift

final class FilterProfileViewModel: CommonViewModel {
    
    let filterOptionsSubject: BehaviorSubject<FilterOptions?>

    init(sceneCoordinator: SceneCoordinatorType, filterOptionsSubject: BehaviorSubject<FilterOptions?>) {
        self.filterOptionsSubject = filterOptionsSubject
        
        super.init(sceneCoordinator: sceneCoordinator)
    }
    
    func applyFilter(_ filterOptions: FilterOptions) {
        self.filterOptionsSubject.onNext(filterOptions)
    }
}
