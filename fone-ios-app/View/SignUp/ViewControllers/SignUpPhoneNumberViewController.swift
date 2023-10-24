//
//  SignUpPhoneNumberViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/02.
//

import UIKit
import Then
import SnapKit
import RxSwift

class SignUpPhoneNumberViewController: UIViewController, ViewModelBindableType {

    var disposeBag = DisposeBag()
    var viewModel: SignUpPhoneNumberViewModel!
    
    private let baseView = UIView().then {
        $0.backgroundColor = .white_FFFFFF
    }
    
    private let stepIndicator = StepIndicator(.third)
    
    private let titleLabel = UILabel().then {
        $0.text = "마지막으로\n휴대전화 번호를 인증해주세요."
        $0.font = .font_b(20)
        $0.numberOfLines = 0
    }
    
    private let phoneNumberBlock = UIView()
    
    private let phoneNumberLabel = UILabel().then {
        $0.text = "휴대전화 번호"
        $0.font = .font_b(15)
        $0.textColor = .gray_161616
    }
    
    private let phoneNumberTextField = DefaultTextField(
        placeHolder: "'-' 빼고 숫자만 입력",
        keyboardType: .numberPad
    ).then {
        $0.keyboardType = .numberPad
    }
    
    private let sendAuthNumberButton = CustomButton("인증번호 발송", type: .auth).then {
        $0.isEnabled = false
    }
    
    private let authNumberBlock = UIView().then {
        $0.isHidden = true
    }
    
    private let authNumberTextField = DefaultTextField(
        placeHolder: "인증번호 6자리",
        keyboardType: .numberPad)
    
    private let timeLabel = UILabel().then {
        $0.font = .font_r(12)
        $0.textColor = .crimson_FF5841
    }
    
    private let validateAuthNumberButton = CustomButton(type: .auth).then {
        $0.setTitle("인증번호 확인", for: .normal)
        $0.isEnabled = false
    }
    
    private let authNumberLabel = UILabel().then {
        $0.text = "인증번호를 발송했습니다. (유효시간 3분)\n인증번호가 오지 않는다면, 통신사 스팸 차단 서비스 혹은 휴대폰 번호 차단 여부를 확인해주세요."
        $0.font = .font_r(12)
        $0.textColor = .gray_555555
        $0.numberOfLines = 0
    }
    
    private let agreementBlock = UIView().then {
        $0.backgroundColor = .gray_161616
    }
    
    private lazy var tableView = UITableView().then {
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
        $0.dataSource = self
        $0.register(with: TermsCell.self)
    }
    
    private let button = CustomButton("회원가입", type: .bottom)
    
    func bindViewModel() {
        // MARK: - Buttons
        sendAuthNumberButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.viewModel.sendAuthNumber()
                owner.showAuthNumberBlock()
        }.disposed(by: rx.disposeBag)

        validateAuthNumberButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.viewModel.validateAuthNumber(
                    phoneNumber: owner.phoneNumberTextField.text,
                    authNumber: owner.authNumberTextField.text
                )
        }.disposed(by: rx.disposeBag)

        button.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.viewModel.signUp()
            }.disposed(by: rx.disposeBag)
        
        // MARK: - TextFields
        phoneNumberTextField.rx.controlEvent(.editingChanged)
            .withUnretained(self)
            .bind { owner, _ in
                let formattedString = owner.viewModel.formatPhoneNumberString(owner.phoneNumberTextField.text)
                owner.phoneNumberTextField.text = formattedString
                owner.viewModel.checkPhoneNumberState(formattedString)
            }.disposed(by: rx.disposeBag)
        
        authNumberTextField.rx.controlEvent(.editingChanged)
            .withUnretained(self)
            .bind { owner, _ in
                let formattedString = owner.authNumberTextField.text?.prefixString(6)
                owner.authNumberTextField.text = formattedString
               owner.viewModel.checkAuthNumberState(formattedString)
            }.disposed(by: rx.disposeBag)
        
        // MARK: - ViewModel
        viewModel.phoneNumberAvailableState
            .withUnretained(self)
            .bind { owner, state in
                switch state {
                case .cannotCheck:
                    owner.sendAuthNumberButton.setTitle("인증번호 발송", for: .normal)
                    owner.sendAuthNumberButton.isEnabled = false
                case .canCheck:
                    owner.sendAuthNumberButton.setTitle("인증번호 발송", for: .normal)
                    owner.sendAuthNumberButton.isEnabled = true
                case .sent:
                    owner.sendAuthNumberButton.setTitle("재전송", for: .normal)
                case .available:
                    owner.sendAuthNumberButton.setTitle("인증완료", for: .normal)
                    owner.sendAuthNumberButton.isEnabled = false
                }
            }.disposed(by: self.disposeBag)

        viewModel.authNumberState
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { owner, state in
                switch state {
                case .cannotCheck:
                    owner.validateAuthNumberButton.isEnabled = false
                case .canCheck:
                    owner.validateAuthNumberButton.isEnabled = true
                case .authorized:
                    owner.authNumberBlock.isHidden = true
                }
            }.disposed(by: self.disposeBag)
        
        viewModel.stringLeftSeconds
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { owner, timeLeft in
                owner.timeLabel.text = timeLeft
            }.disposed(by: self.disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTapped()
        
        setNavigationBar()
        setUI()
        setConstraints()
    }
    
    private func setNavigationBar() {
        navigationItem.titleView = NavigationTitleView(title: "회원가입")
        navigationItem.leftBarButtonItem = NavigationLeftBarButtonItem(
            type: .back,
            viewController: self
        )
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
            timeLabel,
            validateAuthNumberButton,
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
        
        timeLabel.snp.makeConstraints {
            $0.centerY.equalTo(authNumberTextField)
            $0.trailing.equalTo(authNumberTextField.snp.trailing).offset(-10)
        }
        
        validateAuthNumberButton.snp.makeConstraints {
            $0.top.bottom.equalTo(authNumberTextField)
            $0.leading.equalTo(authNumberTextField.snp.trailing).offset(4)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(94)
        }
        
        authNumberLabel.snp.makeConstraints {
            $0.top.equalTo(authNumberTextField.snp.bottom).offset(4)
            $0.leading.equalTo(authNumberTextField.snp.leading)
            $0.trailing.equalTo(validateAuthNumberButton.snp.trailing)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func setupAgreementBlock() {
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview() // TODO: 나중에 수정
        }
    }
    
    private func showAuthNumberBlock() {
        authNumberBlock.isHidden = false
        authNumberTextField.text = ""
        validateAuthNumberButton.isEnabled = false
        timeLabel.text = "03:00"
    }
}

extension SignUpPhoneNumberViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return SignUpTerms.allCases.count
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as TermsCell
        let terms = SignUpTerms.allCases[indexPath.row]
        cell.configure(title: terms.title, termsText: terms.content)
        
        // FIXME: index 방식 변경
        switch indexPath.row {
        case 0:
            cell.checkBoxButtonTap
                .withUnretained(self)
                .bind { owner, _ in
                    owner.viewModel.switchAgreeToTermsOfServiceTermsOfUse()
                }.disposed(by: cell.disposeBag)
            
        case 1:
            cell.checkBoxButtonTap
                .withUnretained(self)
                .bind { owner, _ in
                    owner.viewModel.switchAgreeToPersonalInformation()
                }.disposed(by: cell.disposeBag)
        default: break
        }
        
        cell.arrowDownButtonTap
            .withUnretained(self)
            .bind { owner, _ in
                cell.switchHiddenState()
                owner.tableView.reloadData()
            }.disposed(by: cell.disposeBag)
        
        return cell
    }
    
}
