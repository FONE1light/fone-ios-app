//
//  ScrapViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/24.
//

import UIKit

extension ScrapViewController {
    struct Constants {
        /// leading, trailing inset
        static let horizontalInset: CGFloat = 17
        
        static let tabBarHeight: CGFloat = 37
    }
}

class ScrapViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: ScrapViewModel!
    
    var tabBar = MyPageTabBar(
        width: UIScreen.main.bounds.width - Constants.horizontalInset * 2,
        height: Constants.tabBarHeight
    )
    
    let underLineView = UIView().then {
        $0.backgroundColor = .gray_D9D9D9
    }
    
    func bindViewModel() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setNavigationBar()
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
    
    private func setUI() {
        self.view.backgroundColor = .white_FFFFFF
        
        [tabBar, underLineView].forEach {
            self.view.addSubview($0)
        }
        
        let job = MyPageTabBarItem(title: "구인구직", tag: 0)
        
        let competition = MyPageTabBarItem(title: "공모전", tag: 1)
        
        tabBar.setItems([job, competition], animated: true)
        tabBar.selectedItem = tabBar.items?.first
    }
    
    private func setConstraints() {
        tabBar.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview().inset(Constants.horizontalInset)
            $0.height.equalTo(Constants.tabBarHeight)
        }
        
        underLineView.snp.makeConstraints {
            $0.leading.trailing.equalTo(tabBar)
            $0.top.equalTo(tabBar.snp.bottom)
            $0.height.equalTo(1)
        }
    }
}
