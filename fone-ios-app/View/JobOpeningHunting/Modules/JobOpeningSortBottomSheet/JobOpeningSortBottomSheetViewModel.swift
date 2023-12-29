//
//  JobOpeningSortBottomSheetViewModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 12/25/23.
//

import RxCocoa

class JobOpeningSortBottomSheetViewModel: CommonViewModel {
    
    let selectedItem: JobOpeningSortOptions
    let list: [JobOpeningSortOptions]
    let completionHandler: ((String) -> Void)?
    
    init(
        sceneCoordinator: SceneCoordinatorType,
        selectedItem: JobOpeningSortOptions,
        list: [JobOpeningSortOptions],
        completionHandler: ((String) -> Void)? = nil
    ) {
        self.selectedItem = selectedItem
        self.list = list
        self.completionHandler = { selectedText in
            completionHandler?(selectedText)
        }
        
        super.init(sceneCoordinator: sceneCoordinator)
    }
}
