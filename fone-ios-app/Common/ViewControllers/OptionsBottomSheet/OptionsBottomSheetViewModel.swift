//
//  OptionsBottomSheetViewModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 2/20/24.
//

import RxCocoa

class OptionsBottomSheetViewModel: CommonViewModel {
    let title: String?
    let selectedItem: Options
    let list: [Options]
    let completionHandler: ((String) -> Void)?
    
    init(
        sceneCoordinator: SceneCoordinatorType,
        title: String?,
        selectedItem: Options,
        list: [Options],
        completionHandler: ((String) -> Void)? = nil
    ) {
        self.title = title
        self.selectedItem = selectedItem
        self.list = list
        self.completionHandler = { selectedText in
            completionHandler?(selectedText)
        }
        
        super.init(sceneCoordinator: sceneCoordinator)
    }
}
