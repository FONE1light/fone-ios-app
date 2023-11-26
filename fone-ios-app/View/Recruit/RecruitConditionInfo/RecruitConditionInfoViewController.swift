//
//  RecruitConditionInfoViewController.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 11/26/23.
//

import UIKit

class RecruitConditionInfoViewController: UIViewController {
    @IBOutlet weak var stepIndicator: StepIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setUI()
        
    }
    
    private func setNavigationBar() {
        navigationItem.titleView = NavigationTitleView(title: "배우 모집하기")
        navigationItem.leftBarButtonItem = NavigationLeftBarButtonItem(
            type: .back,
            viewController: self
        )
    }
    
    private func setUI() {
        stepIndicator.setUI(index: 1, totalCount: 6)
    }
}
