//
//  SceneCoordinatorType.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/08/07.
//

import Foundation

protocol SceneCoordinatorType {
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool)
    func close(animated: Bool)
}
