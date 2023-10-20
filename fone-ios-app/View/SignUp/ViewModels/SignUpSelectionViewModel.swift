//
//  SignUpSelectionViewModel.swift
//  fone-ios-app
//
//  Created by 여나경 on 10/20/23.
//

import Foundation

class SignUpSelectionViewModel: CommonViewModel {
    // 현재 화면에서 사용하는 값
    var job: Job?
    var interests: [Category]?
    
    // 이전 화면에서 넘어온 데이터
    var signInInfo: EmailSignInInfo?
}
