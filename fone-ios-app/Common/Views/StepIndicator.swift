//
//  StepIndicator.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/18/23.
//

import UIKit
import Then
import SnapKit

class StepIndicator: UIStackView {
    
    /// index: 0부터 시작, totalCount: 전체 개수
    ///
    /// 최대 index는 totalCount-1
    init(index: Int, totalCount: Int) {
        super.init(frame: .zero)
        setUI(index: index, totalCount: totalCount)
    }
    
    func setUI(index: Int, totalCount: Int) {
        axis = .horizontal
        spacing = 8
        
        var steps: [UIView] = []
        
        for _ in 0..<totalCount-1 {
            steps.append(OtherStep())
        }
        
        steps.insert(CurrentStep(), at: index)
        steps.forEach { self.addArrangedSubview($0) }
    }
    
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class CurrentStep: UIView {
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
        setConstraints()
    }
    
    private func setupUI() {
        backgroundColor = .red_CE0B39
        cornerRadius = 3
    }
    
    private func setConstraints() {
        snp.makeConstraints {
            $0.height.equalTo(6)
            $0.width.equalTo(18)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class OtherStep: UIView {
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
        setConstraints()
    }
    
    private func setupUI() {
        backgroundColor = .gray_D9D9D9
        cornerRadius = 3
    }
    
    private func setConstraints() {
        snp.makeConstraints {
            $0.size.equalTo(6)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
