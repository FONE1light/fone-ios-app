//
//  Reusable.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/09/10.
//

import Foundation
import UIKit

protocol Reusable: AnyObject {
    static var identifier: String { get }
    static var nib: UINib { get }
    static var nibName: String { get }
}

extension Reusable {
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    static var nibName: String {
        guard let name = String(describing: self).components(separatedBy: ".").last else {
            return ""
        }
        
        return name
    }
}

extension UICollectionView {
    func register<T: UICollectionViewCell>(_: T.Type) {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellWithReuseIdentifier: T.identifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.identifier)")
        }
        return cell
    }
}

extension UICollectionViewCell: Reusable { }
