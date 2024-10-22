//
//  MyPageViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/17.
//

import UIKit
import SnapKit
import RxSwift
import PanModal

class MyPageViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: MyPageViewModel!
    // 바인딩 전 viewWillAppear에서 호출 시 크래시 방지 위함
    private var optionalViewModel: MyPageViewModel?
    var hasViewModel = false
    
    var disposeBag = DisposeBag()
    
    private let profileSection = UIView()
    
    private let profileImage = UIImageView().then {
        $0.backgroundColor = .gray_C5C5C5
        $0.cornerRadius = 34
        $0.clipsToBounds = true
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
        .question,
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        optionalViewModel?.fetchMyPage()
    }
    
    func bindViewModel() {
        optionalViewModel = viewModel
        
        viewModel.userInfo
            .withUnretained(self)
            .bind { owner, userInfo in
                owner.setProfileImage(userInfo?.profileURL)
                owner.nameLabel.text = userInfo?.nickname
                owner.jobLabel.text = userInfo?.job
            }.disposed(by: disposeBag)
        
        rightArrowButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.viewModel.moveToProfile()
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
                let viewModel = SavedProfilesTabBarViewModel(sceneCoordinator: owner.viewModel.sceneCoordinator)
                let scene = Scene.savedProfiles(viewModel)
                
                owner.viewModel.sceneCoordinator.transition(to: scene, using: .push, animated: true)
            }.disposed(by: rx.disposeBag)
    }
    
    private func setNavigationBar() {
        self.navigationItem.leftBarButtonItem = NavigationLeftBarButtonItem(type: .myPage)
        self.navigationItem.rightBarButtonItem = NavigationRightBarButtonItem(type: .notification, viewController: self)
        
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
    
    private func setProfileImage(_ stringUrl: String?) {
        guard let url = stringUrl, !url.isEmpty else {
            profileImage.image = nil
            return
        }
        profileImage.load(url: url)
    }
}

// MARK: - UITableView functions
extension MyPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(for: indexPath) as MyPageMenuCell
        
        let menuType = menuList[indexPath.row]
        
        cell.setupCell(type: menuType)
        
        cell.buttonTap
            .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { owner, _ in
                if let scene = menuType.nextScene(owner.viewModel.sceneCoordinator) {
                    switch menuType {
                    case .question:
                        owner.viewModel.sceneCoordinator.transition(to: scene, using: .fullScreenModal, animated: false)
                    default:
                        owner.viewModel.sceneCoordinator.transition(to: scene, using: .push, animated: true)
                    }
                    return
                }
                
                switch menuType {
                case .logout:
//                    // FIXME: 높이 늘어나는 것 해결(UIView-Encapsulated-Layout-Height)
                    owner.viewModel.logout()
                case .withdrawal:
                    owner.viewModel.signout()
                default: return
                }
                
            }.disposed(by: disposeBag)
        return cell
    }
}
