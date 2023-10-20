//
//  SignUpSelectionViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/08/23.
//

import UIKit
import Then
import RxSwift

class SignUpSelectionViewController: UIViewController, ViewModelBindableType {

    var viewModel: SignUpSelectionViewModel!
    var disposeBag = DisposeBag()
    
    let baseView = UIView().then {
        $0.backgroundColor = .white_FFFFFF
    }
    
    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
    }
    
    let stepIndicator = StepIndicator(.first)
    
    let titleLabel = UILabel().then {
        $0.text = "직업과 관심사 선택으로\n맞춤 설정 끝!"
        $0.font = .font_b(20)
        $0.numberOfLines = 0
    }
    
    let jobSelectionBlock = SelectionBlock().then {
        $0.setTitle("직업 선택")
        $0.setSubtitle("(추후 변경 가능)")
        $0.setSelections(Job.allCases)
    }
    
    let interestSelectionBlock = SelectionBlock().then {
        $0.setTitle("관심사 선택")
        $0.setSubtitle("(중복 선택 가능)")
        $0.setSelections(Category.allCases)
    }
  
    let button = CustomButton("다음", type: .bottom)
    
    func bindViewModel() {
        button.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                let sceneCoordinator = owner.viewModel.sceneCoordinator
                let personalInfoViewModel = SignUpPersonalInfoViewModel(sceneCoordinator: sceneCoordinator)
                let job = owner.viewModel.job?.serverName
                let interests = owner.viewModel.interests?.map { $0.serverName }
                personalInfoViewModel.signInInfo = owner.viewModel.signInInfo
                personalInfoViewModel.signUpSelectionInfo = SignUpSelectionInfo(
                    job: job,
                    interests: interests
                )
                let signUpScene = Scene.signUpPersonalInfo(personalInfoViewModel)
                owner.viewModel.sceneCoordinator.transition(to: signUpScene, using: .push, animated: true)
            }.disposed(by: rx.disposeBag)
        
        jobSelectionBlock.selectedItems
            .withUnretained(self)
            .bind { owner, items in
                guard items.count == 1, let job = items.first as? Job else { return }
                owner.viewModel.job = job
            }.disposed(by: disposeBag)
        
        interestSelectionBlock.selectedItems
            .withUnretained(self)
            .bind { owner, items in
                guard let interests = items as? [Category] else { return }
                owner.viewModel.interests = interests
            }.disposed(by: disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar()
        setUI()
        setConstraints()
        
    }
    
    private func setNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.titleView = NavigationTitleView(title: "회원가입")
        self.navigationItem.leftBarButtonItem = NavigationLeftBarButtonItem(
            type: .back,
            viewController: self
        )
    }
    
    private func setUI() {
        self.view.backgroundColor = .white_FFFFFF
        
        self.view.addSubview(baseView)
        
        baseView.addSubview(stackView)
        baseView.addSubview(button)
        
        [
            stepIndicator,
            EmptyView(height: 14),
            titleLabel,
            EmptyView(height: 32),
            jobSelectionBlock,
            EmptyView(height: 40),
            interestSelectionBlock
        ]
            .forEach {
            stackView.addArrangedSubview($0)
        }
        
    }
    
    private func setConstraints() {
        baseView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(40)
        }
        
        jobSelectionBlock.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
        
        interestSelectionBlock.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
        
        button.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-38)
            $0.height.equalTo(48)
        }
        
        
    }
    
}
