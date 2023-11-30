//
//  RegisterDetailInfoStaffViewModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/28/23.
//

import UIKit
import RxRelay

class RegisterDetailInfoStaffViewModel: CommonViewModel {
    
    var instagramLink = BehaviorRelay<String?>(value: nil)
    var youtubeLink = BehaviorRelay<String?>(value: nil)
}
