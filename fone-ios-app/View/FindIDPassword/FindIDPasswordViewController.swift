//
//  FindIDPasswordViewController.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/08/07.
//

import UIKit

class FindIDPasswordViewController: UIViewController, ViewModelBindableType {
    var viewModel: FindIDPasswordViewModel!
    
    @IBOutlet weak var backButton: UIButton!
    
    func bindViewModel() {
        backButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { _ in
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: rx.disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
