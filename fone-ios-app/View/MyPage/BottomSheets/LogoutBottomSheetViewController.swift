//
//  LogoutBottomSheetViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 2/6/24.
//

import UIKit
import SnapKit
import RxSwift

class LogoutBottomSheetViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: LogoutBottomSheetViewModel!
    private var disposeBag = DisposeBag()
    
    let bottomSheetView = MyPageBottomSheet(
        title: "로그아웃 하시겠습니까?",
        content: "깡총! 소셜 로그인 화면으로 돌아가요"
    )
    
    func bindViewModel() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setConstraints()
        
        bind()
    }
    
    private func setupUI() {
        view.backgroundColor = .white_FFFFFF
        view.addSubview(bottomSheetView)
    }
    
    private func setConstraints() {
        bottomSheetView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func bind() {
        bottomSheetView.yesButtonTap
//            .withUnretained(self) // 사용 시 bind 구문 실행 X
            .bind { _ in // weak self 하면 self에 nil이 들어옴
                self.viewModel.logout()
            }.disposed(by: disposeBag)
        
        bottomSheetView.noButtonTap
            .withUnretained(self)
            .bind { owner, _ in
                owner.viewModel.sceneCoordinator.close(animated: true)
            }.disposed(by: disposeBag)
    }
}
