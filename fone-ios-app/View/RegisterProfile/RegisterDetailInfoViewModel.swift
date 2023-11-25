//
//  RegisterDetailInfoViewModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/19/23.
//

import UIKit
import RxRelay

class RegisterDetailInfoViewModel: CommonViewModel {
    
    var instagramLink = BehaviorRelay<String?>(value: nil)
    var youtubeLink = BehaviorRelay<String?>(value: nil)
}
