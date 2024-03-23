//
//  VersionChecker.swift
//  fone-ios-app
//
//  Created by 여나경 on 3/23/24.
//

import UIKit
import FirebaseRemoteConfig

final class VersionChecker {
    static let shared = VersionChecker()
    
    private let remoteConfig = RemoteConfig.remoteConfig()
    private var sceneCoordinator: SceneCoordinatorType?
    
    func initialize(sceneCoordinator: SceneCoordinatorType, completionHandler: @escaping ((Bool) -> Void)) {
        self.sceneCoordinator = sceneCoordinator
        
        let settings = RemoteConfigSettings()
        // TODO: minimumFetchInterval 개발/운영 분기
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        fetchVersion(completionHandler)
    }
    
    private func fetchVersion(_ completionHandler: @escaping ((Bool) -> Void)) {
        remoteConfig.fetch { (status, error) -> Void in
            guard status == .success else {
                print("Config not fetched. Error: \(error?.localizedDescription ?? "No error available.")")
                return
            }
            
            print("Config fetched!")
            self.remoteConfig.activate { changed, error in
                
                if let fbVersion = self.remoteConfig["iOSrequiredVersionName"].stringValue {
                    print("💥fbVersion: \(fbVersion)")
                    let appVersion = Bundle.appVersion
                    print("💥appVersion: \(appVersion)")
                    let versionCompareResult = fbVersion.compare(appVersion, options: .numeric)
                    if versionCompareResult == .orderedDescending {
                        // TODO: Navigate to AppStore
                        print("💥fbVersion > appVersion! Navigate to AppStore")
                        (completionHandler)(false)
                        return
                    }
                }
                
                if let fbBuild = self.remoteConfig["iOSrequiredVersionCode"].stringValue {
                    print("💥fbBuild: \(fbBuild)")
                    let appBuild = Bundle.appBuild
                    print("💥appBuild: \(appBuild)")
                    let buildCompareResult = fbBuild.compare(appBuild, options: .numeric)
                    if buildCompareResult == .orderedDescending {
                        // TODO: Navigate to AppStore
                        print("💥fbBuild > appBuild! Navigate to AppStore")
                        completionHandler(false)
                        return
                    }
                }
                completionHandler(true)
            }
        }
    }
}
