//
//  RecruitContactInfoViewController.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 12/3/23.
//

import UIKit

class RecruitContactInfoViewController: UIViewController, ViewModelBindableType {
    @IBOutlet weak var stepIndicator: StepIndicator!
    @IBOutlet weak var managerTextField: LabelTextField!
    @IBOutlet weak var emailTextField: LabelTextField!
    @IBOutlet weak var registerButton: UIButton!
    
    var viewModel: RecruitContactInfoViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    func bindViewModel() {
        setNavigationBar()
        
        registerButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                let recruitContactInfo = RecruitContactInfo(manager: owner.managerTextField.textField?.text, email: owner.emailTextField.textField?.text)
                owner.viewModel.createJobOpenings(recruitContactInfo: recruitContactInfo)
            }.disposed(by: rx.disposeBag)
    }
    
    private func setNavigationBar() {
        guard let jobType = viewModel.jobType else { return }
        navigationItem.titleView = NavigationTitleView(title: "\(jobType.koreanName) 모집하기")
        navigationItem.leftBarButtonItem = NavigationLeftBarButtonItem(
            type: .back,
            viewController: self
        )
    }
    
    private func setUI() {
        stepIndicator.xibInit(index: 5, totalCount: 6)
        managerTextField.xibInit(label: "담당자", placeholder: "", textFieldHeight: 44, isRequired: true, textFieldLeadingOffset: 62)
        emailTextField.xibInit(label: "이메일", placeholder: "", textFieldHeight: 44, isRequired: true, textFieldLeadingOffset: 62)
        registerButton.applyShadow(shadowType: .shadowBt)
    }
}
