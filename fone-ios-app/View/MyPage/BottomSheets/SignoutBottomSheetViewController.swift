//
//  SignoutBottomSheetViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 3/8/24.
//

import UIKit
import SnapKit
import RxSwift

class SignoutBottomSheetViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: SignoutBottomSheetViewModel!
    private var disposeBag = DisposeBag()
    
    let bottomSheetView = MyPageBottomSheet(
        title: ".. 저희 이별하나요? 너무 아쉬워요",
        content: "회원탈퇴를 진행할 경우 혜택 및\n게시글, 관심, 채팅 등 모든 정보가 삭제됩니다."
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
                self.viewModel.signout()
            }.disposed(by: disposeBag)
        
        bottomSheetView.noButtonTap
            .withUnretained(self)
            .bind { owner, _ in
                owner.viewModel.sceneCoordinator.close(animated: true)
            }.disposed(by: disposeBag)
    }
}
