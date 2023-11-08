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
    
    func hideKeyboardWhenTapped() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 0
    }
}
