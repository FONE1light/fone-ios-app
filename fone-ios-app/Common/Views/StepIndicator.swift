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
        setupUI(index: index, totalCount: totalCount)
    }
    
    /// xib에서 사용 시 필요한 초기화 함수
    /// - top, leading constraints만 잡으면 되고(trailing, bottom 필요 없음) textField의 높이를 바꾸고 싶다면 textFieldHeight로 조정해야 함
    func xibInit(index: Int, totalCount: Int) {
        setupUI(index: index, totalCount: totalCount)
    }
    
    private func setupUI(index: Int, totalCount: Int) {
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
