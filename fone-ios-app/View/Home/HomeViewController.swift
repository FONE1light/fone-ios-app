//
//  HomeViewController.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/09/11.
//

import UIKit

class HomeViewController: UIViewController, ViewModelBindableType {
    var viewModel: HomeViewModel!
    var hasViewModel = false
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        
    }
    
    func bindViewModel() {
        
    }
    
    private func setNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.hidesBarsOnSwipe = true
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.shadowColor = nil
        navigationBarAppearance.backgroundColor = .white
        
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        
        self.navigationItem.leftBarButtonItem = NavigationLeftBarButtonItem(type: .home)
        self.navigationItem.rightBarButtonItem = NavigationRightBarButtonItem(type: .notification, viewController: self)
    }
}
