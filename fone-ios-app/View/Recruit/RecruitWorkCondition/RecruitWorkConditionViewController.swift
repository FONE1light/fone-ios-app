//
//  RecruitWorkConditionViewController.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 12/7/23.
//

import UIKit

class RecruitWorkConditionViewController: UIViewController, ViewModelBindableType {
    @IBOutlet weak var stepIndicator: StepIndicator!
    @IBOutlet weak var startDateButton: UIButton!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateButton: UIButton!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    @IBOutlet weak var salaryTypeButton: UIButton!
    @IBOutlet weak var salaryTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func weekDayTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        sender.setTitleColor(sender.isSelected ? .red_CE0B39 : .gray_9E9E9E, for: .normal)
        sender.backgroundColor = sender.isSelected ? .red_FFEBF0 : .gray_EEEFEF
        let selectedDay = WeekDay.getWeekDayType(from: sender.titleLabel?.text)?.rawValue ?? ""
        if !selectedDays.contains(selectedDay), sender.isSelected {
            selectedDays.append(selectedDay)
        } else if selectedDays.contains(selectedDay), !sender.isSelected {
            if let index = selectedDays.firstIndex(of: selectedDay) {
                selectedDays.remove(at: index)
            }
        }
    }
    var viewModel: RecruitWorkConditionViewModel!
    var selectedDays: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setupDatePicker()
    }
    
    func bindViewModel() {
        setNavigationBar()
        
        startDateButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                let vc = DatePickerViewController()
                vc.resultLabel = owner.startDateLabel
                vc.delegate = self
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: false)
            }.disposed(by: rx.disposeBag)
        
        endDateButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                let vc = DatePickerViewController()
                vc.resultLabel = owner.endDateLabel
                vc.delegate = self
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: false)
            }.disposed(by: rx.disposeBag)
        
        salaryTypeButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
            }.disposed(by: rx.disposeBag)
        
        salaryTextField.rx.text.orEmpty
            .filter { $0 != "" }
            .map({ salary in
                return salary.replacingOccurrences(of: ",", with: "")
            })
            .map { $0.insertComma }
            .bind(to: salaryTextField.rx.text)
            .disposed(by: rx.disposeBag)
        
        nextButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                let workingStartDate = owner.startDateLabel.text?.dateServerFormat
                let workingEndDate = owner.endDateLabel.text?.dateServerFormat
                let workingStartTime = owner.startTimeTextField.text
                let workingEndTime = owner.endTimeTextField.text
                let salary = Int(owner.salaryTextField.text?.replacingOccurrences(of: ",", with: "") ?? "")
                let recruitWorkConditionInfo = RecruitWorkConditionInfo(workingCity: "서울특별시", workingDistrict: "강남구", workingStartDate: workingStartDate, workingEndDate: workingEndDate, selectedDays: owner.selectedDays, workingStartTime: workingStartTime, workingEndTime: workingEndTime, salaryType: SalaryType.HOURLY.rawValue, salary: salary) // TODO: 시-구 API 추후 개발 예정, 급여유형
                owner.viewModel.moveToNextStep(recruitWorkConditionInfo: recruitWorkConditionInfo)
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
        stepIndicator.xibInit(index: 3, totalCount: 6)
        nextButton.applyShadow(shadowType: .shadowBt)
    }
    
    private func setupDatePicker() {
        let startDatePicker = UIDatePicker()
        startDatePicker.datePickerMode = .time
        startDatePicker.preferredDatePickerStyle = .wheels
        startDatePicker.locale = Locale(identifier: "ko-KR")
        startDatePicker.addTarget(self, action: #selector(getStartTime), for: .valueChanged)
        startTimeTextField.inputView = startDatePicker
        
        let endDatePicker = UIDatePicker()
        endDatePicker.datePickerMode = .time
        endDatePicker.preferredDatePickerStyle = .wheels
        endDatePicker.locale = Locale(identifier: "ko-KR")
        endDatePicker.addTarget(self, action: #selector(getEndTime), for: .valueChanged)
        endTimeTextField.inputView = endDatePicker
    }
    
    @objc func getStartTime(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        startTimeTextField.text = formatter.string(from: sender.date)
    }
    
    @objc func getEndTime(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        endTimeTextField.text = formatter.string(from: sender.date)
    }
}

extension RecruitWorkConditionViewController: DateTimePickerVCDelegate {
    func updateDateTime(_ dateTime: String, label: UILabel?) {
        label?.text = dateTime
        label?.textColor = .gray_161616
    }
}
