//
//  SavedProfilesTabBarController.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/10/11.
//

import UIKit

// TODO: Custom해서 변경된 TabBar 여백 적용(하단 여백 삭제, 상단 여백 추가)

protocol MyPageTabs {
    var viewController: UIViewController { get }
    var tabBarItem: MyPageTabBarItem { get }
}

enum SavedProfilesTabs: Int, CaseIterable, MyPageTabs {
    case actor = 0
    case staff
    
    var viewController: UIViewController {
        switch self {
        case .actor, .staff:
            return SavedProfilesViewController()
        }
    }
    
    var tabBarItem: MyPageTabBarItem {
        switch self {
        case .actor:
            return MyPageTabBarItem(title: "배우", tag: 0)
        case .staff:
            return MyPageTabBarItem(title: "스태프", tag: 1)
        }
    }
}

class SavedProfilesTabBarController: UITabBarController, ViewModelBindableType {
    
    var viewModel: SavedProfilesTabBarViewModel!
    
    func bindViewModel() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setTabBar()
        setUI()
        setConstraints()
        let y = tabBar.frame.size.height + view.safeAreaInsets.top
        viewControllers?.forEach {
            $0.view.frame.origin = CGPoint(x: 0, y: y)
        }
        
    }
    
    private func setNavigationBar() {
        self.navigationItem.titleView = NavigationTitleView(title: "찜한 프로필")
        self.navigationItem.leftBarButtonItem = NavigationLeftBarButtonItem(
            type: .back,
            viewController: self
        )
    }
    
    private func setTabBar() {
        
        tabBar.setMyPageTabBar(tabs: SavedProfilesTabs.allCases)
        tabBar.isTranslucent = false
        
        var tabs: [UIViewController] = []
        for tab in SavedProfilesTabs.allCases {
            let viewController = tab.viewController
            viewController.tabBarItem = tab.tabBarItem
            tabs.append(viewController)
        }
        
        setViewControllers(tabs, animated: true) // TODO: true or false 결정
        selectedViewController = tabs.first
    }
    
    private func setUI() {
        self.view.backgroundColor = .white_FFFFFF
    }
    
    private func setConstraints() {
    }
    
    override func viewDidLayoutSubviews() {
        tabBar.frame = CGRect(x: UITabBar.Constants.horizontalInset,
                              y: view.safeAreaInsets.top,
                              width: UIScreen.main.bounds.width - UITabBar.Constants.horizontalInset * 2,
                              height: UITabBar.Constants.tabBarHeight
        )
        
        let y = tabBar.frame.size.height + view.safeAreaInsets.top
//        viewControllers?.forEach {
//            $0.view.frame.origin = CGPoint(x: 0, y: y)
//        }
//        selectedViewController?.view.frame.origin = CGPoint(x: 0, y: y)
//        selectedViewController?.view.frame.origin = CGPoint(x: 0, y: tabBar.frame.size.height + 100)
    
        super.viewDidLayoutSubviews()
    }

}












extension UITabBar {
    struct Constants {
        /// leading, trailing inset
        static let horizontalInset: CGFloat = 16
        static let tabBarHeight: CGFloat = 38
    }
    
    func setSelectedUnderline(itemsCount: Int) {
        let tabBarwidth = UIScreen.main.bounds.width - Constants.horizontalInset * 2
        let itemHeight = Constants.tabBarHeight
        let itemWidth = tabBarwidth/Double(itemsCount)
        
        let selectedUnderLine = UIImage().createSelectionIndicator(
            color: .red_CE0B39,
            size: CGSize(
                width: itemWidth,
                height: itemHeight
            ),
            lineWidth: 2.0
        )
        
        self.selectionIndicatorImage = selectedUnderLine
    }
    
    // UI 설정
    func setMyPageTabBar(tabs: [MyPageTabs]) {
        let underLineView = UIView().then {
            $0.backgroundColor = .gray_D9D9D9
            self.addSubview($0)
        }
        
        underLineView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        barTintColor = .white
        unselectedItemTintColor = .gray_9E9E9E
        barStyle = .black
        setSelectedUnderline(itemsCount: tabs.count)
    }
}
