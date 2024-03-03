//
//  RecruitContactLinkInfoViewController.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2/9/24.
//

import UIKit

class RecruitContactLinkInfoViewController: UIViewController, ViewModelBindableType {
    @IBOutlet weak var stepIndicator: StepIndicator!
    @IBOutlet weak var contactTypeButton: UIButton!
    @IBOutlet weak var contactTypeLabel: UILabel!
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    var viewModel: RecruitContactLinkInfoViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false // 스와이프백 안 되게
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true // 스와이프백 다시 가능하게
    }
    
    func bindViewModel() {
        setNavigationBar()
        
        contactTypeButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.viewModel.showContactTypeBottomSheet()
            }.disposed(by: rx.disposeBag)
        
        viewModel.selectedContactTypeOption
            .withUnretained(self)
            .subscribe(onNext: { owner, contactType in
                owner.viewModel.contactType = contactType
                owner.contactTypeLabel.text = contactType.title
                owner.contactTypeLabel.textColor = .gray_161616
                owner.contactTextField.placeholder = contactType == .email ? "이메일 주소를 첨부할 수 있어요" : "링크를 첨부할 수 있어요"
            }).disposed(by: rx.disposeBag)
        
        nextButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                let recruitContactLinkInfo = RecruitContactLinkInfo(contact: owner.contactTextField.text ?? "", contactMethod: owner.viewModel.contactType?.serverParameter ?? "")
                owner.viewModel.validateContactLink(recruitContactLinkInfo: recruitContactLinkInfo)
            }.disposed(by: rx.disposeBag)
    }
    
    private func setNavigationBar() {
        guard let jobType = viewModel.jobType else { return }
        navigationItem.titleView = NavigationTitleView(title: "\(jobType.koreanName) 모집하기")
        navigationItem.leftBarButtonItem = NavigationLeftBarButtonItem(
            type: .backWithAlert,
            viewController: self
        )
    }
    
    private func setUI() {
        stepIndicator.xibInit(index: 0, totalCount: 7)
        nextButton.applyShadow(shadowType: .shadowBt)
    }
}
