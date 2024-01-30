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
    let id: Int?
    let title: String?
    let coorporation: String?
    let isScrap: Bool?
    let leftDays: String?
    let viewCount: Int?
}

/// 마이페이지 > 스크랩 > 구인구직 탭의 pageViewController
class CompetitionViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: CompetitionViewModel!
    private var disposeBag = DisposeBag()
    
    var competitions: [CompetitionScrap] = []
    
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
        
        tableView.rx.itemSelected
            .withUnretained(self)
            .bind { owner, indexPath in
                guard let id = owner.competitions[indexPath.row].id else { return }
                owner.viewModel.moveToCompetitionDetail(id: id)
            }.disposed(by: rx.disposeBag)
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
        
        cell.bookmarkButtonTap
            .asDriver()
            .do {_ in
                // cell의 button toggle
                cell.toggleBookmarkButton()
            }
            .debounce(.milliseconds(500))
            .asObservable()
            .withUnretained(self)
            .bind { owner, _ in
                // API 호출
                owner.viewModel.toggleScrap(id: competition.id)
            }.disposed(by: cell.disposeBag)
        
        return cell
    }
}
