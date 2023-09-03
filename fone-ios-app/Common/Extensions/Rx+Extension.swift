//
//  Rx+Extension.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/09/03.
//

import UIKit
import RxSwift

func keyboardHeight() -> Observable<CGFloat> {
    let willShowObservable = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
        .map { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0}
    let willHideObservable = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
        .map { _ in CGFloat(0)}
    return Observable
        .from([willShowObservable, willHideObservable])
        .merge()
}
