//
//  JobRegistrationViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/10/13.
//

import UIKit
import RxSwift

class JobRegistrationViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: JobRegistrationViewModel!
    private var disposeBag = DisposeBag()
    private var jobRegistrations: [JobOpening] = []
    
    private lazy var tableView = UITableView().then {
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
        $0.dataSource = self
        $0.register(with: JobRegistrationCell.self)
    }
    
    func bindViewModel() {
        viewModel.jobRegistrations
            .withUnretained(self)
            .bind { owner, registrations in
                owner.jobRegistrations = registrations ?? []
                owner.tableView.reloadData()
            }.disposed(by: disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setConstraints()
        
    }
    
    private func setUI() {
        [tableView].forEach {
            self.view.addSubview($0)
        }
    }
    
    private func setConstraints() {
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}



extension JobRegistrationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobRegistrations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let jobRegistration = jobRegistrations[indexPath.row]
        let cell = tableView.dequeueReusableCell(for: indexPath) as JobRegistrationCell
        
        cell.configure(jobRegistration)
        
        // buttons
        cell.cellButtonTap
            .withUnretained(self)
            .bind { owner, _ in
                guard let id = jobRegistration.id,
                      let job = jobRegistration.job else { return }
                owner.viewModel.goJobOpeningDetail(jobOpeningId: id, type: job)
            }.disposed(by: cell.disposeBag)

        return cell
    }

}
