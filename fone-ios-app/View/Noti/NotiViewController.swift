//
//  NotiViewController.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/09/16.
//

import UIKit

class NotiViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
    }
    
    private func setNavigationBar() {
        navigationController?.hidesBarsOnSwipe = false
        navigationItem.titleView = NavigationTitleView(title: "알림")
        navigationItem.leftBarButtonItem = NavigationLeftBarButtonItem(
            type: .back,
            viewController: self
        )
    }
}
