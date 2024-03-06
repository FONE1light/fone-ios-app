//
//  RegionsBottomSheetViewModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 3/6/24.
//

import Foundation

final class RegionsBottomSheetViewModel: CommonViewModel {
    let selectedItem: String
    let list: [String]
    let completionHandler: ((String) -> Void)?
    
    init(
        sceneCoordinator: SceneCoordinatorType,
        selectedItem: String,
        list: [String],
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
