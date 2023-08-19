//
//  Response+Codable.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/08/17.
//

import Foundation
import Moya

public extension Response {
    
    func mapObject<T: Codable>(_ type: T.Type, path: String? = nil) throws -> T {
        
        do {
            return try JSONDecoder().decode(T.self, from: try getJsonData(path))
        } catch {
            throw MoyaError.jsonMapping(self)
        }
    }
    
    func mapArray<T: Codable>(_ type: T.Type, path: String? = nil) throws -> [T] {

        do {
            return try JSONDecoder().decode([T].self, from: try getJsonData(path))
        } catch {
            throw MoyaError.jsonMapping(self)
        }
    }
    
    private func getJsonData(_ path: String? = nil) throws -> Data {

        do {
            var jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            if let path = path {

                guard let specificObject = jsonObject.value(forKeyPath: path) else {
                    throw MoyaError.jsonMapping(self)
                }
                jsonObject = specificObject as AnyObject
            }

            return try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
        } catch {
            throw MoyaError.jsonMapping(self)
        }
    }
}
