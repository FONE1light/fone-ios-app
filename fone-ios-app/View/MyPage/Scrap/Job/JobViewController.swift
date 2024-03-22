//
//  JobViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/10/02.
//

import UIKit
import RxSwift
import SnapKit

struct JobOpening {
    let id: Int?
    let imageUrl: String?
    let isVerified: Bool?
    let categories: [Category]? // 작품 성격 최대 2개
    let isScrap: Bool?
    let title: String?
    let dDay: String?
    let genre: String? // 배우 - 장르 중 첫 번째 값
    let domain: String? // 스태프 - 분야 중 첫 번째 값
    let produce: String?
    let job: Job?
}

class JobViewController: UIViewController, ViewModelBindableType {

    var viewModel: JobViewModel!
    private var disposeBag = DisposeBag()
    
    private var jobScraps: [JobOpening] = []
    private lazy var tableView = UITableView().then {
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
        $0.dataSource = self
        $0.register(with: JobScrapCell.self)
    }
    
    func bindViewModel() {
        viewModel.jobScraps
            .withUnretained(self)
            .bind { owner, jobScraps in
                owner.jobScraps = jobScraps ?? []
                owner.tableView.reloadData()
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { owner, indexPath in
                guard let id = owner.jobScraps[indexPath.row].id,
                let jobType = owner.jobScraps[indexPath.row].job else { return }
                owner.viewModel.goJobOpeningDetail(jobOpeningId: id, type: jobType)
            }.disposed(by: rx.disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setUI()
        setConstraints()
        
    }
    
    private func setNavigationBar() {
        self.navigationItem.titleView = NavigationTitleView(title: "")
        self.navigationItem.leftBarButtonItem = NavigationLeftBarButtonItem(
            type: .back,
            viewController: self
        )
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


extension JobViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobScraps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let jobScrap = jobScraps[indexPath.row]
        let cell = tableView.dequeueReusableCell(for: indexPath) as JobScrapCell
        cell.configure(jobScrap)
        
        cell.isScrap
            .distinctUntilChanged()
            .skip(1) // distinct를 사용하게 위해 초기값이 필요하나 api call는 막고자 skip 1
            .withUnretained(self)
            .bind { owner, _ in
                // API 호출
                owner.viewModel.toggleScrap(id: jobScrap.id)
            }.disposed(by: cell.disposeBag)

        return cell
    }
}
