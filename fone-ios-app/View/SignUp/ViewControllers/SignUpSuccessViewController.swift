//
//  SignUpSuccessViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/02.
//

import UIKit
import Then

// TODO: Notch 여백 설정
class SignUpSuccessViewController: UIViewController, ViewModelBindableType {

    var viewModel: SignUpViewModel! // FIXME: ! 없이 할 방법
    
    let checkView = UIView().then {
        $0.cornerRadius = 38
        $0.backgroundColor = .red_CE0B39
    }
    let checkImageView = UIImageView(image: UIImage(named: "Check_Big"))

    
    let welcomeLabel = UILabel().then {
        $0.text = "황수철 님!\n에프원 회원가입을 환영합니다."
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.font = .font_b(19)
        $0.textColor = .gray_161616
    }
    
    let loginButton = UIButton().then {
        $0.setTitle("로그인하기", for: .normal)
        $0.backgroundColor = .red_CE0B39
        $0.cornerRadius = 5
        $0.titleLabel?.font = .font_m(16)
    }
    
    
    func bindViewModel() {
        loginButton.rx.tap
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
        
        [checkView, welcomeLabel, loginButton]
            .forEach { view.addSubview($0) }
        
        checkView.addSubview(checkImageView)
        
    }
    
    private func setConstraints() {
        checkImageView.snp.makeConstraints {
            $0.size.equalTo(53)
            $0.center.equalToSuperview()
        }
        
        checkView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(76)
        }
        
        welcomeLabel.snp.makeConstraints {
            $0.top.equalTo(checkView.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
        }
        
        loginButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-38)
            $0.height.equalTo(48)
        }
    }
    

    
}