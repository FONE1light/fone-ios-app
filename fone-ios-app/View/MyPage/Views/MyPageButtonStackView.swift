//
//  MyPageButtonStackView.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/17.
//

import UIKit
import SnapKit
import RxCocoa

class MyPageButtonStackView: UIStackView {
    private let scrapView = UIView()
    private let scrapContentView = MyPageButtonStackViewContentView(type: .scrap)
    private let scrapButton = UIButton()
    var scrapButtonTap: ControlEvent<Void> {
        scrapButton.rx.tap
    }
    
    private let verticalBar = UIView().then {
        $0.backgroundColor = .gray_D9D9D9
    }
    private let saveView = UIView()
    private let saveContentView = MyPageButtonStackViewContentView(type: .save)
    private let saveButton = UIButton()
    var saveButtonTap: ControlEvent<Void> {
        saveButton.rx.tap
    }
    
    init(width: CGFloat, height: CGFloat) {
        super.init(frame: .zero)
        
        setupUI()
        setupButtonStackView()
        setConstraints(width: width, height: height)
    }
    
    private func setupUI() {
        axis = .horizontal
        backgroundColor = .gray_F8F8F8
        cornerRadius = 5
        distribution = .equalCentering
        alignment = .center
    }
    
    private func setupButtonStackView() {
        [scrapView, verticalBar, saveView]
            .forEach { addArrangedSubview($0) }
        
        [scrapContentView, scrapButton]
            .forEach { scrapView.addSubview($0) }
        
        [saveContentView, saveButton]
            .forEach { saveView.addSubview($0) }
    }
    
    private func setConstraints(width: CGFloat, height: CGFloat) {
        let buttonWidth = ( width - 16 * 2 - 1 ) / 2
        
        verticalBar.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(28)
        }
        
        [scrapView, saveView].forEach { view in
            view.snp.makeConstraints {
                $0.width.equalTo(buttonWidth)
                $0.height.equalTo(height)
            }
        }
        
        [scrapContentView, saveContentView].forEach { contentView in
            contentView.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
        
        [scrapButton, saveButton].forEach { button in
            button.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
