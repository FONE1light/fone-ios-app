//
//  Result.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 11/21/23.
//

import Foundation

struct Result<T: Codable>: Codable {
    var result: String?
    var message: String?
    var errorCode: String?
    var data: T?
}
