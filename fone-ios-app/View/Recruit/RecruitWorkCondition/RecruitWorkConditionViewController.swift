//
//  RecruitWorkConditionViewController.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 12/7/23.
//

import UIKit

class RecruitWorkConditionViewController: UIViewController, ViewModelBindableType {
    @IBOutlet weak var stepIndicator: StepIndicator!
    @IBOutlet weak var nextButton: UIButton!
    
    var viewModel: RecruitWorkConditionViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar()
        setUI()
    }
    
    func bindViewModel() {
        
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
        stepIndicator.xibInit(index: 3, totalCount: 6)
        nextButton.applyShadow(shadowType: .shadowBt)
    }
}
