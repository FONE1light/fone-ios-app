//
//  ReportViewController.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 4/8/24.
//

import UIKit

class ReportViewController: UIViewController, ViewModelBindableType {
    var viewModel: ReportViewModel!
    let placeholder = "혹시 다른 불쾌한 일을 겪으셨나요?\n신고 사유를 자세히 입력해주세요. (선택사항)"

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var userJobLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profileReportButton: UIButton!
    @IBOutlet weak var jobOpeningReportButton: UIButton!
    @IBOutlet weak var profileInconveniences: UIView!
    @IBOutlet weak var jobOpeningInconveniences: UIView!
    @IBOutlet weak var letterCountedTextView: LetterCountedTextView!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBAction func checkInconveniences(_ sender: UIButton) {
        sender.isSelected.toggle()
        sender.setImage(UIImage(named: "checkboxes_off"), for: .normal)
        sender.setImage(UIImage(named: "checkboxes_on"), for: .selected)
        if sender.isSelected {
            guard viewModel.inconveniences.count < 5 else {
                sender.isSelected.toggle()
                return
            }
            viewModel.inconveniences.append(sender.tag)
        } else {
            if let index = viewModel.inconveniences.firstIndex(of: sender.tag) {
                viewModel.inconveniences.remove(at: index)
            }
        }
        submitButton.setEnabled(isEnabled: viewModel.inconveniences.count > 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func bindViewModel() {
        setUI()
        
        letterCountedTextView.textView?.rx.text
            .map { $0 == self.placeholder ? "" : $0 }
            .withUnretained(self)
            .bind { owner, text in
                if let text, !text.isEmpty {
                    let tag = owner.viewModel.reportType == .profile ? 7 : 18
                    if let detailsButton = owner.view.viewWithTag(tag) as? UIButton {
                        detailsButton.isSelected = true
                        detailsButton.setImage(UIImage(named: "checkboxes_on"), for: .selected)
                        if !owner.viewModel.inconveniences.contains(tag) {
                            owner.viewModel.inconveniences.append(tag)
                        }
                    }
                }
            }.disposed(by: rx.disposeBag)
        
        keyboardHeight()
            .bind(to: viewModel.keyboardHeightBehaviorSubject)
            .disposed(by: rx.disposeBag)
        
        viewModel.keyboardHeightBehaviorSubject
            .withUnretained(self)
            .subscribe(onNext: { (owner, keyboardHeight) in
                owner.scrollView.contentInset.bottom = keyboardHeight
                owner.scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
            }).disposed(by: rx.disposeBag)
        
        closeButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.viewModel.sceneCoordinator.close(animated: true)
            }.disposed(by: rx.disposeBag)
        
        submitButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.viewModel.submitReport(details: owner.letterCountedTextView.text)
            }.disposed(by: rx.disposeBag)
    }
    
    private func setUI() {
        setUserInfo()
        setReportType(type: viewModel.from ?? .profile)
        letterCountedTextView.xibInit(placeholder: placeholder, textViewHeight: 92, maximumLetterCount: 500)
    }
    
    private func setUserInfo() {
        profileImageView.kf.setImage(with: URL(string: viewModel.profileImageURL ?? ""))
        nicknameLabel.text = viewModel.nickname
        userJobLabel.text = viewModel.userJob
    }
    
    private func setActivated(button: UIButton, activated: Bool) {
        let color = activated ? UIColor.red_F43663 : UIColor.gray_D9D9D9
        button.borderColor = color
        button.setTitleColor(color, for: .normal)
    }
    
    private func setReportType(type: JobSegmentType) {
        viewModel.reportType = type
        viewModel.inconveniences = []
        for tag in 1...20 {
            let view = view.viewWithTag(tag)
            if let button = view as? UIButton {
                button.isSelected = false
            }
        }
        let profileSelected = type == .profile
        let jobOpeningSelected = type == .jobOpening
        setActivated(button: profileReportButton, activated: profileSelected)
        setActivated(button: jobOpeningReportButton, activated: jobOpeningSelected)
        profileInconveniences.isHidden = !profileSelected
        jobOpeningInconveniences.isHidden = !jobOpeningSelected
        letterCountedTextView.textView?.text = ""
    }
}
