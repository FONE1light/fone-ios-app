//
//  TabBarViewController.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/09/11.
//

import UIKit
enum Tabs: String, CaseIterable {
    case home = "홈"
    //    case job = "구인구직"
    case chat = "채팅"
    //    case mypage = "마이페이지"
    
    var nav: UINavigationController {
        switch self {
        case .home:
            return UINavigationController(rootViewController: HomeViewController())
        case .chat:
            return UINavigationController(rootViewController: ChatViewController())
        }
    }
    
    var image: UIImage {
        switch self {
        case .home:
            return UIImage(named: "home_selected") ?? UIImage()
        case .chat:
            return UIImage(named: "chat_unselected") ?? UIImage()
        }
    }
    
    var selectedImage: UIImage {
        switch self {
        case .home:
            return UIImage(named: "home_selected") ?? UIImage()
        case .chat:
            return UIImage(named: "chat_selected") ?? UIImage()
        }
    }
}

class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabBarAppearance()

        var tabs: [UINavigationController] = []
        
        for tab in Tabs.allCases {
            let nav = tab.nav
            nav.tabBarItem.title = tab.rawValue
            nav.tabBarItem.image = tab.image
            nav.tabBarItem.selectedImage = tab.selectedImage
            tabs.append(nav)
        }
        
        setViewControllers(tabs, animated: false)
    }
    
    private func setTabBarAppearance() {
        if #available(iOS 15, *) {
            let appearance = UITabBarAppearance()
            let tabBar = UITabBar()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white_FFFFFF
            tabBar.standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        
        tabBar.isTranslucent = false
        tabBar.tintColor = UIColor.red_CE0B39
        tabBar.unselectedItemTintColor = UIColor.gray_9E9E9E
    }
}
