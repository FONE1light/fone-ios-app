//
//  RecruitConditionInfoViewController.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 11/26/23.
//

import UIKit

class RecruitConditionInfoViewController: UIViewController, ViewModelBindableType {
    @IBOutlet weak var stepIndicator: StepIndicator!
    @IBOutlet weak var castingTextField: LabelTextField!
    @IBOutlet weak var domainView: UIView!
    @IBOutlet weak var domainContentView: DomainContentView!
    @IBOutlet weak var domainSelectButton: UIButton!
    @IBOutlet weak var numberTextField: LabelTextField!
    @IBOutlet weak var startAgeLabel: UILabel!
    @IBOutlet weak var startAgeButton: UIButton!
    @IBOutlet weak var endAgeLabel: UILabel!
    @IBOutlet weak var endAgeButton: UIButton!
    @IBOutlet weak var careerSelectionBlock: CareerSelectionBlock!
    @IBOutlet weak var nextButton: UIButton!
    
    var viewModel: RecruitConditionInfoViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setButtons()
    }
    
    func bindViewModel() {
        setNavigationBar()
        
        nextButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                let casting = owner.castingTextField.textField?.text
                let domainsArray = owner.viewModel.selectedDomains.value
                let domains = domainsArray.map { $0.name }
                let numberOfRecruits = Int(owner.numberTextField.textField?.text ?? "")
                let gender = GenderType.IRRELEVANT.serverName // FIXME
                let ageMinString = owner.startAgeLabel.text?.replacingOccurrences(of: "세", with: "") ?? ""
                let ageMin = Int(ageMinString)
                let ageMaxString = owner.endAgeLabel.text?.replacingOccurrences(of: "세", with: "") ?? ""
                let ageMax = Int(ageMaxString)
                let career = owner.careerSelectionBlock.selectedItem.value as? CareerType ?? .NEWCOMER
                let recruitConditionInfo = RecruitConditionInfo(casting: casting, domains: domains, numberOfRecruits: numberOfRecruits, gender: gender, ageMin: ageMin, ageMax: ageMax, career: career.rawValue)
                owner.viewModel.moveToNextStep(recruitConditionInfo: recruitConditionInfo)
            }.disposed(by: rx.disposeBag)
        
        domainSelectButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                let popup = DomainSelectionPopupViewController(selectionRelay: owner.viewModel.selectedDomains)
                
                popup.modalPresentationStyle = .overFullScreen
                
                owner.present(popup, animated: false)
                
            }.disposed(by: rx.disposeBag)
        
        viewModel.selectedDomains
            .withUnretained(self)
            .bind { owner, domains in
                guard let domains = domains as? [Domain] else { return }
                owner.domainContentView.setupDomainStackView(with: domains)
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
        stepIndicator.xibInit(index: 1, totalCount: 6)
        switch viewModel.jobType {
        case .actor:
            castingTextField.isHidden = false
            domainView.isHidden = true
            castingTextField.xibInit(label: "모집배역", placeholder: "ex) 30대 중반 경찰", textFieldHeight: 44, isRequired: true, textFieldLeadingOffset: 76)
        case .staff:
            castingTextField.isHidden = true
            domainView.isHidden = false
        default: break
        }
        
        numberTextField.xibInit(label: nil, placeholder: nil, textFieldLeadingOffset: 0, textFieldKeyboardType: .numberPad)
        careerSelectionBlock.xibInit()
        careerSelectionBlock.collectionView.allowsMultipleSelection = true
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
