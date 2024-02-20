//
//  OptionsBottomSheetViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 2/20/24.
//

import UIKit
import PanModal

protocol Options {
    var title: String? { get }
    var serverParameter: [String]? { get }
}

class OptionsBottomSheetViewController: UIViewController, ViewModelBindableType {
    
    var longFormHeight: PanModalHeight {
        shortFormHeight
    }
    
    var shortFormHeight: PanModalHeight {
        return .intrinsicHeight
    }
    
    var viewModel: OptionsBottomSheetViewModel!
    
    private let titleLabel = UILabel().then {
        $0.font = .font_m(12)
        $0.textColor = .gray_9E9E9E
    }
    
    private let list = UISortButtonStackView()
    
    func bindViewModel() {
        titleLabel.text = viewModel.title
        
        list.setup(
            viewModel.list,
            selectedOption: viewModel.selectedItem,
            completionHandler: viewModel.completionHandler
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setConstraints()
    }
    
    private func setupUI() {
        view.backgroundColor = .white_FFFFFF
        
        view.cornerRadius = 10
        
        [
            titleLabel,
            list
        ]
            .forEach { view.addSubview($0) }
    }
    
    private func setConstraints() {
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28)
            $0.leading.trailing.equalToSuperview().inset(22)
        }
        
        list.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(22)
            $0.bottom.equalToSuperview().offset(-40)
        }
    }
}

extension OptionsBottomSheetViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        nil
    }
    
    // SceneCoordinator의 close가 호출되지 않고 dismiss 되는 경우(=항목 누르지 않고 dimmedView 눌러서 닫는 경우) currentVC가 업데이트 되지 않으므로 아래 함수에서 수동으로 업데이트
    func panModalDidDismiss() {
        guard let sceneCoordinator = viewModel.sceneCoordinator as? SceneCoordinator,
              let presentingVC = sceneCoordinator.currentVC.presentingViewController
        else { return }
        
        guard sceneCoordinator.currentVC != presentingVC.sceneViewController else { return }
        
        sceneCoordinator.currentVC = presentingVC.sceneViewController
    }
}
