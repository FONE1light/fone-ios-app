//
//  NavigationRightBarButton.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/17.
//

import UIKit

enum RightBarButtonType {
    case notification
}

extension RightBarButtonType {
    /// 색상
    ///
    /// `image`면 `tintColor`가 적용되고 `customView`면 적용되지 않음
    var tintColor: UIColor? {
        switch self {
        case .notification: return .gray_9E9E9E
        default: return nil
        }
    }
    
    /// 버튼 이미지
    var image: UIImage? {
        switch self {
        case .notification: return UIImage(named: "bell")
        default: return nil
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
            let notificationViewController = NotiViewController()
            viewController?.navigationController?.pushViewController(notificationViewController, animated: true)
        default: return
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
