//
//  FakeLaunchScreenViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 3/24/24.
//

import UIKit

class FakeLaunchScreenViewController: UIViewController {
    
    private let coordinator: SceneCoordinator
    
    private let imageView = UIImageView(image: UIImage(resource: .logoFilmOne))

    init(sceneCoordinator: SceneCoordinator) {
        coordinator = sceneCoordinator
        super.init(nibName: nil, bundle: nil)
    }
      
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 'Attempt to present * on whose view is not in the window hierarchy.'
        //  에러 방지 위해 viewDidAppear에서 실행
        showAlert()
    }
    
    private func setupUI() {
        view.backgroundColor = .black_000000
        
        view.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(80)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FakeLaunchScreenViewController {
    
    private func showAlert() {
        let terminateApp: ((UIAlertAction) -> Void) = { _ in
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                exit(0)
            }
        }
        
        let navigateToAppStore: ((UIAlertAction) -> Void) = { _ in
            print("APPSTORE로 이동")
        }
        
//        let alert = UIAlertController
//            .createTwoButtonPopup(
//                title: "앱 버전이 다릅니다.\n보다 좋은 서비스를 위해 업데이트 해주세요",
//                leftButtonText: "닫기",
//                rightButtonText: "업데이트",
//                leftButtonHandler: terminateApp,
//                rightButtonHandler: navigateToAppStore
//            )
//        
//        present(alert, animated: true)
    }
}
    

/// VC에 하려는 이유: present 사용 위해
/// 거슬리는 이유: xib init 만들어줘야 하고 그러면 Main.swift가 생겨야 함
///
/// VM에 하려는 이유: Main.swift 안 만들기 위해
/// 거슬리는 이유: 만들어야 함
///
/// FakeLaunchViewController를 Main에 넣으려 함. 단, 이때 sceneCoordinator를 받을 것이 아니므로(Main.swift 만들고 싶지 않음) 화면이동, 데이터 저장 기능 모두 없고 단순하게 뷰만 그려져 있는 화면이 되어야 편함. -> viewController를 조작하자
