//
//  FloatingStackView.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/15/23.
//

import UIKit
import Then
import SnapKit
import RxCocoa

class FloatingStackView: UIStackView {
    
    private let actorButton = UIButton().then {
        $0.setTitle("배우 모집", for: .normal)
        $0.setTitleColor(.white_FFFFFF, for: .normal)
        $0.titleLabel?.font = .font_m(14)
    }
    
    private let staffButton = UIButton().then {
        $0.setTitle("스태프 모집", for: .normal)
        $0.setTitleColor(.white_FFFFFF, for: .normal)
        $0.titleLabel?.font = .font_m(14)
    }
    
    var actorButtonTap: ControlEvent<Void> {
        actorButton.rx.tap
    }
    
    var staffButtonTap: ControlEvent<Void> {
        staffButton.rx.tap
    }
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
        setConstraints()
    }
    
    private func setupUI() {
        axis = .vertical
        cornerRadius = 6
        backgroundColor = .red_CE0B39
        distribution = .fillProportionally
        
        let divider = Divider(height: 1, color: .red_F43663)
        
        [actorButton, divider, staffButton].forEach {
            addArrangedSubview($0)
        }
    }
    
    private func setConstraints() {
        snp.makeConstraints {
            $0.width.equalTo(106)
            $0.height.equalTo(81)
        }
    }
    
    func changeMode(_ type: JobSegmentType) {
        switch type {
        case .jobOpening:
            actorButton.setTitle("배우 모집", for: .normal)
            staffButton.setTitle("스태프 모집", for: .normal)
        case .profile:
            actorButton.setTitle("배우 등록", for: .normal)
            staffButton.setTitle("스태프 등록", for: .normal)
        }
    }
    
    
    func switchHiddenState() {
        isHidden = !isHidden
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
