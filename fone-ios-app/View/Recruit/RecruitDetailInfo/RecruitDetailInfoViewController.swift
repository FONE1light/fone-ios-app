//
//  RecruitDetailInfoViewController.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 12/3/23.
//

import UIKit

class RecruitDetailInfoViewController: UIViewController, ViewModelBindableType {
    @IBOutlet weak var stepIndicator: StepIndicator!
    @IBOutlet weak var detailTextView: LetterCountedTextView!
    @IBOutlet weak var nextButton: UIButton!
    
    var viewModel: RecruitDetailInfoViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setUI()
    }
    
    func bindViewModel() {
        nextButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                let recruitDetailInfo = RecruitDetailInfo(details: owner.detailTextView.textView?.text)
                owner.viewModel.moveToNextStep(recruitDetailInfo: recruitDetailInfo)
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
        stepIndicator.xibInit(index: 4, totalCount: 6)
        detailTextView.xibInit(placeholder: "외부 연락처 공개 등 부적절한 내용이 포함된 게시글은 게시가 제한될 수 있어요.", textViewHeight: 172, maximumLetterCount: 500)
        nextButton.applyShadow(shadowType: .shadowBt)
    }
}
