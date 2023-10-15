//
//  NavigationLeftBarButtonItem.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/07.
//

import UIKit
import SnapKit
import RxSwift

enum LeftBarButtonType {
    case back
    case close
    case myPage
    case chat
    case home
}

extension LeftBarButtonType {
    /// 색상
    ///
    /// `image`면 `tintColor`가 적용되고 `customView`면 적용되지 않음
    var tintColor: UIColor? {
        switch self {
        case .back, .close: return .gray_555555
        default: return nil
        }
    }
    /// 버튼 이미지
    var image: UIImage? {
        switch self {
        case .back: return UIImage(named: "arrow_left24")
        case .close: return UIImage(named: "close_MD")
        default: return nil
        }
    }
    
    var customView: UIView? {
        switch self {
        case .myPage:
            let label = UILabel().then {
                $0.text = "나의 F-ONE"
                $0.textColor = .gray_161616
                $0.font = .font_b(19)
            }
            return label
        case .chat:
            let label = UILabel().then {
                $0.text = "채팅"
                $0.textColor = .gray_161616
                $0.font = .font_b(19)
            }
            return label
        case .home:
            let label = UILabel().then {
                $0.text = "F-ONE"
                $0.textColor = .gray_161616
                $0.font = .font_b(22)
            }
            return label
        default: return nil
        }
    }
    
    /// 버튼 클릭 시 실행할 동작
    func action(_ viewController: UIViewController?) {
        switch self {
        case .back:
            viewController?.navigationController?.popViewController(animated: true)
        case .close:
            viewController?.dismiss(animated: true)
        default: return
        }
    }
}

/// `navigationItem.leftBarButtonItem`에 설정할 BarButton 클래스
class NavigationLeftBarButtonItem: UIBarButtonItem {
    
    /// `navigationItem.leftBarButtonItem`에 설정할 BarButton 클래스
    /// - Parameters:
    ///   - type: 필요한 BarButton의 `LeftBarButtonType`
    ///   - viewController: 해당 클래스를 사용할 ViewController. 버튼 클릭 액션 연결 위해 필요
    init(
        type: LeftBarButtonType? = nil,
        viewController: UIViewController? = nil
    ) {
        super.init()
        
        initUI(type)
        bindAction(type, viewController)
    }
    
    private func initUI(_ type: LeftBarButtonType?) {
        image = type?.image
        customView = type?.customView
        tintColor = type?.tintColor
    }
    
    private func bindAction(_ type: LeftBarButtonType?, _ viewController: UIViewController?) {
        rx.tap.withUnretained(self)
            .bind { _, _ in
                type?.action(viewController)
            }.disposed(by: rx.disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
