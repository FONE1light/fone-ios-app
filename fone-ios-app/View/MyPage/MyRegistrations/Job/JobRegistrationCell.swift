//
//  JobRegistrationCell.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/10/13.
//

import UIKit
import RxCocoa

class JobRegistrationCell: UITableViewCell {
    
    private let mainContentView = PostCellMainContentView(hasBookmark: false)
    private var jobTag = Tag()
    
    private let horizontalDivider = Divider(height: 1, color: .gray_D9D9D9)
    private let verticalDivider = Divider(width: 1, color: .gray_D9D9D9)
        
    private let modifyButton = JobRegistrationButton(title: "수정하기")
    private let deleteButton = JobRegistrationButton(title: "삭제")
    
    static let identifier = String(describing: JobRegistrationCell.self)
    
    private let separator = Divider(
        width: UIScreen.main.bounds.width,
        height: 6, color: .gray_F8F8F8
    )
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        setupUI()
        setConstraints()
    }
    
    func configure(
        job: Job, // actor/staff
        categories: [Category], // 작품 성격 최대 2개
        dDay: String? = nil,
        coorporate: String? = nil,
        casting: String? = nil,
        field: String? = nil
    ) {
        mainContentView.configure(
            categories: categories,
//            title: title,
            dDay: dDay,
            coorporate: coorporate,
            casting: casting,
            field: field
        )
        
        jobTag.setType(as: job)
    }
    
    private func setupUI() {
        [
            mainContentView,
            jobTag,
            horizontalDivider,
            modifyButton,
            deleteButton,
            verticalDivider,
            separator
        ]
            .forEach { contentView.addSubview($0) }
    }
    
    private func setConstraints() {
        mainContentView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(14)
            $0.trailing.equalToSuperview().offset(-12)
        }
        
        jobTag.snp.makeConstraints {
            $0.trailing.bottom.equalTo(mainContentView)
        }
        
        horizontalDivider.snp.makeConstraints {
            $0.top.equalTo(mainContentView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
        }
        
        verticalDivider.snp.makeConstraints {
            $0.top.equalTo(horizontalDivider.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(modifyButton.snp.bottom)
        }
        
        modifyButton.snp.makeConstraints {
            $0.top.equalTo(verticalDivider.snp.top)
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(verticalDivider.snp.leading)
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.bottom.equalTo(modifyButton)
            $0.leading.equalTo(verticalDivider.snp.trailing)
            $0.trailing.equalToSuperview()
        }
        
        separator.snp.makeConstraints {
            $0.top.equalTo(modifyButton.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class JobRegistrationButton: UIButton {
    
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
        
        backgroundColor = .white_FFFFFF
        
        [label, button]
            .forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        label.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(13)
            $0.centerX.equalToSuperview()
        }
        
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    
}
