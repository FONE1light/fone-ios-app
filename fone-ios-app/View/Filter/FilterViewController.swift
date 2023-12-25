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
    
    @IBOutlet weak var genderClearButton: CustomButton!
    @IBOutlet weak var genderSelectionBlock: SelectionBlock!
    
    @IBOutlet weak var confirmButton: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        genderClearButton.xibInit("전체선택", type: .clear)
        confirmButton.xibInit("보러가기", type: .bottom)
        
        genderSelectionBlock.setSelections(GenderType.allCases)
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
