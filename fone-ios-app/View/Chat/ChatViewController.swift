//
//  ChatViewController.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/09/11.
//

import UIKit

class ChatViewController: UIViewController, ViewModelBindableType {
    var viewModel: ChatViewModel!
    var hasViewModel = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
    }
    
    func bindViewModel() {
        
    }
    
    private func setNavigationBar() {
        
        self.navigationItem.leftBarButtonItem = NavigationLeftBarButtonItem(type: .chat)
        self.navigationItem.rightBarButtonItem = NavigationRightBarButtonItem(type: .notification, viewController: self)
    }
}
