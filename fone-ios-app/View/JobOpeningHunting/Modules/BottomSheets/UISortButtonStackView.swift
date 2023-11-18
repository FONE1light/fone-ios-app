//
//  UISortButtonStackView.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/16/23.
//

import UIKit
import SnapKit
import Then

class UISortButtonStackView: UIStackView {
    
    private var buttons: [UISortButton] = []
    
    private let completionHandler: ((String) -> Void)?
    
    init(
        _ options: [JobOpeningSortOptions],
        selectedOption: JobOpeningSortOptions?,
        completionHandler: ((String) -> Void)? = nil
    ) {
        self.completionHandler = completionHandler
        
        super.init(frame: .zero)
        
        options.forEach {
            let button = UISortButton()
            button.setTitle($0.title, for: .normal)
            
            if $0.title == selectedOption?.title {
                button.isSelected = true
            }
    
            buttons.append(button)
        }
        
        setupUI()
        setConstraints()
        
        bindAction()
    }
    
    private func setupUI() {
        axis = .vertical
        distribution = .fillEqually
        
        buttons.forEach { addArrangedSubview($0) }
    }
    
    private func setConstraints() {
        snp.makeConstraints {
            $0.height.equalTo(42 * buttons.count)
        }
    }
    
    private func bindAction() {
        buttons.forEach { button in
            button.rx.tap
                .withUnretained(self)
                .bind { owner, _ in
                    owner.buttons
                        .filter { $0.isSelected == true }
                        .forEach { $0.isSelected = false }
                    button.isSelected = true

                    guard let selectedText = button.titleLabel?.text else { return }
                    owner.completionHandler?(selectedText)
                }.disposed(by: rx.disposeBag)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
