//
//  HomeViewController.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/09/11.
//

import UIKit

class HomeViewController: UIViewController, ViewModelBindableType {
    var viewModel: HomeViewModel!
    var hasViewModel = false
    
    @IBOutlet weak var notiButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func bindViewModel() {
        
        guard !hasViewModel else { return }
        
        notiButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                let notiScene = Scene.notification
                owner.viewModel.sceneCoordinator.transition(to: notiScene, using: .push, animated: true)
            }.disposed(by: rx.disposeBag)
    }
}
