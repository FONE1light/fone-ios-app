//
//  JobOpeningSortBottomSheet.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/5/23.
//

import UIKit
import SnapKit
import Then

enum JobOpeningSortOptions {
    /// 최신순
    case recent
    /// 조회순
    case view
    /// 마감임박순
    case deadline
    
    var title: String? {
        switch self {
        case .recent: "최신순"
        case .view: "조회순"
        case .deadline: "마감임박순"
        }
    }
}

class JobOpeningSortBottomSheet: UIView {

    private let options: [JobOpeningSortOptions] = [
        .recent,
        .view,
        .deadline
    ]
    
    private var selectedOption: JobOpeningSortOptions?
    
    private let titleLabel = UILabel().then {
        $0.font = .font_m(12)
        $0.textColor = .gray_9E9E9E
        $0.text = "정렬"
    }
    
//    private let contentLabel = UILabel().then {
//        $0.font = .font_r(14)
//        $0.textColor = .gray_555555
//        $0.numberOfLines = 1
//    }
    
    // TODO: list - StackView 혹은 >>TableView<<
    private let list = UIView().then {
        $0.backgroundColor = .yellow
    }
    init(
        selectedItem: JobOpeningSortOptions?
    ) {
        super.init(frame: .zero)
        
        setUI()
        setConstraints()
        
        selectedOption = selectedItem
        
    
            
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUI() {
        backgroundColor = .white_FFFFFF
        
        [
            titleLabel,
            list
        ]
            .forEach { addSubview($0) }
    }
    
    private func setConstraints() {

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28)
            $0.leading.trailing.equalToSuperview().inset(22)
//            $0.height.equalTo(26)
        }
        
//        contentLabel.snp.makeConstraints {
//            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
//            $0.centerX.equalToSuperview()
////            $0.height.equalTo(20)
//        }
        
        list.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(44)
            $0.leading.trailing.equalToSuperview().inset(22)
            $0.bottom.equalToSuperview().offset(-40)
            $0.height.equalTo(48)
        }
        
        snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width)
        }
    }
}
