//
//  RecruitContactLinkInfoViewModel.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2/9/24.
//

import Foundation
import RxSwift
import RxRelay

struct RecruitContactLinkInfo: Codable {
    let contact: String?
    let contactMethod: String?
}

final class RecruitContactLinkInfoViewModel: CommonViewModel {
    let disposeBag = DisposeBag()
    var jobType: Job?
    var selectedContactTypeOption = PublishRelay<ContactTypeOptions>()
    var contactType: ContactTypeOptions?
    
    /// 연락방법 바텀시트 노출
    func showContactTypeBottomSheet() {
        let optionsBottomSheetViewModel = OptionsBottomSheetViewModel(
            sceneCoordinator: sceneCoordinator,
            title: "연락방법",
            selectedItem: contactType ?? .kakaoOpenChat,
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
    
    func validateContactLink(recruitContactLinkInfo: RecruitContactLinkInfo) {
        validationProvider.rx.request(.validateContactLink(recruitContactLinkInfo: recruitContactLinkInfo))
            .mapObject(Result<String>.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(
                onNext: { owner, response in
                    if response.result?.isSuccess == true {
                        owner.moveToNextStep(recruitContactLinkInfo: recruitContactLinkInfo)
                    } else {
                        response.message?.toast(positionType: .withButton)
                    }
                },
                onError: { error in
                    error.showToast(modelType: String.self, positionType: .withButton)
                }
            ).disposed(by: disposeBag)
    }
    
    func moveToNextStep(recruitContactLinkInfo: RecruitContactLinkInfo) {
        let recruitBasicInfoViewModel = RecruitBasicInfoViewModel(sceneCoordinator: sceneCoordinator, jobType: jobType, recruitContactLinkInfo: recruitContactLinkInfo)
        let recruitBasicInfoScene = Scene.recruitBasicInfo(recruitBasicInfoViewModel)
        sceneCoordinator.transition(to: recruitBasicInfoScene, using: .push, animated: true)
    }
}
