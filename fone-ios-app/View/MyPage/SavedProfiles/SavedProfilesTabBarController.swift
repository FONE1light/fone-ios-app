//
//  SavedProfilesTabBarController.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/10/13.
//

import UIKit
import RxSwift


class SavedProfilesTabBarController: UIViewController, ViewModelBindableType {
    struct Constants {
        /// leading, trailing inset
        static let horizontalInset: CGFloat = 16
    }
    
    var viewModel: SavedProfilesTabBarViewModel!
    var disposeBag = DisposeBag()
    
    private let tabBar = MyPageTabBarCollectionView(type: .savedProfiles)
    
    private var pageController: MyPagePageViewController!
    
    private var currentIndex = 0
    
    func bindViewModel() {
        tabBar.itemSelected
            .withUnretained(self)
            .bind { owner, indexPath in
                print("\(indexPath) is selected")
                
                // If selected Index is other than Selected one, by comparing with current index, page controller goes either forward or backward.
                let index = indexPath.row
                if index != owner.currentIndex {
                    owner.pageController.movePage(index: index)
                    owner.tabBar.scrollToItem(at: IndexPath.init(item: index, section: 0), at: .centeredHorizontally, animated: true)
                }
                
                owner.currentIndex = index
                
            }.disposed(by: disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setUI()
        setConstraints()
        
        initPageController()
    }
    
    private func initPageController() {
        pageController = MyPagePageViewController(tabBarType: .savedProfiles)
        // TODO: y offset, height 확정
        let tabBarHeight = MyPageTabBarCollectionView.Constants.tabBarHeight + MyPageTabBarCollectionView.Constants.grayUnderlineHeight
        self.pageController.view.frame = CGRect.init(
            x: 0,
            y: tabBarHeight + 100,
            width: self.view.frame.width,
            height: self.view.frame.height - tabBarHeight - 100//(view.safeAreaInsets.top + tabBar.frame.height)
        )
        
        self.addChild(self.pageController)
        self.view.addSubview(self.pageController.view)
        self.pageController.didMove(toParent: self)
    }
    
    private func setNavigationBar() {
        self.navigationItem.titleView = NavigationTitleView(title: "찜한 프로필")
        self.navigationItem.leftBarButtonItem = NavigationLeftBarButtonItem(
            type: .back,
            viewController: self
        )
    }
    
    private func setUI() {
        self.view.backgroundColor = .white_FFFFFF
        
        [tabBar].forEach {
            self.view.addSubview($0)
        }
    }
    
    private func setConstraints() {
        tabBar.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview().inset(MyPageTabBarCollectionView.Constants.horizontalInset)
            $0.height.equalTo(MyPageTabBarCollectionView.Constants.tabBarHeight + MyPageTabBarCollectionView.Constants.grayUnderlineHeight)
        }
    }
    

}
