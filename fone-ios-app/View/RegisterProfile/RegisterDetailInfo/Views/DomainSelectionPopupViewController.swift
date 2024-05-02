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
    
    var disposeBag = DisposeBag()
    
    let dimViewButton = UIButton()
    
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
    
    private let domains: FullWidthSelectionView
    
    /// 내부에서 사용할 BehaviorRelay
    private let selectionRelay: BehaviorRelay<[Selection]>
    
    /// 외부에서 받은 BehaviorRelay
    private let superSelectionRelay: BehaviorRelay<[Selection]>?
    
    private let confirmButton = CustomButton("확인", type: .bottom14).then {
        $0.isEnabled = false
    }
    
    init(selectionRelay superSelectionRelay: BehaviorRelay<[Selection]>? = nil) {
        let selectedItems = superSelectionRelay?.value ?? []
        
        domains = FullWidthSelectionView(
            of: Domain.allCases,
            selectedItems: selectedItems
        )
        self.selectionRelay = BehaviorRelay<[Selection]>(value: selectedItems)
        self.superSelectionRelay = superSelectionRelay
        
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setConstraints()
        bindActions()
    }
    
    private func setupUI() {
        view.backgroundColor = .black_000000.withAlphaComponent(0.3)
        view.addSubview(dimViewButton)
        
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
        dimViewButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
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
    
    private func bindActions() {
        domains.rx.itemDeselected
            .withUnretained(self)
            .subscribe { owner, indexPath in
                guard let cell = owner.domains.cellForItem(at: indexPath) as? DynamicSizeSelectionCell else { return }
                // 선택(isSelected=true)된 item 업데이트
                guard let item = cell.item else { return }
                var items = owner.selectionRelay.value
                items.removeAll { $0.name == item.name }
                
                owner.selectionRelay.accept(items)
                
            }.disposed(by: rx.disposeBag)
        
        domains.rx.itemSelected
            .withUnretained(self)
            .subscribe { owner, indexPath in
                guard let cell = owner.domains.cellForItem(at: indexPath) as? DynamicSizeSelectionCell else { return }
                // 선택(isSelected=true)된 item 업데이트
                guard let item = cell.item else { return }
                var items = owner.selectionRelay.value
                items.append(item)
                
                owner.selectionRelay.accept(items)
                
            }.disposed(by: rx.disposeBag)

        selectionRelay.withUnretained(self)
            .bind { owner, items in
                if items.isEmpty == false {
                    owner.confirmButton.isEnabled = true
                } else {
                    owner.confirmButton.isEnabled = false
                }
            }.disposed(by: disposeBag)
        
        // Buttons
        closeButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.dismiss(animated: false)
            }.disposed(by: rx.disposeBag)
        
        confirmButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                // 선택된 Domains 넘기기
                owner.superSelectionRelay?.accept(owner.selectionRelay.value)
                owner.dismiss(animated: false)
            }.disposed(by: rx.disposeBag)
            
        dimViewButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.dismiss(animated: false)
            }.disposed(by: rx.disposeBag)
    }
}
