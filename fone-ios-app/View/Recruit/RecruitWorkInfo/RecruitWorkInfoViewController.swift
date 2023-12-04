//
//  RecruitWorkInfoViewController.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 12/4/23.
//

import UIKit

class RecruitWorkInfoViewController: UIViewController {
    @IBOutlet weak var stepIndicator: StepIndicator!
    @IBOutlet weak var produceTextField: LabelTextField!
    @IBOutlet weak var titleTextField: LabelTextField!
    @IBOutlet weak var directorTextField: LabelTextField!
    
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
        stepIndicator.xibInit(index: 1, totalCount: 6)
        produceTextField.xibInit(label: "제작", placeholder: "제작 주체(회사, 학교, 단체 등의 이름)", textFieldHeight: 44, isRequired: true, textFieldLeadingOffset: 54)
        titleTextField.xibInit(label: "제목", placeholder: "작품 제목", textFieldHeight: 44, isRequired: true, textFieldLeadingOffset: 54)
        directorTextField.xibInit(label: "연출", placeholder: "연출자 이름", textFieldHeight: 44, isRequired: true, textFieldLeadingOffset: 54)
    }
}
