//
//  ViewModelBindableType.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/08/07.
//

import UIKit

protocol ViewModelBindableType {
    associatedtype ViewModelType
    
    var viewModel: ViewModelType! { get set }
    func bindViewModel()
}

protocol ReportableType {
    var profileImageURL: String? { get set }
    var nickname: String? { get set }
    var userJob: String? { get set }
}

extension ViewModelBindableType where Self: UIViewController {
    mutating func bind(viewModel: Self.ViewModelType) {
        self.viewModel = viewModel
        loadViewIfNeeded()
        
        bindViewModel()
        hideKeyboardWhenTapped()
    }
}
