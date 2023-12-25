////
////  JobOpeningSortBottomSheet.swift
////  fone-ios-app
////
////  Created by 여나경 on 11/5/23.
////
//
//import UIKit
//import SnapKit
//import Then
//
//enum JobOpeningSortOptions: CaseIterable {
//    /// 최신순
//    case recent
//    /// 조회순
//    case view
//    /// 마감임박순
//    case deadline
//    
//    var title: String? {
//        switch self {
//        case .recent: "최신순"
//        case .view: "조회순"
//        case .deadline: "마감임박순"
//        }
//    }
//    
//    var serverName: String? {
//        // TODO: 구현
//        "\(self)"
//    }
//    
//    static func getType(title: String?) -> JobOpeningSortOptions? {
//        JobOpeningSortOptions.allCases.filter { $0.title == title }.first
//    }
//}
//
//class JobOpeningSortBottomSheet: UIView {
//    
//    private var selectedOption: JobOpeningSortOptions?
//    
//    private let titleLabel = UILabel().then {
//        $0.font = .font_m(12)
//        $0.textColor = .gray_9E9E9E
//        $0.text = "정렬"
//    }
//    
//    private let list: UISortButtonStackView?
//    private let completionHandler: ((String) -> Void)?
//    
//    init(
//        list: [JobOpeningSortOptions],
//        selectedItem: JobOpeningSortOptions?,
//        completionHandler: ((String) -> Void)? = nil
//    ) {
//        self.completionHandler = { selectedText in
//            completionHandler?(selectedText)
//            print(selectedText)
//            // TODO: Dismiss - BottomSheetViewController를 만드는 곳에서부터 해야할지도.
//            print("dismiss")
//        }
//        
//        self.list = UISortButtonStackView(
////            list,
////            selectedOption: selectedItem,
////            completionHandler: self.completionHandler
//        )
//        
//        super.init(frame: .zero)
//        
//        setUI()
//        setConstraints()
//        
//        selectedOption = selectedItem
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    
//    private func setUI() {
//        backgroundColor = .white_FFFFFF
//        cornerRadius = 10
//        
//        guard let list = list else { return }
//        [
//            titleLabel,
//            list
//        ]
//            .forEach { addSubview($0) }
//    }
//    
//    private func setConstraints() {
//
//        titleLabel.snp.makeConstraints {
//            $0.top.equalToSuperview().offset(28)
//            $0.leading.trailing.equalToSuperview().inset(22)
////            $0.height.equalTo(26)
//        }
//        
//        list?.snp.makeConstraints {
//            $0.top.equalTo(titleLabel.snp.bottom)
//            $0.leading.trailing.equalToSuperview().inset(22)
//            $0.bottom.equalToSuperview().offset(-40)
//        }
//        
//        snp.makeConstraints {
//            $0.width.equalTo(UIScreen.main.bounds.width)
//        }
//    }
//}
