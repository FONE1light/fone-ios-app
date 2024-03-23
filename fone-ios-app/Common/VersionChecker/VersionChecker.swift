//
//  VersionChecker.swift
//  fone-ios-app
//
//  Created by 여나경 on 3/23/24.
//

import FirebaseRemoteConfig
import FirebaseRemoteConfigSwift

final class VersionChecker {
    static let shared = VersionChecker()
    
    private let remoteConfig = RemoteConfig.remoteConfig()
    
    func initialize() {
        let settings = RemoteConfigSettings()
        // TODO: minimumFetchInterval 개발/운영 분기
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        fetch()
        addListener()
    }
    
    private func fetch() {
        remoteConfig.fetch { (status, error) -> Void in
            if status == .success {
                print("Config fetched!")
                self.remoteConfig.activate { changed, error in
                    print(changed, error)
                    let requiredVersionCode = self.remoteConfig["requiredVersionCode"].stringValue
                    print("requiredVersionCode=", requiredVersionCode)
                    
                    let requiredVersionName = self.remoteConfig["requiredVersionName"].stringValue
                    print("requiredVersionName=", requiredVersionName)
                    
                    let versionTest = self.remoteConfig["versionTest"].stringValue
                    print("versionTest=", versionTest)
                }
            } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
            print("YAY SUCCEEDED1")
        }
    }
    
    private func addListener() {
        remoteConfig.addOnConfigUpdateListener { configUpdate, error in
            guard let configUpdate, error == nil else {
                print("Error listening for config updates: \(error)")
                return
            }
            
//            let updatedKeys = configUpdate.updatedKeys
//            print("Updated keys: \(configUpdate.updatedKeys)")
            
            self.remoteConfig.activate { changed, error in
                guard error == nil else { return print(error) }
                
                let updatedKeys = configUpdate.updatedKeys
                updatedKeys.forEach { print("💥\($0)=", self.remoteConfig[$0].stringValue) }
                
            }
        }
    }
}
