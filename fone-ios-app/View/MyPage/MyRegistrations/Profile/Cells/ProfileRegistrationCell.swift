//
//  ProfileRegistrationCell.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/10/13.
//

import UIKit
import RxSwift
import Then
import SnapKit
import RxCocoa

class ProfileRegistrationCell: UITableViewCell {
    
    static let identifier = String(String(describing: ProfileRegistrationCell.self))
    var disposeBag = DisposeBag()
    
    private let containView = UIView().then {
        $0.backgroundColor = .white_FFFFFF
        $0.cornerRadius = 10
        $0.applyShadow(shadowType: .shadowIt2)
    }
    
    private let emptyView = EmptyView(height: 18).then {
        $0.backgroundColor = .none
    }
    
    private let image = UIImageView().then {
        $0.backgroundColor = .gray_9E9E9E
        $0.cornerRadius = 10
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private let nameLabel = UILabel().then {
        $0.font = .font_b(16)
        $0.textColor = .gray_161616
    }
    
    private let jobLabel = UILabel().then {
        $0.font = .font_m(14)
        $0.textColor = .red_CE0B39
        
    }
    
    private let birthYearLabel = UILabel().then {
        $0.font = .font_r(14)
        $0.textColor = .gray_555555
    }
    
    private let ageLabel = UILabel().then {
        $0.font = .font_r(14)
        $0.textColor = .gray_555555
    }
    
    private let divider = Divider(height: 1, color: .gray_EEEFEF)
    
    private let cellButton = UIButton()
    var cellButtonTap: ControlEvent<Void> {
        cellButton.rx.tap
    }
    
    private let deleteButton = ProfileRegistrationButton(title: "삭제")
    var deleteButtonTap: ControlEvent<Void> {
        deleteButton.buttonTap
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupUI()
        self.setConstraints()
    }
    
    func configure(_ profile: Profile) {
        image.load(url: profile.imageUrl)
        nameLabel.text = profile.name
        jobLabel.text = profile.job?.name
        birthYearLabel.text = "\(profile.birthYear ?? "")년생"
        ageLabel.text = "(\(profile.age ?? "")살)"
    }
    
    private func setupUI() {
        backgroundColor = .gray_F8F8F8
        selectionStyle = .none
        
        [containView, emptyView]
            .forEach { contentView.addSubview($0) }
        
        [
            image,
            nameLabel,
            jobLabel,
            birthYearLabel,
            ageLabel,
            divider,
            cellButton,
            deleteButton
        ]
            .forEach { containView.addSubview($0) }
    }
    
    private func setConstraints() {
        containView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints {
            $0.top.equalTo(containView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(18)
            $0.bottom.equalToSuperview()
        }
        
        // containView
        image.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview().inset(12)
            $0.width.equalTo(104)
            $0.height.equalTo(126)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(35)
            $0.leading.equalTo(image.snp.trailing).offset(18)
        }
        
        jobLabel.snp.makeConstraints {
            $0.centerY.equalTo(nameLabel)
            $0.leading.equalTo(nameLabel.snp.trailing).offset(4)
        }
        
        birthYearLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(1)
            $0.leading.equalTo(nameLabel.snp.leading)
        }
        
        ageLabel.snp.makeConstraints {
            $0.leading.equalTo(birthYearLabel.snp.trailing).offset(2)
            $0.centerY.equalTo(birthYearLabel)
        }
        
        divider.snp.makeConstraints {
            $0.top.equalTo(birthYearLabel.snp.bottom).offset(12)
            $0.leading.equalTo(image.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().offset(-12)
        }
        
        cellButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(12)
            $0.leading.equalTo(image.snp.trailing).offset(18)
            $0.bottom.equalToSuperview().offset(-16)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// TODO: UIView -> UIButton 상속하도록 수정
class ProfileRegistrationButton: UIView {
    
    private let button = UIButton()
    
    private let label = UILabel().then {
        $0.font = .font_r(14)
        $0.textColor = .gray_555555
    }
    
    var buttonTap: ControlEvent<Void> {
        button.rx.tap
    }
    
    init(title: String?) {
        super.init(frame: .zero)
        
        label.text = title
        
        setupUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        
        cornerRadius = 5
        backgroundColor = .gray_EEEFEF
        
        [label, button]
            .forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        label.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview().inset(14)
        }
        
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    
}
