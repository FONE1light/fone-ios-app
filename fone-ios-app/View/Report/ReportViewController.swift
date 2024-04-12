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
    @IBOutlet weak var profileReportButton: UIButton!
    @IBOutlet weak var jobOpeningReportButton: UIButton!
    @IBOutlet weak var profileInconveniences: UIView!
    @IBOutlet weak var jobOpeningInconveniences: UIView!
    @IBOutlet weak var letterCountedTextView: LetterCountedTextView!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    func bindViewModel() {
        setUserInfo()
        
        profileReportButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.setActivated(button: owner.profileReportButton, activated: true)
                owner.setActivated(button: owner.jobOpeningReportButton, activated: false)
                owner.profileInconveniences.isHidden = false
                owner.jobOpeningInconveniences.isHidden = true
            }.disposed(by: rx.disposeBag)
        
        jobOpeningReportButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.setActivated(button: owner.profileReportButton, activated: false)
                owner.setActivated(button: owner.jobOpeningReportButton, activated: true)
                owner.profileInconveniences.isHidden = true
                owner.jobOpeningInconveniences.isHidden = false
            }.disposed(by: rx.disposeBag)
        
        closeButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.viewModel.sceneCoordinator.close(animated: true)
            }.disposed(by: rx.disposeBag)
    }
    
    private func setUI() {
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
}
