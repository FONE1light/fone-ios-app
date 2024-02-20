//
//  RegisterContactLinkInfoViewModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 2/20/24.
//

import RxCocoa

class RegisterContactLinkInfoViewModel: CommonViewModel {
    var jobType: Job?
    
    var selectedContactTypeOption = BehaviorRelay<ContactTypeOptions>(value: .kakaoOpenChat)
}

extension RegisterContactLinkInfoViewModel {
    func moveToRegisterBasicInfo() {
        let registerBasicInfoViewModel = RegisterBasicInfoViewModel(sceneCoordinator: sceneCoordinator)
        registerBasicInfoViewModel.jobType = jobType
        
        let registerScene = Scene.registerBasicInfo(registerBasicInfoViewModel)
        sceneCoordinator.transition(to: registerScene, using: .push, animated: true)
    }
}

extension RegisterContactLinkInfoViewModel {
    /// 연락방법 바텀시트 노출
    func showContactTypeBottomSheet() {
        let optionsBottomSheetViewModel = OptionsBottomSheetViewModel(
            sceneCoordinator: sceneCoordinator,
            title: "연락방법",
            selectedItem: selectedContactTypeOption.value,
            list: ContactTypeOptions.allCases
        ) { [weak self] selectedText in
            guard let self = self else { return }
            guard let option = ContactTypeOptions.getType(title: selectedText) else { return }
            self.selectedContactTypeOption.accept(option)
            self.sceneCoordinator.close(animated: true)
        }
        let scene = Scene.optionsBottomSheet(optionsBottomSheetViewModel)
        sceneCoordinator.transition(to: scene, using: .customModal, animated: true)
    }
}
