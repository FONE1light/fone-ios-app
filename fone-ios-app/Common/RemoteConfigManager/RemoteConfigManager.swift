//
//  RemoteConfigManager.swift
//  fone-ios-app
//
//  Created by 여나경 on 3/23/24.
//

import UIKit
import FirebaseRemoteConfig

final class RemoteConfigManager {
    static let shared = RemoteConfigManager()
    
    var isAppleReviewInProcess: Bool?
    private let remoteConfig = RemoteConfig.remoteConfig()
    private var sceneCoordinator: SceneCoordinatorType?
    
    func initialize(sceneCoordinator: SceneCoordinatorType, completionHandler: @escaping ((Bool) -> Void)) {
        self.sceneCoordinator = sceneCoordinator
        
        let settings = RemoteConfigSettings()
#if DEBUG
        settings.minimumFetchInterval = 0
#else
        settings.minimumFetchInterval = 3600
#endif
        remoteConfig.configSettings = settings
        
        fetch(completionHandler)
        
    }
    
    private func fetch(_ completionHandler: @escaping ((Bool) -> Void)) {
        remoteConfig.fetch { (status, error) -> Void in
            guard status == .success else {
                print("Config not fetched. Error: \(error?.localizedDescription ?? "No error available.")")
                return
            }
            
            print("Config fetched!")
            self.remoteConfig.activate { _, _ in
                self.fetchIsAppleReviewInProcess()
                self.fetchVersion(completionHandler)
            }
        }
    }
    
    private func fetchIsAppleReviewInProcess() {
        self.isAppleReviewInProcess = self.remoteConfig["isAppleReviewInProcess"].boolValue
    }
    
    private func fetchVersion(_ completionHandler: @escaping ((Bool) -> Void)) {
        if let fbVersion = self.remoteConfig["iOSrequiredVersionName"].stringValue {
            let appVersion = Bundle.appVersion
            let versionCompareResult = fbVersion.compare(appVersion, options: .numeric)
            if versionCompareResult == .orderedDescending {
                print("💥fbVersion > appVersion!")
                (completionHandler)(false)
                return
            }
        }
        
        if let fbBuild = self.remoteConfig["iOSrequiredVersionCode"].stringValue {
            let appBuild = Bundle.appBuild
            let buildCompareResult = fbBuild.compare(appBuild, options: .numeric)
            if buildCompareResult == .orderedDescending {
                print("💥fbBuild > appBuild!")
                completionHandler(false)
                return
            }
        }
        completionHandler(true)
    }
    
}
