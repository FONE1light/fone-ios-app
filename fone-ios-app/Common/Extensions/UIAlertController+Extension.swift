//
//  UIAlertController+Extension.swift
//  fone-ios-app
//
//  Created by 여나경 on 10/24/23.
//

import UIKit

extension UIAlertController {
    // 필요에 따라 parameter 추가. (e.g. 버튼의 label(font) custom 필요 시)
    // - 디자인 측에 top, bottom 여백 통일 가능한지 확인 필요할 수도 있음
    /// cancel 버튼 하나 있는 Alert 팝업
    class func createOneButtonPopup(
        title: String?,
        buttonText: String? = "확인",
        buttonHandler: ((UIAlertAction) -> Void)? = nil
    ) -> UIAlertController {
        let alert = UIAlertController(
            title: title,
            message: nil,
            preferredStyle: .alert
        ).then {
            $0.view.tintColor = .gray_555555
        }
        
        alert.setValue(
            NSAttributedString(
                string: alert.title!,
                attributes: [
                    NSAttributedString.Key.font : UIFont.font_r(16),
                    NSAttributedString.Key.foregroundColor : UIColor.gray_161616]
            ), forKey: "attributedTitle"
        )
        
        let cancel = UIAlertAction(
            title: buttonText,
            style: .default,
            handler: buttonHandler
        )
        alert.addAction(cancel)
        
        return alert
    }
}
