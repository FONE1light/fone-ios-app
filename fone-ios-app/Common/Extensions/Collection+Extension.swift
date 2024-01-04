//
//  Collection+Extension.swift
//  fone-ios-app
//
//  Created by 여나경 on 1/3/24.
//

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
