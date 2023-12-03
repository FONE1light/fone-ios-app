//
//  RecruitConditionInfoViewController.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 11/26/23.
//

import UIKit

class RecruitConditionInfoViewController: UIViewController {
    @IBOutlet weak var stepIndicator: StepIndicator!
    @IBOutlet weak var castingTextField: LabelTextField!
    @IBOutlet weak var numberTextField: LabelTextField!
    @IBOutlet weak var startAgeLabel: UILabel!
    @IBOutlet weak var startAgeButton: UIButton!
    @IBOutlet weak var endAgeLabel: UILabel!
    @IBOutlet weak var endAgeButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setUI()
        setButtons()
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
        castingTextField.xibInit(label: "모집배역", placeholder: "ex) 30대 중반 경찰", textFieldHeight: 44, isRequired: true, textFieldLeadingOffset: 76)
        numberTextField.xibInit(label: nil, placeholder: nil, textFieldLeadingOffset: 0, textFieldKeyboardType: .numberPad)
    }
    
    private func setButtons() {
        nextButton.applyShadow(shadowType: .shadowBt)
        
        let startHandler: UIActionHandler = { [weak self] (action: UIAction) in
            self?.startAgeLabel.text = action.title
            self?.startAgeLabel.textColor = .gray_161616
        }
        var startActions: [UIAction] = []
        for index in 1...80 {
            let action = UIAction(title: "\(index)세", handler: startHandler)
            startActions.append(action)
        }
        startAgeButton.menu = UIMenu(title: "",
                                     options: .singleSelection,
                                     children: startActions)
        startAgeButton.showsMenuAsPrimaryAction = true
        
        let endHandler: UIActionHandler = { [weak self] (action: UIAction) in
            self?.endAgeLabel.text = action.title
            self?.endAgeLabel.textColor = .gray_161616
        }
        var endActions: [UIAction] = []
        for index in 1...80 {
            let action = UIAction(title: "\(index)세", handler: endHandler)
            endActions.append(action)
        }
        endAgeButton.menu = UIMenu(title: "",
                                     options: .singleSelection,
                                     children: endActions)
        endAgeButton.showsMenuAsPrimaryAction = true
    }
}
