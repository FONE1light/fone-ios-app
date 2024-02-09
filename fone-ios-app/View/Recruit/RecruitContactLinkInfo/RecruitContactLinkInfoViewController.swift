//
//  RecruitContactLinkInfoViewController.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2/9/24.
//

import UIKit

class RecruitContactLinkInfoViewController: UIViewController, ViewModelBindableType {
    @IBOutlet weak var stepIndicator: StepIndicator!
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
        
        nextButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.viewModel.moveToNextStep()
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
