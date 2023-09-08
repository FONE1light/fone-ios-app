//
//  EmailSignUpViewController.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/09/02.
//

import UIKit

class EmailSignUpViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: EmailSignUpViewModel!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordEyeButton: UIButton!
    
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
        
        passwordEyeButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { _ in
                self.eyeButtonTapped()
            })
            .disposed(by: rx.disposeBag)
    }
    
    func eyeButtonTapped() {
        passwordTextField.isSecureTextEntry.toggle()
        passwordEyeButton.isSelected.toggle()
        let eyeImage = passwordEyeButton.isSelected ? UIImage(named: "show_filled") : UIImage(named: "hide_filled")
        passwordEyeButton.setImage(eyeImage, for: .normal)
    }
}
