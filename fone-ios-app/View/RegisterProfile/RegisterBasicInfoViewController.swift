//
//  RegisterBasicInfoViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/18/23.
//

import UIKit
import Then
import SnapKit
import RxSwift

class RegisterBasicInfoViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: RegisterBasicInfoViewModel!
    
    var disposeBag = DisposeBag()
    
    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
    }
    
    private let stepIndicator = StepIndicator(index: 0, totalCount: 4)
    
    private let titleLabel = UILabel().then {
        $0.text = "기본 정보를 입력해 주세요"
        $0.font = .font_b(19)
        $0.textColor = .violet_362C4C
        $0.numberOfLines = 0
    }
    
    private let nameBlock = UIView()
    
    func bindViewModel() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setupUI()
        setConstraints()
    }
    
    private func setNavigationBar() {
        self.navigationItem.titleView = NavigationTitleView(title: "배우 등록하기")
        self.navigationItem.leftBarButtonItem = NavigationLeftBarButtonItem(
            type: .back,
            viewController: self
        )
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white_FFFFFF
        
        view.addSubview(stackView)
        
        [
            stepIndicator,
            EmptyView(height: 20),
            titleLabel,
            EmptyView(height: 12),
            nameBlock,
        ]
            .forEach { stackView.addArrangedSubview($0) }
        
    }
    
    private func setConstraints() {
        stackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
}

