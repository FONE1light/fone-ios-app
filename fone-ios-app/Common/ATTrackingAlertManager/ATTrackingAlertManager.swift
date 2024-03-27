//
//  ATTrackingAlertManager.swift
//  fone-ios-app
//
//  Created by 여나경 on 3/27/24.
//

import AppTrackingTransparency

final class ATTrackingAlertManager {
    
    static var shared = ATTrackingAlertManager()
    func initialize() {
            ATTrackingManager.requestTrackingAuthorization { (status) in
                print(status)
                //            switch status {
                //            case .authorized:
                //            case .denied:
                //            case .notDetermined:
                //            case .restricted
                //            }
            }
    }
}
