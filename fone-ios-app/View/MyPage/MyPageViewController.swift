//
//  MyPageViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/17.
//

import UIKit
import SnapKit

class MyPageViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: MyPageViewModel!
    var hasViewModel = false
    
    private let profileSection = UIView()
    
    private let profileImage = UIImageView().then {
        $0.backgroundColor = .gray_C5C5C5
        $0.cornerRadius = 34
    }
    
    private let nameLabel = UILabel().then {
        $0.text = "양태호"
        $0.textColor = .gray_161616
        $0.font = .font_b(20)
    }
    
    private let jobLabel = UILabel().then {
        $0.text = "STAFF"
        $0.textColor = .red_CE0B39
        $0.font = .font_m(14)
    }
    
    private let rightArrowImage = UIImageView().then {
        $0.image = UIImage(named: "arrow_right")
    }
    
    private let rightArrowButton = UIButton()
    
    private var buttonStackView: MyPageButtonStackView?
    
    private let divider = EmptyView(height: 8).then {
        $0.backgroundColor = .gray_F8F8F8
    }
    
    private lazy var tableView = UITableView().then {
        $0.register(with: MyPageMenuCell.self)
        $0.separatorStyle = .none
        $0.dataSource = self
    }
    
    private let menuList: [MyPageMenuType] = [
        .postings,
        .contact,
        .version,
        .logout,
        .withdrawal
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar()
        setupUI()
        setConstraints()
        
        setupProfileSection()
    }
    
    func bindViewModel() {
        rightArrowButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                let profileViewModel = ProfileViewModel(sceneCoordinator: self.viewModel.sceneCoordinator)
                let scene = Scene.profile(profileViewModel)
                self.viewModel.sceneCoordinator.transition(to: scene, using: .push, animated: true)
            }.disposed(by: rx.disposeBag)
        
        buttonStackView?.scrapButtonTap
            .withUnretained(self)
            .bind { owner, _ in
                let viewModel = ScrapViewModel(sceneCoordinator: owner.viewModel.sceneCoordinator)
                let scene = Scene.scrap(viewModel)
                
                owner.viewModel.sceneCoordinator.transition(to: scene, using: .push, animated: true)

            }.disposed(by: rx.disposeBag)
        
        buttonStackView?.saveButtonTap
            .withUnretained(self)
            .bind { owner, _ in
                let viewModel = MyRegistrationsViewModel(sceneCoordinator: owner.viewModel.sceneCoordinator)
                let scene = Scene.myRegistrations(viewModel)
                
                owner.viewModel.sceneCoordinator.transition(to: scene, using: .push, animated: true)
            }.disposed(by: rx.disposeBag)
    }
    
    private func setNavigationBar() {
        self.navigationItem.leftBarButtonItem = NavigationLeftBarButtonItem(type: .myPage)
        self.navigationItem.rightBarButtonItem = NavigationRightBarButtonItem(type: .notification)
        
    }
    
    private func setupUI() {
        view.backgroundColor = .white_FFFFFF
        
        let stackView = UIStackView().then {
            $0.axis = .vertical
        }
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        let whiteEmptyView = EmptyView(height: 20)
        
        [profileSection, whiteEmptyView, divider, tableView]
            .forEach { stackView.addArrangedSubview($0) }
        
    }
    
    private func setConstraints() {
    }
}

// MARK: - UI functions
extension MyPageViewController {
    private func setupProfileSection() {
        buttonStackView = MyPageButtonStackView(
            width: self.view.frame.width,
            height: 42
        )
        guard let buttonStackView = buttonStackView else { return }
        
        [
            profileImage,
            nameLabel,
            jobLabel,
            rightArrowImage,
            rightArrowButton,
            buttonStackView
        ]
            .forEach { profileSection.addSubview($0) }
        
        profileImage.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(24)
            $0.size.equalTo(68)
        }
        
        nameLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImage)
            $0.leading.equalTo(profileImage.snp.trailing).offset(12)
        }
        
        jobLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImage)
            $0.leading.equalTo(nameLabel.snp.trailing).offset(6)
        }
        
        rightArrowImage.snp.makeConstraints {
            $0.centerY.equalTo(profileImage)
            $0.size.equalTo(24)
            $0.trailing.equalToSuperview().inset(10)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(42)
            $0.bottom.equalToSuperview()
        }
        
        rightArrowButton.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.top)
            $0.leading.equalTo(profileImage.snp.leading)
            $0.trailing.equalTo(rightArrowImage.snp.trailing)
            $0.bottom.equalTo(profileImage.snp.bottom)
        }
    }
}

// MARK: - UITableView functions
extension MyPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as MyPageMenuCell
                
        // FIXME: index 지정 방식 변경
        cell.setupCell(type: menuList[indexPath.row])
        return cell
    }
}
