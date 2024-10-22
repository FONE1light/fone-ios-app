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
    @IBOutlet weak var genderIrrelevantButton: CustomButton!
    @IBOutlet weak var maleButton: CustomButton!
    @IBOutlet weak var femaleButton: CustomButton!
    @IBOutlet weak var ageClearButton: CustomButton!
    @IBOutlet weak var startAgeLabel: UILabel!
    @IBOutlet weak var startAgeButton: UIButton!
    @IBOutlet weak var endAgeLabel: UILabel!
    @IBOutlet weak var endAgeButton: UIButton!
    @IBOutlet weak var careerClearButton: CustomButton!
    @IBOutlet weak var careerSelectionBlock: CareerSelectionBlock!
    @IBOutlet weak var nextButton: UIButton!
    
    var viewModel: RecruitConditionInfoViewModel!
    var jobType = Job.actor
    private var gender = GenderType.IRRELEVANT
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setButtons()
    }
    
    func bindViewModel() {
        setUI()
        
        genderIrrelevantButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                guard !owner.genderIrrelevantButton.isActivated else {
                    return
                }
                
                owner.genderIrrelevantButton.isActivated = true
                owner.maleButton.isActivated = false
                owner.femaleButton.isActivated = false
                
                owner.gender = .IRRELEVANT
            }.disposed(by: rx.disposeBag)
        
        maleButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.maleButton.isActivated = !owner.maleButton.isActivated
                
                if owner.maleButton.isActivated {
                    owner.gender = .MAN
                    owner.genderIrrelevantButton.isActivated = false
                    owner.checkAllActivated()
                } else {
                    owner.genderIrrelevantButton.isActivated = true
                }
            }.disposed(by: rx.disposeBag)
        
        femaleButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.femaleButton.isActivated = !owner.femaleButton.isActivated
                
                if owner.femaleButton.isActivated {
                    owner.gender = .WOMAN
                    owner.genderIrrelevantButton.isActivated = false
                    owner.checkAllActivated()
                } else {
                    owner.genderIrrelevantButton.isActivated = true
                }
            }.disposed(by: rx.disposeBag)
        
        ageClearButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.ageClearButton.isActivated = true
                owner.startAgeLabel.text = "시작"
                owner.startAgeLabel.textColor = .gray_9E9E9E
                owner.endAgeLabel.text = "끝"
                owner.endAgeLabel.textColor = .gray_9E9E9E
            }.disposed(by: rx.disposeBag)
        
        careerClearButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.careerSelectionBlock.clearButtonIsActivated.onNext(true)
                owner.careerSelectionBlock.deselectAll()
            }.disposed(by: rx.disposeBag)
        
        nextButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                var casting = owner.castingTextField.textField?.text
                let domainsArray = owner.viewModel.selectedDomains.value as? [Domain]
                var domains: [String]? = nil
                if owner.jobType == .staff {
                    casting = nil
                    domains = domainsArray?.map { $0.serverName }
                }
                let numberOfRecruits = Int(owner.numberTextField.textField?.text ?? "")
                let gender = owner.gender.serverName
                let ageMinString = owner.startAgeLabel.text?.replacingOccurrences(of: "세", with: "") ?? ""
                let ageMin = Int(ageMinString)
                let ageMaxString = owner.endAgeLabel.text?.replacingOccurrences(of: "세", with: "") ?? ""
                let ageMax = Int(ageMaxString)
                let careers = owner.careerSelectionBlock.selectedCareers.isEmpty ? [CareerType.IRRELEVANT.rawValue] : owner.careerSelectionBlock.selectedCareers
                let recruitConditionInfo = RecruitConditionInfo(casting: casting, domains: domains, numberOfRecruits: numberOfRecruits, gender: gender, ageMin: ageMin, ageMax: ageMax, careers: careers)
                owner.viewModel.validateRole(recruitConditionInfo: recruitConditionInfo)
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
        navigationItem.titleView = NavigationTitleView(title: "\(jobType.koreanName) 모집하기")
        navigationItem.leftBarButtonItem = NavigationLeftBarButtonItem(
            type: .back,
            viewController: self
        )
    }
    
    private func setUI() {
        stepIndicator.xibInit(index: 2, totalCount: 7)
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
        careerSelectionBlock.clearButtonIsActivated
            .bind(to: careerClearButton.rx.isActivated).disposed(by: rx.disposeBag)
    }
    
    private func setButtons() {
        genderIrrelevantButton.xibInit("성별무관", type: .clear)
        maleButton.xibInit("남자", type: .auth)
        maleButton.isActivated = false
        femaleButton.xibInit("여자", type: .auth)
        femaleButton.isActivated = false
        ageClearButton.xibInit("연령무관", type: .clear)
        careerClearButton.xibInit("경력무관", type: .clear)
        nextButton.applyShadow(shadowType: .shadowBt)
        
        let startHandler: UIActionHandler = { [weak self] (action: UIAction) in
            self?.startAgeLabel.text = action.title
            self?.startAgeLabel.textColor = .gray_161616
            self?.ageClearButton.isActivated = false
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
            self?.ageClearButton.isActivated = false
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
    
    private func checkAllActivated() {
        if maleButton.isActivated && femaleButton.isActivated {
            genderIrrelevantButton.isActivated = true
            maleButton.isActivated = false
            femaleButton.isActivated = false
            gender = .IRRELEVANT
        }
    }
}
