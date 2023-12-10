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
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func weekDayTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        sender.setTitleColor(sender.isSelected ? .red_CE0B39 : .gray_9E9E9E, for: .normal)
        sender.backgroundColor = sender.isSelected ? .red_FFEBF0 : .gray_EEEFEF
    }
    var viewModel: RecruitWorkConditionViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setUI()
        setupDatePicker()
    }
    
    func bindViewModel() {
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
