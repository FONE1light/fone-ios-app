//
//  SignUpSelectionViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/08/23.
//

import UIKit
import Then

class SignUpSelectionViewController: UIViewController, ViewModelBindableType {

    var viewModel: SignUpViewModel! // FIXME: ! 없이 할 방법
    
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
        $0.setSelections(["ACTOR", "STAFF", "NORMAL", "HUNTER"])
    }
    
    let interestSelectionBlock = SelectionBlock().then {
        $0.setTitle("관심사 선택")
        $0.setSubtitle("(중복 선택 가능)")
        $0.setSelections(["장편영화", "단편영화", "독립영화", "웹 드라마", "뮤비 / CF", "OTT/TV 드라마", "유튜브", "홍보 / 바이럴", "기타"])
    }
  
    let button = BottomButton()
    
    func bindViewModel() {
        button.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                let signUpScene = Scene.signUpInfo(owner.viewModel)
                owner.viewModel.sceneCoordinator.transition(to: signUpScene, using: .push, animated: true)
            }.disposed(by: rx.disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar()
        setUI()
        setConstraints()
        
    }
    
    // TODO: NavigationBar 설정
    private func setNavigationBar() {
        self.navigationItem.title = "회원가입"
//        self.navigationItem.

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        
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
