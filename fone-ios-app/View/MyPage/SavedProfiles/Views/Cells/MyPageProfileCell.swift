//
//  MyPageProfileCell.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/10/11.
//

import UIKit
import RxSwift
import SnapKit
import Then

class MyPageProfileCell: UICollectionViewCell {
    
    private struct Constants {
        static let imageHeight: CGFloat = 198
        static let nameLabelTopOffset: CGFloat = 6
        static let ageLabelTopOffset: CGFloat = 2
    }
    
    static let identifier = String(describing: MyPageProfileCell.self)
    var disposeBag = DisposeBag()
    var id: Int?
    var jobType: String?
    private var isSaved = false {
        didSet {
            if isSaved {
                heartImageView.image = UIImage(named: "heart_on")
            } else {
                heartImageView.image = UIImage(named: "heart_01_off")
            }
        }
    }
    
    private let imageView = UIImageView().then {
        $0.cornerRadius = 5
        $0.backgroundColor = .gray_F8F8F8
        $0.clipsToBounds = true
        $0.image = UIImage(resource: .defaultProfile)
    }
    
    private let nameLabel = UILabel().then {
        $0.font = .font_b(16)
        $0.textColor = .gray_161616
    }
    
    private let ageLabel = UILabel().then {
        $0.font = .font_m(13)
        $0.textColor = .gray_555555
    }
    
    private let heartImageView = UIImageView().then {
        $0.image = UIImage(named: "heart_01_off")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [imageView, nameLabel, ageLabel, heartImageView]
            .forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        imageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(MyPageProfileCell.Constants.imageHeight)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(MyPageProfileCell.Constants.nameLabelTopOffset)
            $0.leading.trailing.equalToSuperview()
        }
        
        ageLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(MyPageProfileCell.Constants.ageLabelTopOffset)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        heartImageView.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.top.trailing.equalToSuperview().inset(10)
        }
    }
    
    func configure(
        id: Int?,
        jobType: String?,
        image: String?,
        name: String?,
        birthYear: String?,
        age: Int?,
        isSaved: Bool?
    ) {
        self.id = id
        self.jobType = jobType
        imageView.load(url: image)
        nameLabel.text = name
        ageLabel.text = "\(birthYear ?? "")년생 (\(age ?? 0)살)"
        self.isSaved = isSaved ?? false
    }
}

extension MyPageProfileCell {
    static func cellHeight(width: CGFloat) -> CGFloat {
        let nameHeight = UILabel.getLabelHeight(width: width, text: "text", font: UIFont.font_b(16), line: 1)
        let ageHeight = UILabel.getLabelHeight(width: width, text: "text", font: UIFont.font_b(13), line: 1)
        return MyPageProfileCell.Constants.imageHeight + MyPageProfileCell.Constants.nameLabelTopOffset + nameHeight + MyPageProfileCell.Constants.ageLabelTopOffset + ageHeight
    }
}

