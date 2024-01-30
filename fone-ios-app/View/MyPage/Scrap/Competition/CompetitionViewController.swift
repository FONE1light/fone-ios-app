//
//  CompetitionViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/26.
//

import UIKit
import SnapKit

/// 마이페이지 > 스크랩 > 구인구직 탭의 pageViewController
class CompetitionViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: CompetitionViewModel!
    
    private lazy var tableView = UITableView().then {
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
//        $0.delegate = self
        $0.dataSource = self
        $0.register(with: CompetitionCell.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
    }
    
    func bindViewModel() {
        
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
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as CompetitionCell
        cell.configure(
            title: "제목 예 2022 베리어프리 콘텐츠 공모전 제목 예 2022 베리어프리 콘텐츠 공모전",
            coorporation: "방송통신 위원회",
            leftDays: "D-15",
            viewCount: 3222
        )
        
        return cell
    }
    
    
}
