//
//  EmailLoginViewController.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/09/02.
//

import UIKit

class EmailLoginViewController: UIViewController, ViewModelBindableType {
    var viewModel: EmailLoginViewModel!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var findIDPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func bindViewModel() {
        closeButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { _ in
                self.viewModel.sceneCoordinator.close(animated: true)
            })
            .disposed(by: rx.disposeBag)
        
        findIDPasswordButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { _ in
                self.viewModel.moveToFindIDPassword()
            })
            .disposed(by: rx.disposeBag)
    }
}
