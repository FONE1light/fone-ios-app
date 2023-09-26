//
//  TagList.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/25.
//

import UIKit

class TagList: UIStackView {
    
    private var tagList: [Tag] = []
    
    init() {
        super.init(frame: .zero)
    }
    
    /// 해당 함수를 호출해서 값 세팅, 초기화.
    func setValues(job: Job, intersts: [Interest]) {
        tagList.append(Tag(job))
        intersts.forEach { interest in
            tagList.append(Tag(interest))
        }
        
        setupUI()
        
    }
    
    private func setupUI() {
        axis = .horizontal
        spacing = 6
        
        tagList.forEach {
            self.addArrangedSubview($0)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
