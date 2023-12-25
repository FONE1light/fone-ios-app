//
//  JobOpeningSortBottomSheetViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 12/25/23.
//

import UIKit
import PanModal

enum JobOpeningSortOptions: CaseIterable {
    /// 최신순
    case recent
    /// 조회순
    case view
    /// 마감임박순
    case deadline
    
    var title: String? {
        switch self {
        case .recent: "최신순"
        case .view: "조회순"
        case .deadline: "마감임박순"
        }
    }
    
    var serverName: String? {
        // TODO: 구현
        "\(self)"
    }
    
    static func getType(title: String?) -> JobOpeningSortOptions? {
        JobOpeningSortOptions.allCases.filter { $0.title == title }.first
    }
}

class JobOpeningSortBottomSheetViewController: UIViewController, ViewModelBindableType {
    
    var longFormHeight: PanModalHeight {
        shortFormHeight
    }

    var shortFormHeight: PanModalHeight {
            return .intrinsicHeight
    }
    
    var viewModel: JobOpeningSortBottomSheetViewModel!
    
    private let titleLabel = UILabel().then {
        $0.font = .font_m(12)
        $0.textColor = .gray_9E9E9E
        $0.text = "정렬"
    }
    
    private let list = UISortButtonStackView()
    
    func bindViewModel() {
        list.setup(
                viewModel.list,
                selectedOption: viewModel.selectedItem,
                completionHandler: viewModel.completionHandler
                )
        
//        view.layoutIfNeeded()
            
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
        
        view.snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width)
        }
    }
}

extension JobOpeningSortBottomSheetViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        nil
    }
    
//    func panModalWillDismiss() {
//        (viewModel.sceneCoordinator as? SceneCoordinator)?.currentVC = self.sceneViewController
//    }
    
    
}
