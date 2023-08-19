//
//  Single+Codable.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/08/17.
//

import Foundation
import RxSwift
import Moya

public extension PrimitiveSequence where Trait == SingleTrait, Element == Response {

    func mapObject<T: Codable>(_ type: T.Type, path: String? = nil) -> Single<T> {
        return flatMap { response -> Single<T> in
            return Single.just(try response.mapObject(type, path: path))
        }
    }

    func mapArray<T: Codable>(_ type: T.Type, path: String? = nil) -> Single<[T]> {
        return flatMap { response -> Single<[T]> in
            return Single.just(try response.mapArray(type, path: path))
        }
    }
}
