//
//  BottomSheetViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/10/14.
//

import UIKit
import PanModal
import SnapKit
import Then

class BottomSheetViewController: UIViewController {
    
    var customHeight: PanModalHeight? = nil

    var longFormHeight: PanModalHeight {
        shortFormHeight
    }

    var shortFormHeight: PanModalHeight {
        if let height = customHeight {
            return height
        } else {
            return .intrinsicHeight
        }
    }
    
    private let bottomSheetView: UIView

    init(view: UIView) {
        bottomSheetView = view
        super.init(nibName: nil, bundle: nil)
//        let height = view.frame.height
//        self.customHeight = .contentHeight(height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(bottomSheetView)
        bottomSheetView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension BottomSheetViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        nil
    }
    
}
