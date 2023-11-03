//
//  JobOpeningHuntingViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/3/23.
//

import UIKit
import Then
import SnapKit
import RxSwift

class JobOpeningHuntingViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: JobOpeningHuntingViewModel!
    
    func bindViewModel() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setupUI()
        setConstraints()
        
    }
    
    private func setNavigationBar() {
        self.navigationItem.titleView = NavigationTitleView(title: "")
        self.navigationItem.leftBarButtonItem = NavigationLeftBarButtonItem(
            type: .back,
            viewController: self
        )
//        self.navigationItem.leftBar
        self.navigationItem.rightBarButtonItem = NavigationRightBarButtonItem(
            type: .notification,
            viewController: self
        )
        
        self.navigationController?.navigationBar.applyShadow(shadowType: .shadowIt2)
        
        let barAppearance = UINavigationBarAppearance().then {
            $0.backgroundColor = .white_FFFFFF
        }
        
        navigationItem.scrollEdgeAppearance = barAppearance
    }
    
    private func setupUI() {
        self.view.backgroundColor = .gray_EEEFEF
    }
    
    private func setConstraints() {
    }
}

