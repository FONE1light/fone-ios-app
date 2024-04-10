//
//  ReportBottomSheetViewController.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 4/10/24.
//

import UIKit
import SnapKit
import RxSwift

class ReportBottomSheetViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: ReportBottomSheetViewModel!
    private var disposeBag = DisposeBag()
    
    let bottomSheetView = ReportBottomSheet()
    
    func bindViewModel() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setConstraints()
        
        bind()
    }
    
    
    private func setupUI() {
        view.backgroundColor = .white_FFFFFF
        view.addSubview(bottomSheetView)
    }
    
    private func setConstraints() {
        bottomSheetView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func bind() {
        bottomSheetView.buttonTap
            .bind { _ in
                print("제발제ㅐ랴ㅓㅔㅇ자레ㅏㅈㄹㅇ니ㅏ제발")
            }.disposed(by: rx.disposeBag)
    }
}
