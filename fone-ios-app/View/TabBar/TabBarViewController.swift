//
//  TabBarViewController.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/09/11.
//

import UIKit
enum Tabs: Int, CaseIterable {
    case home = 0
    case job
    case chat
    case myPage
    
    var nav: UINavigationController {
        switch self {
        case .home:
            return UINavigationController(rootViewController: HomeViewController())
        case .job:
            return UINavigationController(rootViewController: JobOpeningHuntingViewController())
        case .chat:
            return UINavigationController(rootViewController: ChatViewController())
        case .myPage:
            return UINavigationController(rootViewController: MyPageViewController())
        }
    }
    
    var image: UIImage {
        switch self {
        case .home:
            return UIImage(named: "home_unselected") ?? UIImage()
        case .job:
            return UIImage(named: "job-hunting_unselected") ?? UIImage()
        case .chat:
            return UIImage(named: "chat_unselected") ?? UIImage()
        case .myPage:
            return UIImage(named: "mypage_unselected") ?? UIImage()
        }
    }
    
    var title: String {
        switch self {
        case .home:
            return "홈"
        case .job:
            return "구인구직"
        case .chat:
            return "채팅"
        case .myPage:
            return "마이페이지"
        }
    }
    
    var selectedImage: UIImage {
        switch self {
        case .home:
            return UIImage(named: "home_selected") ?? UIImage()
        case .job:
            return UIImage(named: "job-hunting_selected") ?? UIImage()
        case .chat:
            return UIImage(named: "chat_selected") ?? UIImage()
        case .myPage:
            return UIImage(named: "mypage_selected") ?? UIImage()
        }
    }
}

class TabBarViewController: UITabBarController {
    var coordinator: SceneCoordinator
    
    init(coordinator: SceneCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTabBarAppearance()
        
        var tabs: [UINavigationController] = []
        for tab in Tabs.allCases {
            let nav = tab.nav
            nav.tabBarItem.title = tab.title
            nav.tabBarItem.image = tab.image
            nav.tabBarItem.selectedImage = tab.selectedImage
            tabs.append(nav)
        }
        
        setViewControllers(tabs, animated: false)
        selectedViewController = tabs.first
    }
    
    override var selectedViewController: UIViewController? {
        didSet {
            print(selectedIndex)
            guard let nav = selectedViewController as? UINavigationController else { return }
            switch selectedIndex {
            case 0:
                guard var vc = nav.visibleViewController as? HomeViewController else { return }
                let viewModel = HomeViewModel(sceneCoordinator: coordinator)
                coordinator.currentVC = vc
                
                guard !vc.hasViewModel else { return }
                DispatchQueue.main.async {
                    vc.bind(viewModel: viewModel)
                    vc.hasViewModel = true
                }
                
            case 1:
                guard var vc = nav.visibleViewController as? JobOpeningHuntingViewController else { return }
                let viewModel = JobOpeningHuntingViewModel(sceneCoordinator: coordinator)
                coordinator.currentVC = vc
                
                guard !vc.hasViewModel else { return }
                DispatchQueue.main.async {
                    vc.bind(viewModel: viewModel)
                    vc.hasViewModel = true
                }
                
            case 2:
                guard var vc = nav.visibleViewController as? ChatViewController else { return }
                let viewModel = ChatViewModel(sceneCoordinator: coordinator)
                coordinator.currentVC = vc
                
                guard !vc.hasViewModel else { return }
                DispatchQueue.main.async {
                    vc.bind(viewModel: viewModel)
                    vc.hasViewModel = true
                }
                
                
            case 3:
                guard var vc = nav.visibleViewController as? MyPageViewController else { return }
                let viewModel = MyPageViewModel(sceneCoordinator: coordinator)
                coordinator.currentVC = vc
                
                guard !vc.hasViewModel else { return }
                DispatchQueue.main.async {
                    vc.bind(viewModel: viewModel)
                    vc.hasViewModel = true
                }
            default:
                break
            }
        }
    }
    
    private func setTabBarAppearance() {
        if #available(iOS 15, *) {
            let appearance = UITabBarAppearance()
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
