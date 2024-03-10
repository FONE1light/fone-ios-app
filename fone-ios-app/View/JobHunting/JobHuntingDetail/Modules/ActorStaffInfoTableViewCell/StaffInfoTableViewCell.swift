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

struct StaffInfo {
    let name: String?
    let gender: GenderType?
    let birthYear: String?
    let age: String?
    let domains: [String]?
    let email: String?
    let specialty: String?
    
    init(
        name: String?,
        gender: GenderType?,
        birthYear: String?,
        age: String?,
        domains: [String]?,
        email: String?,
        specialty: String?
    ) {
        self.name = name
        self.gender = gender
        self.birthYear = birthYear
        self.age = age
        self.domains = domains
        self.email = email
        self.specialty = specialty
    }
}

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
        $0.distribution = .fillEqually
    }
    private let divider = Divider(height: 8, color: .gray_F8F8F8)
    
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
        gender: GenderType?,
        birthYear: String?,
        age: String?,
        domains: [String]?,
        email: String?,
        specialty: String?
    ) {
        nameLabel.text = name
        genderLabel.text = gender?.name
        birthYearLabel.text = "\(birthYear ?? "")년 (\(age ?? "")살)"
        emailLabel.text = email
        specialtyLabel.text = specialty
        var domain = domains?
            .compactMap { Domain.getType(serverName: $0)?.name }
            .reduce("") { (domain1: String, domain2: String) -> String in
            domain1 + "/" + domain2
        }
        guard var domain = domain, !domain.isEmpty else { return }
        domain.removeFirst() // '/' 삭제
        domainLabel.text = domain
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
