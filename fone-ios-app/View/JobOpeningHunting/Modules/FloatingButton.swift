//
//  FloatingButton.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/9/23.
//

import UIKit

class FloatingButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
    }
    
    private let pencilImage = UIImage(named: "Edit_Pencil_01")
    private let profileImage = UIImage(named: "profile")
    
    private func setupUI() {
        cornerRadius = 24
        backgroundColor = .red_CE0B39
        translatesAutoresizingMaskIntoConstraints = false
        setImage(pencilImage, for: .normal)
        applyShadow(shadowType: .shadowBt)
    }
    
    func changeMode(_ type: JobSegmentType) {
        switch type {
        case .jobOpening:
            setImage(pencilImage, for: .normal)
        case .profile:
            setImage(profileImage, for: .normal)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
