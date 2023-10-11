//
//  ScrapViewController_TabBarVC.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/10/04.
//

import UIKit

enum ScrapTabs: Int, CaseIterable {
    case job = 0
    case competition
    
    var nav: UINavigationController {
        switch self {
        case .job:
            return UINavigationController(rootViewController: JobViewController())
        case .competition:
            return UINavigationController(rootViewController: CompetitionViewController())
        }
    }
    
    var tabBarItem: MyPageTabBarItem {
        switch self {
        case .job:
            return MyPageTabBarItem(title: "구인구직", tag: 0)
        case .competition:
            return MyPageTabBarItem(title: "공모전", tag: 1)
        }
    }
}

class ScrapViewController_TabBarVC: UITabBarController, ViewModelBindableType, UITabBarControllerDelegate {
    
    var viewModel: ScrapViewModel!

    private let underLineView = UIView().then {
        $0.backgroundColor = .gray_D9D9D9
    }

    func bindViewModel() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setNavigationBar()
        setTabBar()
        
        setUI()
        setConstraints()
    }
    

    private func setNavigationBar() {
        self.navigationItem.titleView = NavigationTitleView(title: "스크랩")
        self.navigationItem.leftBarButtonItem = NavigationLeftBarButtonItem(
            type: .back,
            viewController: self
        )
    }
    
    private func setTabBar() {
        tabBar.barTintColor = .white
        tabBar.unselectedItemTintColor = .gray_9E9E9E
        tabBar.barStyle = .black
        tabBar.setUnderline(itemsCount: ScrapTabs.allCases.count)
        
        var tabs: [UINavigationController] = []
        for tab in ScrapTabs.allCases {
            let viewController = tab.nav
            viewController.tabBarItem = tab.tabBarItem
            tabs.append(viewController)
        }
        
        setViewControllers(tabs, animated: false)
        selectedViewController = tabs.first
    }
    
    private func setUI() {
        self.view.backgroundColor = .white_FFFFFF
        
        [underLineView].forEach {
            self.tabBar.addSubview($0)
        }
    }
    
    override func viewDidLayoutSubviews() {
        tabBar.frame = CGRect(x: UITabBar.Constants.horizontalInset,
                              y: view.safeAreaInsets.top,
                              width: UIScreen.main.bounds.width - UITabBar.Constants.horizontalInset * 2,
                              height: UITabBar.Constants.tabBarHeight
        )

        super.viewDidLayoutSubviews()
    }

    private func setConstraints() {
        underLineView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview() // superview: tabBar
            $0.bottom.equalToSuperview().offset(1)
            $0.height.equalTo(1)
        }
    }
    
}

extension UITabBar {
    struct Constants {
        /// leading, trailing inset
        static let horizontalInset: CGFloat = 16
        static let tabBarHeight: CGFloat = 38
    }
    
    func setUnderline(itemsCount: Int) {
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
}
