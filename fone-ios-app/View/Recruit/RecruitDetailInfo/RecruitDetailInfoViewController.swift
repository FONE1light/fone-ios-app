//
//  RecruitDetailInfoViewController.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 12/3/23.
//

import UIKit
import RxSwift

class RecruitDetailInfoViewController: UIViewController, ViewModelBindableType {
    @IBOutlet weak var stepIndicator: StepIndicator!
    @IBOutlet weak var detailTextView: LetterCountedTextView!
    @IBOutlet weak var nextButton: UIButton!
    
    var viewModel: RecruitDetailInfoViewModel!
    
    let placeholder = "외부 연락처 공개 등 부적절한 내용이 포함된 게시글은 게시가 제한될 수 있어요."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    func bindViewModel() {
        setNavigationBar()
        
        nextButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { owner, _ in
                let details = owner.detailTextView.textView?.text == owner.placeholder ? "" : owner.detailTextView.textView?.text
                let recruitDetailInfo = RecruitDetailInfo(details: details)
                owner.viewModel.validateSummary(recruitDetailInfo: recruitDetailInfo)
//                owner.viewModel.moveToNextStep(recruitDetailInfo: recruitDetailInfo)
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
        detailTextView.xibInit(placeholder: placeholder, textViewHeight: 172, maximumLetterCount: 500)
        nextButton.applyShadow(shadowType: .shadowBt)
    }
}
