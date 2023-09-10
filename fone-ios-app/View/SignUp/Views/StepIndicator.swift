//
//  StepIndicator.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/08/23.
//

import UIKit

enum SignUpStep {
    case first
    case second
    case third
}

class StepIndicator: UIStackView {

    private let currentStep = UIView().then {
        $0.backgroundColor = .red_CE0B39
        $0.cornerRadius = 3
    }
    
    private let otherStep1 = UIView().then {
        $0.backgroundColor = .gray_D9D9D9
        $0.cornerRadius = 3
    }
    
    private let otherStep2 = UIView().then {
        $0.backgroundColor = .gray_D9D9D9
        $0.cornerRadius = 3
    }
    
    init(_ step: SignUpStep) {
        super.init(frame: .zero)
        setUI(step: step)
        setConstraints()
    }
    
    private func setUI(step: SignUpStep) {
        self.axis = .horizontal
        self.spacing = 8
        
        var steps = [otherStep1, otherStep2]
        
        switch step {
        case .first:
            steps.insert(currentStep, at: 0)
        case .second:
            steps.insert(currentStep, at: 1)
        case .third:
            steps.insert(currentStep, at: 2)
        }
        
        steps.forEach { self.addArrangedSubview($0) }
    }
    
    private func setConstraints() {
        
        currentStep.snp.makeConstraints {
            $0.height.equalTo(6)
            $0.width.equalTo(18)
        }
        
        otherStep1.snp.makeConstraints {
            $0.size.equalTo(6)
        }
        
        otherStep2.snp.makeConstraints {
            $0.size.equalTo(6)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CurrentStep: UIView {
    
}

class OtherStep: UIView {
    
}
