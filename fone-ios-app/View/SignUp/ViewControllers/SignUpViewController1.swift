//
//  SignUpViewController1.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/08/23.
//

import UIKit
import Then

// TODO: Notch 여백 설정
class SignUpViewController1: UIViewController, ViewModelBindableType {

    var viewModel: SignUpViewModel! // FIXME: ! 없이 할 방법
    
    let baseView = UIView().then {
        $0.backgroundColor = .white_FFFFFF // beige
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
        $0.setSelections(["ACTOR", "STAFF"])
    }
    
    let interestSelectionBlock = SelectionBlock().then {
        $0.setTitle("관심사 선택")
        $0.setSubtitle("(중복 선택 가능)")
        $0.setSelections(["장편영화", "단편영화", "독립영화"])
    }
    
    let button = UIButton().then {
        $0.setTitle("중복확인", for: .normal)
        $0.titleLabel?.font = .font_r(14)
        $0.titleLabel?.textColor = .gray_9E9E9E // TODO: 왜 색깔 적용 안되고 white인지
        $0.backgroundColor = .black//.gray_D9D9D9
    }
    
    func bindViewModel() {
        button.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
            print("clicked")
            owner.viewModel.checkNicknameDuplication("테스트닉네임")
        }.disposed(by: rx.disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setConstraints()
        
    }
    
    private func setUI() {
        self.view.backgroundColor = .white_FFFFFF
        
        self.view.addSubview(baseView)
        
        baseView.addSubview(stackView)
        
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
            $0.centerY.equalToSuperview()
        }
        
        jobSelectionBlock.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
        
        interestSelectionBlock.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
        
        button.snp.makeConstraints {
            $0.width.equalTo(82)
        }
    }
    
}