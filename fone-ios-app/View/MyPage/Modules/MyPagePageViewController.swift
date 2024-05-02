//
//  MyPagePageViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/10/13.
//

import UIKit


/// 마이페이지의 탭바 하단 UIPageViewController
class MyPagePageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    private var currentIndex = 0
    
    private var presetViewControllers: [UIViewController]
    
    init(
        tabBarType: TabBarType,
        sceneCoordinator: SceneCoordinatorType
    ) {
        self.presetViewControllers = tabBarType.getViewControllers(sceneCoordinator: sceneCoordinator)

        super.init(transitionStyle: .pageCurl, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        getViewController(forViewController: viewController, isNextController: false)
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func movePage(index: Int) {
        guard index != currentIndex else { return }
        
        if index > currentIndex {
            setViewControllers([presetViewControllers[index]], direction: .forward, animated: false, completion: nil)
        } else {
            setViewControllers([presetViewControllers[index]], direction: .reverse, animated: false, completion: nil)
        }
        
        currentIndex = index
    }
    
 
    override func viewDidLoad() {
        dataSource = self
        delegate = self
        
        guard let viewController = presetViewControllers.first else { return }
        setViewControllers(
            [
                viewController
            ],
            direction: .forward, animated: true
        )
    }
}
