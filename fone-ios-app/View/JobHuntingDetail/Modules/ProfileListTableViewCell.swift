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
    
    var imageButtonTaps: [ControlEvent<Void>] = []
    
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
        
        guard let imageCount = imageUrls?.count, imageCount != 0 else { return }
        
        imageUrls?
            .compactMap { imageUrl in
                UIImageView().then {
                    $0.load(url: imageUrl)
                    $0.cornerRadius = 5
                    $0.clipsToBounds = true
                    $0.contentMode = .scaleAspectFill
                }
            }
            .forEach { imageView in
                imageStackView.addArrangedSubview(imageView)
                
                // button 생성
                let button = UIButton()
                imageStackView.addSubview(button)
                button.snp.makeConstraints {
                    $0.edges.equalTo(imageView)
                }
                
                // button ControlEvent 연결
                let buttonTap = button.rx.tap
                imageButtonTaps.append(buttonTap)
            }
        
        // 가로 계산 후 세로 높이 및 stackView 높이 지정
        var spacing: CGFloat
        var heightWidthRatio: CGFloat
        switch imageCount {
        case 2:
            spacing = 27
            heightWidthRatio = 201/158
        case 3:
            spacing = 17
            heightWidthRatio = 131/103
        default:
            spacing = 0
            heightWidthRatio = 378/343
        }
        imageStackView.spacing = spacing

        let stackViewWidth = UIScreen.main.bounds.width - 16 * 2
        let width = (stackViewWidth - spacing * CGFloat(imageCount-1)) / CGFloat(imageCount)
        let height = width * heightWidthRatio
        
        imageStackView.snp.updateConstraints {
            $0.height.equalTo(height)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
