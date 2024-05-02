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
    
    class func createTwoButtonPopup(
        title: String?,
        leftButtonText: String?,
        rightButtonText: String?,
        leftButtonHandler: ((UIAlertAction) -> Void)? = nil,
        rightButtonHandler: ((UIAlertAction) -> Void)? = nil
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
        
        let leftAction = UIAlertAction(
            title: leftButtonText,
            style: .default,
            handler: leftButtonHandler
        )
        alert.addAction(leftAction)
        
        leftAction.setValue(UIColor.gray_555555, forKey: "titleTextColor") // 색상 적용
        
        let rightAction = UIAlertAction(
            title: rightButtonText,
            style: .destructive, // TODO: 어차피 색 바꾸므로 Default로 설정해도 동일할 것
            handler: rightButtonHandler)
        alert.addAction(rightAction)
        
        rightAction.setValue(UIColor.red_CE0B39, forKey: "titleTextColor") // 색상 적용
        
        return alert
    }
    
    /// 버튼 2개 모두 검정색 텍스트인 팝업 노출
    class func createTwoBlackButtonPopup(
        title: String?,
        cancelButtonText: String?,
        continueButtonText: String?,
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
        
        let back = UIAlertAction(
            title: cancelButtonText,
            style: .default, // 우측 버튼 텍스트와 같은 굵기로(=bold 처리 X) 나타나도록 .cancel 대신 .default 설정
            handler: nil
        )
        alert.addAction(back)
        
        back.setValue(UIColor.gray_555555, forKey: "titleTextColor") // 색상 적용
        
        let continueAction = UIAlertAction(
            title: continueButtonText,
            style: .default, // bold 처리 X 위해
            handler: buttonHandler
        )
        alert.addAction(continueAction)
        
        continueAction.setValue(UIColor.gray_555555, forKey: "titleTextColor") // 색상 적용
        
        return alert
    }
}
