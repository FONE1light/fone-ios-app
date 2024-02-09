//
//  RecruitContactInfoViewController.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 12/3/23.
//

import UIKit
import RxSwift

class RecruitContactInfoViewController: UIViewController, ViewModelBindableType {
    @IBOutlet weak var stepIndicator: StepIndicator!
    @IBOutlet weak var managerTextField: LabelTextField!
    @IBOutlet weak var emailTextField: LabelTextField!
    @IBOutlet weak var registerButton: UIButton!
    
    var viewModel: RecruitContactInfoViewModel!
    var jobType = Job.actor
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar()
        setUI()
    }
    
    func bindViewModel() {
        
        registerButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { owner, _ in
                let recruitContactInfo = RecruitContactInfo(manager: owner.managerTextField.textField?.text, email: owner.emailTextField.textField?.text)
                owner.viewModel.createJobOpenings(recruitContactInfo: recruitContactInfo)
            }.disposed(by: rx.disposeBag)
    }
    
    private func setNavigationBar() {
        navigationItem.titleView = NavigationTitleView(title: "\(jobType.koreanName) 모집하기")
        navigationItem.leftBarButtonItem = NavigationLeftBarButtonItem(
            type: .back,
            viewController: self
        )
    }
    
    private func setUI() {
        stepIndicator.xibInit(index: 6, totalCount: 7)
        managerTextField.xibInit(label: "담당자", placeholder: "", textFieldHeight: 44, isRequired: true, textFieldLeadingOffset: 62)
        emailTextField.xibInit(label: "이메일", placeholder: "", textFieldHeight: 44, isRequired: true, textFieldLeadingOffset: 62)
        registerButton.applyShadow(shadowType: .shadowBt)
    }
}
