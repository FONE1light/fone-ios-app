//
//  UIViewController+Extension.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/10/14.
//

import UIKit

extension UIViewController {
    /// ViewController 말고 view로만 만드는 BottomSheet
    /// - Dimmed View 눌러서 닫은 후 다시 노출되지 않는다면 sceneCoordinator 파라미터 넘길 것
    func presentPanModal(view: UIView, sceneCoordinator: SceneCoordinatorType? = nil) {
        view.layoutIfNeeded()
        let vc = BottomSheetViewController(view: view, sceneCoordinator: sceneCoordinator)
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
        if viewControllers.first is HomeViewController { return true }
        return viewControllers.count > 1
    }
}

extension UIViewController {
    /// Height of status bar + navigation bar (if navigation bar exist)
    var topbarHeight: CGFloat {
        return (UIView.notchTop) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
}
