//
//  NavigationRightBarButton.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/17.
//

import UIKit

enum RightBarButtonType {
    case notification
    case close
    case more
}

extension RightBarButtonType {
    /// 색상
    ///
    /// `image`면 `tintColor`가 적용되고 `customView`면 적용되지 않음
    var tintColor: UIColor? {
        switch self {
        case .notification, .more: return .gray_9E9E9E
        case .close: return .gray_555555
        }
    }
    
    /// 버튼 이미지
    var image: UIImage? {
        switch self {
        case .notification: return UIImage(named: "bell")
        case .close: return UIImage(named: "close_MD")
        case .more: return UIImage(named: "more_Vertical")
        }
    }
    
    var customView: UIView? {
        switch self {
        default: return nil
        }
    }
    
    /// 버튼 클릭 시 실행할 동작
    func action(_ viewController: UIViewController?) {
        switch self {
        case .notification:
            if let vc = viewController as? any ViewModelBindableType {
                guard let viewModel = vc.viewModel as? CommonViewModel else { return }
                viewModel.sceneCoordinator.transition(to: Scene.notification, using: .push, animated: true)
            }
        case .close:
            if let vc = viewController as? any ViewModelBindableType {
                guard let viewModel = vc.viewModel as? CommonViewModel else { return }
                viewModel.sceneCoordinator.close(animated: true)
            }
        case .more:
            if let vc = viewController as? any ViewModelBindableType {
                guard let viewModel = vc.viewModel as? CommonViewModel else { return }
                if let reportableVC = vc as? ReportableType {
                    var from = JobSegmentType.jobOpening
                    var typeId = -1
                    if let jobOpeningVC = reportableVC as? JobOpeningDetailViewController {
                        from = .jobOpening
                        typeId = jobOpeningVC.viewModel.jobOpeningDetail?.id ?? -1
                    } else if let profileVC = reportableVC as? JobHuntingDetailViewController {
                        from = .profile
                        typeId = profileVC.viewModel.jobHuntingDetail.id ?? -1
                    }
                    let reportBottomSheetViewModel = ReportBottomSheetViewModel(sceneCoordinator: viewModel.sceneCoordinator, profileImageURL: reportableVC.profileImageURL, nickname: reportableVC.nickname, userJob: reportableVC.userJob, from: from, typeId: typeId)
                    viewModel.sceneCoordinator.transition(to: .reportBottomSheet(reportBottomSheetViewModel), using: .customModal, animated: true)
                }
            }
        }
    }
}

/// `navigationItem.rightBarButtonItem`에 설정할 BarButton 클래스
class NavigationRightBarButtonItem: UIBarButtonItem {
    
    /// `navigationItem.rightBarButtonItem`에 설정할 BarButton 클래스
    /// - Parameters:
    ///   - type: 필요한 BarButton의 `RightBarButtonType`
    ///   - viewController: 해당 클래스를 사용할 ViewController. 버튼 클릭 액션 연결 위해 필요
    init(
        type: RightBarButtonType? = nil,
        viewController: UIViewController? = nil
    ) {
        super.init()
        
        initUI(type)
        bindAction(type, viewController)
    }
    
    private func initUI(_ type: RightBarButtonType?) {
        image = type?.image
        customView = type?.customView
        tintColor = type?.tintColor
    }
    
    private func bindAction(_ type: RightBarButtonType?, _ viewController: UIViewController?) {
        rx.tap.withUnretained(self)
            .bind { _, _ in
                type?.action(viewController)
            }.disposed(by: rx.disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
