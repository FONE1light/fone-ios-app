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
    @IBOutlet weak var selectedTabLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var idTabButton: UIButton!
    @IBOutlet weak var passwordTabButton: UIButton!
    
    
    func bindViewModel() {
        backButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { _ in
                self.navigationController?.popViewController(animated: true)
            }).disposed(by: rx.disposeBag)
        
        idTabButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { _ in
                self.idTabButton.setTitleColor(.red_CE0B39, for: .normal)
                self.passwordTabButton.setTitleColor(.gray_9E9E9E, for: .normal)
                self.view.layoutIfNeeded()
                UIView.animate(withDuration: 0.3, delay: 0, animations: {
                    self.selectedTabLeadingConstraint.constant = 0
                    self.view.layoutIfNeeded()
                })
            }).disposed(by: rx.disposeBag)
        
        passwordTabButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { _ in
                self.idTabButton.setTitleColor(.gray_9E9E9E, for: .normal)
                self.passwordTabButton.setTitleColor(.red_CE0B39, for: .normal)
                self.view.layoutIfNeeded()
                UIView.animate(withDuration: 0.3, delay: 0, animations: {
                    self.selectedTabLeadingConstraint.constant = self.idTabButton.frame.width
                    self.view.layoutIfNeeded()
                })
            }).disposed(by: rx.disposeBag)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
