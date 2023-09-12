//
//  SignUpPhoneNumberViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/02.
//

import UIKit
import Then
import SnapKit

class SignUpPhoneNumberViewController: UIViewController, ViewModelBindableType {

    var viewModel: SignUpPhoneNumberViewModel!
    
    let baseView = UIView().then {
        $0.backgroundColor = .white_FFFFFF
    }
    
    let stepIndicator = StepIndicator(.third)
    
    let titleLabel = UILabel().then {
        $0.text = "마지막으로\n휴대전화 번호를 인증해주세요."
        $0.font = .font_b(20)
        $0.numberOfLines = 0
    }
    
    let phoneNumberBlock = UIView()
    
    private let phoneNumberLabel = UILabel().then {
        $0.text = "휴대전화 번호"
        $0.font = .font_m(15)
        $0.textColor = .gray_161616
    }
    
    private let phoneNumberTextField = DefaultTextField(placeHolder: "'-' 빼고 숫자만 입력")
    
    private let sendAuthNumberButton = CustomButton("인증번호 발송", type: .auth).then {
        $0.isEnabled = false
    }
    
    let authNumberBlock = UIView()
    
    private let authNumberTextField = DefaultTextField(placeHolder: "인증번호 6자리")
    
    private let checkAuthNumberButton = CustomButton(type: .auth).then {
        $0.setTitle("인증번호 확인", for: .normal)
        $0.isEnabled = false
    }
    
    private let authNumberLabel = UILabel().then {
        $0.text = "인증번호를 발송했습니다. (유효시간 3분)\n인증번호가 오지 않는다면, 통신사 스팸 차단 서비스 혹은 휴대폰 번호 차단 여부를 확인해주세요."
        $0.font = .font_r(12)
        $0.textColor = .gray_555555
        $0.numberOfLines = 0
    }
    
    let agreementBlock = UIView().then {
        $0.backgroundColor = .gray_161616
    }
    
    private lazy var tableView = UITableView().then {
        $0.showsVerticalScrollIndicator = false
//        $0.backgroundColor = .yellow
        $0.separatorStyle = .none
        $0.delegate = self
        $0.dataSource = self
        $0.register(with: TermsCell.self)
    }
    
    private let button = CustomButton("회원가입", type: .bottom)
    
    func bindViewModel() {
        sendAuthNumberButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
            print("clicked")
                
        }.disposed(by: rx.disposeBag)
        
        button.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                let successViewModel = SignUpViewModel(sceneCoordinator: self.viewModel.sceneCoordinator)
                let signUpScene = Scene.signUpSuccess(successViewModel)
                owner.viewModel.sceneCoordinator.transition(to: signUpScene, using: .push, animated: true)
            }.disposed(by: rx.disposeBag)
        
//        tableView.rx.itemSelected
//            .withUnretained(self)
//            .bind { owner, indexPath in
//                guard let cell = owner.tableView.cellForRow(at: indexPath) as? TermsCell else { return }
//                cell.expandableView.isHidden = !cell.expandableView.isHidden
//                owner.tableView.reloadRows(at: [indexPath], with: .automatic)
//            }.disposed(by: rx.disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setConstraints()
        bindViewModel()
    }
    
    private func setUI() {
        self.view.backgroundColor = .white_FFFFFF
        
        self.view.addSubview(baseView)
        
        [
            stepIndicator,
            titleLabel,
            phoneNumberBlock,
            authNumberBlock,
            agreementBlock,
            button
        ]
            .forEach { baseView.addSubview($0) }
        
        [
            phoneNumberLabel,
            phoneNumberTextField,
            sendAuthNumberButton,
        ]
            .forEach { phoneNumberBlock.addSubview($0) }
        
        [
            authNumberLabel,
            authNumberTextField,
            checkAuthNumberButton,
        ]
            .forEach { authNumberBlock.addSubview($0) }
        
        [
            tableView
        ]
            .forEach { agreementBlock.addSubview($0)}
        
        self.setupPhoneNumberBlock()
        self.setupAuthNumberBlock()
        self.setupAgreementBlock()
        
        
    }
    
    private func setConstraints() {
        baseView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(40)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        stepIndicator.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(stepIndicator.snp.bottom).offset(14)
        }
        
        phoneNumberBlock.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview()
        }
        
        authNumberBlock.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(phoneNumberBlock.snp.bottom).offset(40)
        }
        
        agreementBlock.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(authNumberBlock.snp.bottom).offset(49)
//            $0.height.lessThanOrEqualTo(221) // TODO: 삭제
            $0.height.equalTo(221)
        }
        
        button.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-38)
            $0.height.equalTo(48)
        }

    }
    
    private func setupPhoneNumberBlock() {
        
        phoneNumberLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        phoneNumberTextField.snp.makeConstraints {
            $0.top.equalTo(phoneNumberLabel.snp.bottom).offset(8)
            $0.leading.bottom.equalToSuperview()
        }
        
        sendAuthNumberButton.snp.makeConstraints {
            $0.top.bottom.equalTo(phoneNumberTextField)
            $0.leading.equalTo(phoneNumberTextField.snp.trailing).offset(4)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(94)
        }
    }
    
    private func setupAuthNumberBlock() {
        authNumberTextField.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        checkAuthNumberButton.snp.makeConstraints {
            $0.top.bottom.equalTo(authNumberTextField)
            $0.leading.equalTo(authNumberTextField.snp.trailing).offset(4)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(94)
        }
        
        authNumberLabel.snp.makeConstraints {
            $0.top.equalTo(authNumberTextField.snp.bottom).offset(4)
            $0.leading.equalTo(authNumberTextField.snp.leading)
            $0.trailing.equalTo(checkAuthNumberButton.snp.trailing)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func setupAgreementBlock() {
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview() // TODO: 나중에 수정
        }
    }
    
    
}

extension SignUpPhoneNumberViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = self.tableView.cellForRow(at: indexPath) as? TermsCell else { return }
        cell.expandableView.isHidden = !cell.expandableView.isHidden
//        self.tableView.reloadRows(at: [indexPath], with: .automatic)
//        tableView.reloadRows(at: [indexPath], with: .fade)
        tableView.reloadData()
    }
}

extension SignUpPhoneNumberViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return self.arrDropDownDataSource.count
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as TermsCell
        cell.label.text = "이용약관 동의(필수)"
        return cell
    }
    
}
