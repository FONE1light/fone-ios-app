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

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var userJobLabel: UILabel!
    @IBOutlet weak var letterCountedTextView: LetterCountedTextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setUI()
    }
    
    func bindViewModel() {
        
    }
    
    private func setNavigationBar() {
        navigationItem.titleView = NavigationTitleView(title: "신고하기")
        navigationItem.rightBarButtonItem = NavigationRightBarButtonItem(
            type: .close,
            viewController: self
        )
    }
    
    private func setUI() {
        letterCountedTextView.xibInit(placeholder: placeholder, textViewHeight: 92, maximumLetterCount: 500)
//        nextButton.applyShadow(shadowType: .shadowBt)
    }
}
