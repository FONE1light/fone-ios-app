//
//  ProfileRegistrationViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/10/13.
//

import UIKit
import RxSwift

class ProfileRegistrationViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: ProfileRegistrationViewModel!
    private var disposeBag = DisposeBag()
    
    private var profileRegistrations: [Profile] = []
    
    private lazy var tableView = UITableView().then {
        $0.register(with: ProfileRegistrationCell.self)
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.dataSource = self
        $0.contentInset.top = 30
        $0.backgroundColor = .gray_F8F8F8
    }
    
    func bindViewModel() {
        viewModel.profileRegistrations
            .withUnretained(self)
            .bind { owner, profiles in
                owner.profileRegistrations = profiles ?? []
                owner.tableView.reloadData()
            }.disposed(by: disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setConstraints()
        
    }
    
    private func setUI() {
        self.view.backgroundColor = .gray_F8F8F8
        
        [tableView]
            .forEach { view.addSubview($0) }
    }
    
    private func setConstraints() {
        tableView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
}

// MARK: - UITableView functions
extension ProfileRegistrationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileRegistrations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as ProfileRegistrationCell
        let profile = profileRegistrations[indexPath.row]
        
        cell.configure(profile)
        
        // buttons
        cell.cellButtonTap
            .withUnretained(self)
            .bind { owner, _ in
                guard let id = profile.id,
                      let job = profile.job else { return }
                owner.viewModel.goJobHuntingDetail(jobHuntingId: id, type: job)
            }.disposed(by: cell.disposeBag)
        
        cell.deleteButtonTap
            .withUnretained(self)
            .bind { owner, _ in
                guard let id = profile.id else { return }
                owner.showDeletePopup(id: id)
            }.disposed(by: cell.disposeBag)
        
        return cell
    }
}


extension ProfileRegistrationViewController {
    func showDeletePopup(id: Int) {
        let message = "게시글을 삭제하면 다시 되돌릴 수 없어요. 정말 삭제 하시겠어요?"
        let alert = UIAlertController.createTwoBlackButtonPopup(
            title: message,
            cancelButtonText: "아니오",
            continueButtonText: "네"
        ) { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.deleteProfileRegistration(id: id)
        }
        
        present(alert, animated: true)
    }
}
