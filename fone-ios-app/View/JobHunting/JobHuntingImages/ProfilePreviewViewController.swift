//
//  ProfilePreviewViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 12/12/23.
//

import UIKit
import Then
import SnapKit
import RxSwift

class ProfilePreviewViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: ProfilePreviewViewModel!
    private var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setupUI()
        setConstraints()
    }
    
    func bindViewModel() {
        imageView.load(url: viewModel.imageUrl)
    }
    
    private func setNavigationBar() {
        navigationItem.rightBarButtonItem = NavigationRightBarButtonItem(
            type: .close,
            viewController: self
        )
        navigationItem.hidesBackButton = true
    }
    
    private func setupUI() {
        view.backgroundColor = .black_000000.withAlphaComponent(0.3)
        view.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setConstraints() {
    }
}

