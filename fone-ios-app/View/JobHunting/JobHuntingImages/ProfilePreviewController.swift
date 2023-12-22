//
//  ProfilePreviewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 12/12/23.
//

import UIKit
import Then
import SnapKit
import RxSwift

// FIXME: 좌우 스와이프 기능 및 이미지 추가
class ProfilePreviewController: UIViewController {
    
    private let imageView: UIImageView
    
    init(imageUrl: String?) {
        imageView = UIImageView().then {
            $0.load(url: imageUrl)
            $0.contentMode = .scaleAspectFit
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setConstraints()
        
    }
    
    private func setupUI() {
        view.backgroundColor = .black_000000.withAlphaComponent(0.3)
        view.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setConstraints() {
    }
}

