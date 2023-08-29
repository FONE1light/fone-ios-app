//
//  QuestionViewController.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/08/29.
//

import UIKit

class QuestionViewController: UIViewController, ViewModelBindableType {
    var viewModel: QuestionViewModel!
    
    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func bindViewModel() {
        closeButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { _ in
                self.viewModel.sceneCoordinator.close(animated: true)
            })
            .disposed(by: rx.disposeBag)
    }
}
