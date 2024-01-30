//
//  CompetitionViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/26.
//

import UIKit
import RxSwift
import SnapKit

struct CompetitionScrap {
    let title: String?
    let coorporation: String?
    let leftDays: String? // TODO: 유효한 토큰 생기면 서버 데이터 확인해서 형식 확정(날짜, 숫자, 혹은 "D-N"/"마감")
    let viewCount: Int?
}

/// 마이페이지 > 스크랩 > 구인구직 탭의 pageViewController
class CompetitionViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: CompetitionViewModel!
    private var disposeBag = DisposeBag()
    
    private var competitions: [CompetitionScrap] = []
    
    private lazy var tableView = UITableView().then {
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
        $0.dataSource = self
        $0.register(with: CompetitionCell.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
    }
    
    func bindViewModel() {
        viewModel.competitionScraps
            .withUnretained(self)
            .bind { owner, competitions in
                guard let competitions = competitions else { return }
                owner.competitions = competitions
                owner.tableView.reloadData()
            }.disposed(by: disposeBag)
    }
    
    
    private func setupUI() {
        [tableView]
            .forEach { view.addSubview($0) }
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}

extension CompetitionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        competitions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let competition = competitions[indexPath.row]
        let cell = tableView.dequeueReusableCell(for: indexPath) as CompetitionCell
        cell.configure(competition)
        
        return cell
    }
    
    
}
