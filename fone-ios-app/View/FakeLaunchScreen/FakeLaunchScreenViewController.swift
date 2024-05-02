//
//  FakeLaunchScreenViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 3/24/24.
//

import UIKit

class FakeLaunchScreenViewController: UIViewController {
    
    private let coordinator: SceneCoordinator
    private let appStoreUrl = "https://apps.apple.com/us/app/%EC%97%90%ED%94%84%EC%9B%90/id1662193361"
    
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
        
        imageView.contentMode = .scaleAspectFit
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
            self.appStoreUrl.openURL()
        }
        
        let alert = UIAlertController
            .createTwoButtonPopup(
                title: "앱 버전이 다릅니다.\n보다 좋은 서비스를 위해 업데이트 해주세요",
                leftButtonText: "닫기",
                rightButtonText: "업데이트",
                leftButtonHandler: terminateApp,
                rightButtonHandler: navigateToAppStore
            )
        
        present(alert, animated: true)
    }
}
