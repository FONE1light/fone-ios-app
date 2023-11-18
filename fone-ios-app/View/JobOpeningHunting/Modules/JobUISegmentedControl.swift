//
//  JobUISegmentedControl.swift
//  fone-ios-app
//
//  Created by 여나경 on 11/4/23.
//

import UIKit
import SnapKit

/// 구인구직 탭에서 표시할 UISegmentedControl 타입
/// - 노출 순서는 allCases 순서를 따르므로 정의된 순서대로 화면에 노출됨.
enum JobSegmentType: CaseIterable {
    case jobOpening
    case profile
    
    var title: String? {
        switch self {
        case .jobOpening: "모집"
        case .profile: "프로필"
        }
    }
    
    var index: Int? {
        JobSegmentType.allCases.firstIndex(of: self)
    }
    
    // TODO: 바텀시트 완성, 노출 확인
    var bottomSheet: UIView? {
        switch self {
        case .jobOpening:
            return JobOpeningSortBottomSheet(
                list: [.recent, .view, .deadline],
                selectedItem: .recent
            ) { stringSelectedItem in
                // TODO: Dismiss
            }
        case .profile:
            return JobOpeningSortBottomSheet(
                list: [.recent, .view],
                selectedItem: .view
            )
        }
    }
    
    // 필요 시 FloatingButtonStackView 추가
}

class JobUISegmentedControl: UISegmentedControl {

    var _selectedSegmentType: JobSegmentType?
    var selectedSegmentType: JobSegmentType? {
        get {
            let segment = JobSegmentType.allCases.filter {
                $0.index == selectedSegmentIndex
            }
            return segment.first
        }
        
        set(value) {
            selectedSegmentIndex = value?.index ?? 0
            _selectedSegmentType = value
        }
    }
    
    init() {
        let titles = JobSegmentType.allCases.map { $0.title ?? "" }
        super.init(items: titles)
        
        selectedSegmentTintColor = .red_CE0B39
        
        setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.gray_9E9E9E
            ],
            for: .normal
        )
        
        setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.white_FFFFFF
            ],
            for: .selected
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
