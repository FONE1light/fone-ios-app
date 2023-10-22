//
//  TermsCell.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/10.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class TermsCell: UITableViewCell {

    static let identifier = String(describing: TermsCell.self)
    var disposeBag = DisposeBag()
    
    /// 해당 약관에 동의했는지 아닌지
    var isChecked = false {
        didSet {
            if isChecked {
                checkBox.image = UIImage(named: "checkboxes_on")
            } else {
                checkBox.image = UIImage(named: "checkboxes_off")
            }
        }
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
    }
    
    private let visibleView = UIView()
    
    private let expandableView = UIView().then {
        $0.cornerRadius = 5
        $0.backgroundColor = .gray_EEEFEF
        $0.isHidden = true
    }
    
    private let scrollView = UIScrollView()
    
    private let checkBox = UIImageView().then {
        $0.image = UIImage(named: "checkboxes_off")
    }
    
    private let checkBoxButton = UIButton()
    var checkBoxButtonTap: ControlEvent<Void> {
        checkBoxButton.rx.tap
    }
    
    private let label = UILabel().then {
        $0.font = .font_r(16)
        $0.textColor = .gray_9E9E9E
    }
    
    private let arrowDown = UIImageView().then {
        $0.image = UIImage(named: "arrow_down16")
    }
    
    private let arrowDownButton = UIButton()
    var arrowDownButtonTap: ControlEvent<Void> {
        arrowDownButton.rx.tap
    }
    
    private let termsLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = .font_r(12)
        $0.textColor = .gray_9E9E9E
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        setupUI()
        bindAction()
    }
    
    // reload 했을 때 여러 번 바인딩 되지 않으려면 disposeBag 초기화 필요
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func configure(
        title: String?,
        termsText: String?
    ) {
        label.text = title
        termsLabel.text = termsText
    }
    
    func switchHiddenState() {
        expandableView.isHidden = !expandableView.isHidden
    }
    
    private func switchCheckedState() {
        isChecked = !isChecked
    }
    
    private func bindAction() {
        // TODO: button Tap 위치 확정 - 통일 혹은 분리(cell과 vc)
        checkBoxButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.switchCheckedState()
            }.disposed(by: rx.disposeBag)
    }
    
    private func setupUI() {
        self.contentView.addSubview(stackView)
        
        [visibleView, expandableView]
            .forEach { stackView.addArrangedSubview($0) }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // visibleView
        [checkBox, label, arrowDown, checkBoxButton, arrowDownButton]
            .forEach { visibleView.addSubview($0) }

        checkBox.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8).priority(.low)
            $0.leading.equalToSuperview()
            $0.size.equalTo(16)
        }
        
        checkBoxButton.snp.makeConstraints {
            $0.edges.equalTo(checkBox).inset(-2)
        }
        
        label.snp.makeConstraints {
            $0.centerY.equalTo(checkBox)
            $0.leading.equalTo(checkBox.snp.trailing).offset(6)
        }
        
        arrowDown.snp.makeConstraints {
            $0.centerY.equalTo(checkBox)
            $0.trailing.equalToSuperview()
            $0.size.equalTo(16)
        }
        
        arrowDownButton.snp.makeConstraints {
            $0.edges.equalTo(arrowDown).inset(-2)
        }
        
        // expandableView
        expandableView.snp.makeConstraints {
            $0.height.equalTo(77.3).priority(.low) // FIXME: 높이 다른 방식으로 지정
        }
        
        [ scrollView ]
            .forEach { expandableView.addSubview($0) }
        
        [ termsLabel ]
            .forEach { scrollView.addSubview($0) }
        
        scrollView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview()
        }
        
        termsLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalTo(expandableView).inset(20)
        }
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        visibleView.translatesAutoresizingMaskIntoConstraints = false
        expandableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
