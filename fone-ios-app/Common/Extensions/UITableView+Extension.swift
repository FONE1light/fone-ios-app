//
//  UITableView+Extension.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/10.
//

import UIKit

extension UITableView {
    /// XIB로 만든 셀 register
    func register<T: UITableViewCell>(_ className: T.Type) {
        let cellName = String(describing: T.self)
        let nib = UINib(nibName: cellName, bundle: nil)
        register(nib, forCellReuseIdentifier: String(describing: cellName))
    }

    /// 코드로 만든 셀 register
    func register<T: UITableViewCell>(with className: T.Type) {
        self.register(T.self, forCellReuseIdentifier: String(describing: T.self))
    }
}

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as? T else {
            fatalError("Couldn't find UITableViewCell for \(String(describing: T.self))")
        }
        return cell
    }
}
