//
//  ProfileListTableViewCell.swift
//  fone-ios-app
//
//  Created by 여나경 on 12/11/23.
//

import UIKit
import RxSwift
import Then
import SnapKit
import RxCocoa

class ProfileListTableViewCell: UITableViewCell {
    
    static let identifier = String(String(describing: ProfileListTableViewCell.self))
    var disposeBag = DisposeBag()
    
    private let titleLabel = UILabel().then {
        $0.font = .font_b(19)
        $0.textColor = .gray_161616
    }
    
    private let imageStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 17
        $0.distribution = .fillEqually
    }
    
    private let viewMoreLabel = UILabel().then {
        $0.text = "더보기"
        $0.font = .font_m(12)
        $0.textColor = .gray_555555
    }
    
    private let rightArrowImageView = UIImageView(image: UIImage(named: "arrow_right16")?.withTintColor(.gray_9E9E9E))
    private let viewMoreButton = UIButton()
    var viewMoreButtonTap: ControlEvent<Void> {
        viewMoreButton.rx.tap
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        setupUI()
    }
    
    func configure(
        title: String?,
        imageUrls: [String]?
    ) {
        titleLabel.text = title
        setupImageStackView(with: imageUrls)
    }
    
    private func setupUI () {
        backgroundColor = .gray_F8F8F8
        [
            titleLabel,
            imageStackView,
            viewMoreLabel,
            rightArrowImageView,
            viewMoreButton
        ]
            .forEach { contentView.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        imageStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(131)
        }
        
        viewMoreLabel.snp.makeConstraints {
            $0.trailing.equalTo(rightArrowImageView.snp.leading)
            $0.centerY.equalTo(rightArrowImageView)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        rightArrowImageView.snp.makeConstraints {
            $0.top.equalTo(imageStackView.snp.bottom).offset(6)
            $0.trailing.equalToSuperview().offset(-16)
            $0.size.equalTo(16)
        }
        
        viewMoreButton.snp.makeConstraints {
            $0.top.trailing.bottom.equalTo(rightArrowImageView)
            $0.leading.equalTo(viewMoreLabel.snp.leading)
        }
    }
    
    private func setupImageStackView(with imageUrls: [String]?) {
        imageStackView.arrangedSubviews
            .forEach { $0.removeFromSuperview() }
        
        imageUrls?
            .compactMap { _ in
                // FIXME: URL로 이미지 생성
                UIImageView(image: UIImage(named: "heart_on")).then {
                    $0.backgroundColor = .gray_D9D9D9
                    $0.cornerRadius = 5
                }
            }
            .forEach {
                imageStackView.addArrangedSubview($0)
            }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
