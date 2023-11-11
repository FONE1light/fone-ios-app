//
//  FloatingButton.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/9/23.
//

import UIKit
import Then
import SnapKit

class FloatingButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
        setConstraints()
    }
    
    private let pencilImage = UIImage(named: "Edit_Pencil_01")
    private let profileImage = UIImage(named: "profile")
    
    
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
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.cornerRadius = 6
        $0.backgroundColor = .red_CE0B39
        $0.isHidden = true
        $0.distribution = .fillProportionally
    }

    
    private func setupUI() {
        cornerRadius = 24
        backgroundColor = .red_CE0B39
        translatesAutoresizingMaskIntoConstraints = false
        setImage(pencilImage, for: .normal)
        applyShadow(shadowType: .shadowBt)
        
        addSubview(stackView)
        setupStackView()
    }
    
    private func setupStackView() {
        let divider = Divider(height: 1, color: .red_F43663)
        
        [actorButton, divider, staffButton].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    private func setConstraints() {
        stackView.snp.makeConstraints {
            $0.bottom.equalTo(self.snp.top).offset(-6)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(106)
            $0.height.equalTo(81)
        }
    }
    
    func changeMode(_ type: JobSegmentType) {
        switch type {
        case .jobOpening:
            setImage(pencilImage, for: .normal)
            actorButton.setTitle("배우 모집", for: .normal)
            staffButton.setTitle("스태프 모집", for: .normal)
        case .profile:
            setImage(profileImage, for: .normal)
            actorButton.setTitle("배우 등록", for: .normal)
            staffButton.setTitle("스태프 등록", for: .normal)
        }
    }
    
    func switchHiddenState() {
        stackView.isHidden = !stackView.isHidden
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
