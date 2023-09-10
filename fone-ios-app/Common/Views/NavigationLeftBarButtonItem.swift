//
//  NavigationLeftBarButtonItem.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/07.
//

import UIKit

class NavigationLeftBarButtonItem: UIBarButtonItem {
    
    override init() {
        super.init()
        
        let arrowLeftView = UIImageView().then {
            $0.image = UIImage(named: "arrow_left24")
        }
        self.customView = arrowLeftView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
