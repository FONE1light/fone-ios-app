//
//  MyPageMenuCell.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/17.
//

import UIKit
import SnapKit
import Then
import RxSwift

enum MyPageMenuType {
    case postings
    case contact
    case version
    case logout
    case withdrawal
    
    private var imageName: String? {
        switch self {
        case .postings: return "mySettings"
        case .contact: return "ContactUs"
        case .version: return "Settings"
        case .logout: return "Logout"
        case .withdrawal: return "Withdrawal"
        }
    }
    
    var image: UIImage? {
        guard let imageName = self.imageName else { return nil }
        return UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
    }
    
    var text: String? {
        switch self {
        case .postings: return "나의 등록내역"
        case .contact: return "문의하기"
        case .version: return "앱 버전"
        case .logout: return "로그아웃"
        case .withdrawal: return "회원 탈퇴"
        }
    }
    
    var trailingView: UIView? {
        switch self {
        case .postings, .contact:
            return UIImageView().then {
                $0.image = UIImage(named: "arrow_right16")
            }
        case .version:
            return UILabel().then {
                $0.text = "0.0.0"
                $0.font = .font_m(16)
                $0.textColor = .violet_6D5999
            }
        default: return nil
        }
    }
}

class MyPageMenuCell: UITableViewCell {
    
    static let identifier = "MyPageMenuCell"
    var disposeBag = DisposeBag()
    
    private lazy var leadingImage = UIImageView().then {
        $0.tintColor = .gray_9E9E9E
    }
    
    private let label = UILabel().then {
        $0.font = .font_m(15)
        $0.textColor = .gray_161616
    }
    
    private var trailingView: UIView?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        self.setupCell(type: .contact) // 없어도 됨
    }
    
    func setupCell(type: MyPageMenuType) {
        leadingImage.image = type.image
        label.text = type.text
        trailingView = type.trailingView
        
        setupUI()
    }
    
    private func setupUI() {
        [leadingImage, label, trailingView]
            .compactMap { $0 }
            .forEach { self.addSubview($0) }
    
        leadingImage.snp.makeConstraints {
//            $0.size.equalTo(24) // TODO: 필요없다면 지우기
//            $0.centerY.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(10) // FIXME: centerY만 해도 높이 44로 되는 이유
            $0.leading.equalToSuperview().offset(16)
        }
        
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(leadingImage.snp.trailing).offset(6)
        }
        
        trailingView?.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
}