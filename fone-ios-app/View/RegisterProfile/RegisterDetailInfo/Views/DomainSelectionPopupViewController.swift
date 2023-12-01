//
//  DomainSelectionPopupViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 12/1/23.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxRelay

class DomainSelectionPopupViewController: UIViewController {
    private let contentView = UIView().then {
        $0.backgroundColor = .white_FFFFFF
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "분야를 선택해 주세요"
        $0.font = .font_b(19)
        $0.textColor = .gray_161616
    }
    
    private let closeButton = UIButton().then {
        $0.setImage(UIImage(named: "close_MD"), for: .normal)
    }
    
    private let domains = FullWidthSelectionView(of: Domain.allCases)
    
    private let confirmButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.gray_555555, for: .normal)
        $0.titleLabel?.font = .font_r(14)
        $0.backgroundColor = .gray_EEEFEF
        $0.cornerRadius = 5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setConstraints()
        
        closeButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.dismiss(animated: false)
            }.disposed(by: rx.disposeBag)
        
        confirmButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.dismiss(animated: false)
            }.disposed(by: rx.disposeBag)
    }
    
    private func setupUI() {
        view.backgroundColor = .black_000000.withAlphaComponent(0.3)
        
        view.addSubview(contentView)
        contentView.cornerRadius = 10
        
        [
            titleLabel,
            closeButton,
            domains,
            confirmButton
        ]
            .forEach { contentView.addSubview($0) }
    }
    
    private func setConstraints() {
        
        contentView.snp.makeConstraints {
            $0.width.equalTo(347)
            $0.height.equalTo(342)
            $0.center.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.centerX.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(24)
        }
        
        domains.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(22)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(domains.snp.bottom).offset(32)
            $0.bottom.equalToSuperview().offset(-20)
            $0.width.equalTo(199)
            $0.height.equalTo(34)
            $0.centerX.equalToSuperview()
        }
    }
}
