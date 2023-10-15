//
//  UIViewController+Extension.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/10/14.
//

import UIKit

extension UIViewController {
    /// ViewController 말고 view로만 만드는 BottomSheet
    func presentPanModal(view: UIView) {
        view.layoutIfNeeded()
        let vc = BottomSheetViewController(view: view)
        presentPanModal(vc)
    }
}
