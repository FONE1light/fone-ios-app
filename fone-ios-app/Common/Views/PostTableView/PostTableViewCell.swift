//
//  PostTableViewCell.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/24.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    var hasBookmark = true
    
    static let identifier = String(describing: PostTableViewCell.self)
    
    private let horizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 20
        $0.alignment = .top
    }
    
    /// `badges`, `titleLabel`을 포함하고 있는 leftView
    private let leftView = UIView()
    private let badges = UIView().then {
        $0.backgroundColor = .blue
    }
    
    let titleLabel = UILabel().then {
        $0.font = .font_r(14)
        $0.textColor = .gray_161616
        $0.numberOfLines = 2
        $0.text = "성균관대 영상학과에서 단편영화<Duet>배우 모집합니다."
    }
    
    private let bookmarkView = UIView().then {
        $0.cornerRadius = 16
        $0.backgroundColor = .gray_EEEFEF
    }
    private let bookmarkImageView = UIImageView().then {
        $0.image = UIImage(named: "Bookmark")
    }
    
    private var titleValueBlock = TitleValueBlock()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        setupUI()
        setConstraints()
    }
    
    func configure(
        deadline: String? = nil,
        coorporate: String? = nil,
        gender: String? = nil,
        period: String? = nil,
        casting: String? = nil,
        field: String? = nil
    ) {
        titleValueBlock.setValues(
            deadline: deadline,
            coorporate: coorporate,
            gender: gender,
            period: period,
            casting: casting,
            field: field
        )
    }
    
    private func setupUI() {
        
        [horizontalStackView, titleValueBlock]
            .forEach {
                contentView.addSubview($0)
            }
        [leftView]
            .forEach {
                horizontalStackView.addArrangedSubview($0)
            }
        
        if hasBookmark {
            horizontalStackView.addArrangedSubview(bookmarkView)
            bookmarkView.addSubview(bookmarkImageView)
        }
        
        [badges, titleLabel]
            .forEach {
                leftView.addSubview($0)
            }
        
    }
    
    private func setConstraints() {
        horizontalStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        titleValueBlock.snp.makeConstraints {
            $0.top.equalTo(horizontalStackView.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(horizontalStackView)
            $0.bottom.equalToSuperview().offset(-12)
//            $0.height.equalTo(60)
        }
        
        bookmarkView.snp.makeConstraints {
            $0.size.equalTo(32)
        }
        
        badges.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(22)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(badges.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        if hasBookmark {
            bookmarkImageView.snp.makeConstraints {
                $0.size.equalTo(22)
                $0.center.equalToSuperview()
            }
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
