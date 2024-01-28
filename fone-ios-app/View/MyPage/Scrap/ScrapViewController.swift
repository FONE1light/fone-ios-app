//
//  ScrapViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/10/04.
//

import UIKit
import RxSwift

// TODO: 공통 Custom TabBarController 만들어서 정리 (ScrapViewController, SavedProfilesTabBarController, MyRegistrationsViewController)
class ScrapViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: ScrapViewModel!
    var disposeBag = DisposeBag()
    
    private let tabBar = MyPageTabBarCollectionView(type: .scrap)
    
    private var pageController: MyPagePageViewController!
    
    private var currentIndex = 0

    func bindViewModel() {
        tabBar.itemSelected
            .withUnretained(self)
            .bind { owner, indexPath in
                
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
        pageController = MyPagePageViewController(
            tabBarType: .scrap,
            sceneCoordinator: viewModel.sceneCoordinator
        )
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
        self.navigationItem.titleView = NavigationTitleView(title: "스크랩")
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
