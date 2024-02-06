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
import RxCocoa

enum MyPageMenuType {
    /// 나의 등록내역
    case postings
    /// 문의하기
    case question
    /// 앱 버전
    case version
    /// 로그아웃
    case logout
    /// 회원 탈퇴
    case withdrawal
    
    private var imageName: String? {
        switch self {
        case .postings: return "mySettings"
        case .question: return "ContactUs"
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
        case .question: return "문의하기"
        case .version: return "앱 버전"
        case .logout: return "로그아웃"
        case .withdrawal: return "회원 탈퇴"
        }
    }
    
    var trailingView: UIView? {
        switch self {
        case .postings, .question:
            return UIImageView().then {
                $0.image = UIImage(named: "arrow_right16")
            }
        case .version:
            return UILabel().then {
                $0.text = getCurrentAppVersion()
                $0.font = .font_m(16)
                $0.textColor = .violet_6D5999
            }
        default: return nil
        }
    }
    
    var bottomSheet: UIView? {
        switch self {
        case .logout:
            return MyPageBottomSheet(
                title: "로그아웃 하시겠습니까?",
                content: "깡총! 소셜 로그인 화면으로 돌아가요"
            )
        case .withdrawal:
            return MyPageBottomSheet(
                title: ".. 저희 이별하나요? 너무 아쉬워요",
                content: "회원탈퇴를 진행할 경우 혜택 및\n게시글, 관심, 채팅 등 모든 정보가 삭제됩니다."
            )
        default: return nil
        }
        
    }
    
    func nextScene(_ sceneCoordinator: SceneCoordinatorType) -> Scene? {
        switch self {
        case .postings:
            let viewModel = MyRegistrationsViewModel(sceneCoordinator: sceneCoordinator)
            let scene = Scene.myRegistrations(viewModel)
            return scene
        case .question:
            let viewModel = QuestionViewModel(sceneCoordinator: sceneCoordinator)
            let scene = Scene.question(viewModel)
            return scene
        default: return nil
        }
    }
    
    private func getCurrentAppVersion() -> String? {
        guard let dictionary = Bundle.main.infoDictionary else { return nil }
        
        let version = dictionary["CFBundleShortVersionString"] as? String
        return version
    }
    
}

class MyPageMenuCell: UITableViewCell {
    
    static let identifier = String(describing: MyPageMenuCell.self)
    var disposeBag = DisposeBag()
    
    var buttonTap: ControlEvent<Void> {
        button.rx.tap
    }
    private lazy var leadingImage = UIImageView().then {
        $0.tintColor = .gray_9E9E9E
    }
    
    private let label = UILabel().then {
        $0.font = .font_m(15)
        $0.textColor = .gray_161616
    }
    
    private var trailingView: UIView?
    
    private let button = UIButton()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func setupCell(type: MyPageMenuType) {
        leadingImage.image = type.image
        label.text = type.text
        trailingView = type.trailingView
        
        setupUI()
    }
    
    private func setupUI() {
        selectionStyle = .none
        
        [leadingImage, label, trailingView, button]
            .compactMap { $0 }
            .forEach { contentView.addSubview($0) }
    
        leadingImage.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10) // FIXME: centerY만 해도 높이 44로 되는 이유
            $0.leading.equalToSuperview().offset(16)
        }
        
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(leadingImage.snp.trailing).offset(6)
        }
        
        if let trailingView = trailingView {
            trailingView.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.trailing.equalToSuperview().offset(-16)
            }
            
            // arrow_right16은 크기 지정
            if let imageView = trailingView as? UIImageView {
                imageView.snp.makeConstraints {
                    $0.size.equalTo(16)
                }
            }
            
            button.snp.makeConstraints {
                $0.edges.equalTo(trailingView).inset(-2)
            }
        } else {
            button.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
    }
}
