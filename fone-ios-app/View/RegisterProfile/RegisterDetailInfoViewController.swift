//
//  RegisterDetailInfoViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/19/23.
//

import UIKit
import Then
import SnapKit
import RxSwift

class RegisterDetailInfoViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: RegisterDetailInfoViewModel!
    var disposeBag = DisposeBag()
    
    func bindViewModel() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setupUI()
        setConstraints()
        
    }
    
    private func setNavigationBar() {
        navigationItem.titleView = NavigationTitleView(title: "")
        navigationItem.leftBarButtonItem = NavigationLeftBarButtonItem(
            type: .back,
            viewController: self
        )
    }
    
    private func setupUI() {
        view.backgroundColor = .white_FFFFFF
    }
    
    private func setConstraints() {
    }
}

