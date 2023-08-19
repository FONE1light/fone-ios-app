//
//  SignUpViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/08/15.
//

import UIKit
import Then

class SignUpViewController: UIViewController, ViewModelBindableType {

    var viewModel: SignUpViewModel! // FIXME: ! 없이 할 방법
    
    let baseView = UIView().then {
        $0.backgroundColor = .beige_624418
    }
    
    let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
    }
    
    let textField = DefaultTextField(
        placeHolder: "3~8자리의 숫자, 영어, 한글만 가능합니다"
    )
    
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
        self.view.addSubview(baseView)
        
        baseView.addSubview(stackView)
        
        [ textField, button ].forEach {
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
        
        button.snp.makeConstraints {
            $0.width.equalTo(82)
        }
    }
    
}
