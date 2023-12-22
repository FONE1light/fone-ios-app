//
//  JobHuntingProfilesViewModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 12/12/23.
//

import Foundation

class JobHuntingProfilesViewModel: CommonViewModel {
    
    var name: String?
    var imageUrls: [String]?
    
    func showProfilePreviewBottomSheet(of index: Int) {
        guard let imageUrl = imageUrls?[index] else { return }
        let profileViewModel = ProfilePreviewViewModel(sceneCoordinator: sceneCoordinator, imageUrl: imageUrl)
        sceneCoordinator.transition(to: .profilePreview(profileViewModel), using: .fullScreenModal, animated: true)
    }
}
