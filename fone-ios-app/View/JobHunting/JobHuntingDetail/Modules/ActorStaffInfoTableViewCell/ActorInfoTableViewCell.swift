//
//  ActorInfoTableViewCell.swift
//  fone-ios-app
//
//  Created by 여나경 on 12/11/23.
//

import UIKit
import RxSwift
import Then
import SnapKit

class ActorInfoTableViewCell: UITableViewCell {
    
    static let identifier = String(String(describing: ActorInfoTableViewCell.self))
    
    private let titleLabel = UILabel().then {
        $0.font = .font_b(17)
        $0.textColor = .gray_161616
        $0.text = "배우정보"
    }
    private let keyStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
    }
    private let valueStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
    }
    private let divider = Divider(height: 8, color: .gray_F8F8F8)
    
    private let nameLabel = ActorStaffInfoValueLabel()
    private let genderLabel = ActorStaffInfoValueLabel()
    private let birthYearLabel = ActorStaffInfoValueLabel()
    private let heightWeightLabel = ActorStaffInfoValueLabel()
    private let emailLabel = ActorStaffInfoValueLabel()
    private let specialtyLabel = ActorStaffInfoValueLabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        setupUI()
    }
    
    func configure(
        name: String?,
        gender: GenderType?, // TODO: String으로 내려주면 그대로 뿌리기
        birthYear: String?,
        height: String?,
        weight: String?,
        email: String?,
        specialty: String?
    ) {
        nameLabel.text = name
        genderLabel.text = gender?.string
        birthYearLabel.text = birthYear
        heightWeightLabel.text = "\(height ?? "") ㅣ \(weight ?? "")"
        emailLabel.text = email
        specialtyLabel.text = specialty
    }
    
    private func setupUI() {
        [
            titleLabel,
            keyStackView,
            valueStackView,
            divider
        ]
            .forEach { contentView.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        keyStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(16)
            $0.width.equalTo(68)
        }
        
        valueStackView.snp.makeConstraints {
            $0.top.bottom.equalTo(keyStackView)
            $0.leading.equalTo(keyStackView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        divider.snp.makeConstraints {
            $0.top.equalTo(keyStackView.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        setupStackView()
    }
    
    private func setupStackView() {
        [
            ActorStaffInfoKeyLabel("이름"),
            ActorStaffInfoKeyLabel("성별"),
            ActorStaffInfoKeyLabel("출생연도"),
            ActorStaffInfoKeyLabel("신장ㅣ체중"),
            ActorStaffInfoKeyLabel("이메일"),
            ActorStaffInfoKeyLabel("특기"),
        ]
            .forEach { keyStackView.addArrangedSubview($0) }
        
        [
            nameLabel,
            genderLabel,
            birthYearLabel,
            heightWeightLabel,
            emailLabel,
            specialtyLabel
        ]
            .forEach { valueStackView.addArrangedSubview($0) }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ActorStaffInfoKeyLabel: UILabel {
    
    init(_ text: String?) {
        super.init(frame: .zero)
        
        self.text = text
        font = .font_m(14)
        textColor = .gray_555555
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ActorStaffInfoValueLabel: UILabel {
    
    init() {
        super.init(frame: .zero)
        
        font = .font_r(14)
        textColor = .gray_161616
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}