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
}

extension LeftBarButtonType {
    /// 버튼 이미지
    var image: UIImage? {
        switch self {
        case .back: return UIImage(named: "arrow_left24")
        case .close: return UIImage(named: "close_MD")
        }
    }
    
    /// 버튼 클릭 시 실행할 동작
    func action(_ viewController: UIViewController?) {
        switch self {
        case .back:
            viewController?.navigationController?.popViewController(animated: true)
        case .close:
            viewController?.dismiss(animated: true)
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
        viewController: UIViewController?
    ) {
        super.init()
        
        initUI(type)
        bindAction(type, viewController)
    }
    
    private func initUI(_ type: LeftBarButtonType?) {
        image = type?.image
        tintColor = .black_000000
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
