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
    let bottomSheetView = ReportBottomSheet()
    
    func bindViewModel() {
        
        bind()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setConstraints()
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
                let reportViewModel = ReportViewModel(sceneCoordinator: self.viewModel.sceneCoordinator, profileImageURL: self.viewModel.profileImageURL, nickname: self.viewModel.nickname, userJob: self.viewModel.userJob, from: self.viewModel.from, typeId: self.viewModel.typeId)
                let reportScene = Scene.report(reportViewModel)
                self.viewModel.sceneCoordinator.transition(to: reportScene, using: .fullScreenModal, animated: true)
            }.disposed(by: bottomSheetView.rx.disposeBag)
    }
}
