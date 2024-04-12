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
    @IBOutlet weak var letterCountedTextView: LetterCountedTextView!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    func bindViewModel() {
        setUserInfo()
        
        closeButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.viewModel.sceneCoordinator.close(animated: true)
            }.disposed(by: rx.disposeBag)
    }
    
    private func setUI() {
        letterCountedTextView.xibInit(placeholder: placeholder, textViewHeight: 92, maximumLetterCount: 500)
        submitButton.applyShadow(shadowType: .shadowBt)
    }
    
    private func setUserInfo() {
        profileImageView.kf.setImage(with: URL(string: viewModel.profileImageURL ?? ""))
        nicknameLabel.text = viewModel.nickname
        userJobLabel.text = viewModel.userJob
    }
}
