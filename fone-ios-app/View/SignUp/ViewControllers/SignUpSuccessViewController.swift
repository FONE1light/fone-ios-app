//
//  SignUpSuccessViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/02.
//

import UIKit
import Then

class SignUpSuccessViewController: UIViewController, ViewModelBindableType {

    var viewModel: SignUpSuccessViewModel!
    
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
    
    let loginButton = CustomButton("로그인하기", type: .bottom)
    
    func bindViewModel() {
        loginButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                guard let type = owner.viewModel.signInInfo?.type else { return }
                switch type {
                case .email: owner.viewModel.emailSignIn()
                case .social: owner.viewModel.socialSignIn()
                }
        }.disposed(by: rx.disposeBag)
        
        let name = viewModel.signInInfo?.name ?? ""
        welcomeLabel.text = "\(name) 님!\n에프원 회원가입을 환영합니다."
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true
        setUI()
        setConstraints()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
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
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(264)
            $0.centerX.equalToSuperview()
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
