//
//  StaffInfoTableViewCell.swift
//  fone-ios-app
//
//  Created by 여나경 on 12/11/23.
//

import UIKit
import RxSwift
import Then
import SnapKit

class StaffInfoTableViewCell: UITableViewCell {
    
    static let identifier = String(String(describing: StaffInfoTableViewCell.self))
    
    private let titleLabel = UILabel().then {
        $0.font = .font_b(17)
        $0.textColor = .gray_161616
        $0.text = "스태프 정보"
    }
    
    private let keyStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
    }
    private let valueStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
    }
    
    private let nameLabel = ActorStaffInfoValueLabel()
    private let genderLabel = ActorStaffInfoValueLabel()
    private let birthYearLabel = ActorStaffInfoValueLabel()
    private let domainLabel = ActorStaffInfoValueLabel()
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
        domain: String?,
        email: String?,
        specialty: String?
    ) {
        nameLabel.text = name
        genderLabel.text = gender?.string
        birthYearLabel.text = birthYear
        domainLabel.text = domain
        emailLabel.text = email
        specialtyLabel.text = specialty
    }
    
    private func setupUI() {
        [
            titleLabel,
            keyStackView,
            valueStackView
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
            $0.bottom.equalToSuperview().offset(-20)
        }
        
        valueStackView.snp.makeConstraints {
            $0.top.bottom.equalTo(keyStackView)
            $0.leading.equalTo(keyStackView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        setupStackView()
    }
    
    private func setupStackView() {
        [
            ActorStaffInfoKeyLabel("이름"),
            ActorStaffInfoKeyLabel("성별"),
            ActorStaffInfoKeyLabel("출생연도"),
            ActorStaffInfoKeyLabel("분야"),
            ActorStaffInfoKeyLabel("이메일"),
            ActorStaffInfoKeyLabel("특기"),
        ]
            .forEach { keyStackView.addArrangedSubview($0) }
        
        [
            nameLabel,
            genderLabel,
            birthYearLabel,
            domainLabel,
            emailLabel,
            specialtyLabel
        ]
            .forEach { valueStackView.addArrangedSubview($0) }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
