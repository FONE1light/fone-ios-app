//
//  FilterViewController.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 12/25/23.
//

import UIKit

class FilterViewController: UIViewController, ViewModelBindableType {
    var viewModel: FilterViewModel!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var confirmButton: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confirmButton.xibInit("보러가기", type: .bottom)
    }
    
    func bindViewModel() {
        closeButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.viewModel.sceneCoordinator.close(animated: true)
            }.disposed(by: rx.disposeBag)
        
        confirmButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.viewModel.sceneCoordinator.close(animated: true)
            }.disposed(by: rx.disposeBag)
    }
}
