//
//  ScrapViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/24.
//

import UIKit

extension ScrapViewController {
    struct Constants {
        /// leading, trailing inset
        static let horizontalInset: CGFloat = 17
        
        static let tabBarHeight: CGFloat = 37
    }
}

class ScrapViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: ScrapViewModel!
    
    private var tabBar = MyPageTabBar(
        width: UIScreen.main.bounds.width - Constants.horizontalInset * 2,
        height: Constants.tabBarHeight
    )
    
    private let underLineView = UIView().then {
        $0.backgroundColor = .gray_D9D9D9
    }
    
    private lazy var tableView = UITableView().then {
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none // cell 하단에 추가
//        $0.delegate = self
        $0.dataSource = self
        $0.register(with: ScrapPostCell.self)
    }
    
    func bindViewModel() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setNavigationBar()
        setUI()
        setConstraints()
    }
    
    private func setNavigationBar() {
        self.navigationItem.titleView = NavigationTitleView(title: "스크랩")
        self.navigationItem.leftBarButtonItem = NavigationLeftBarButtonItem(
            type: .back,
            viewController: self
        )
    }
    
    private func setUI() {
        self.view.backgroundColor = .white_FFFFFF
        
        [tabBar, underLineView, tableView].forEach {
            self.view.addSubview($0)
        }
        
        let job = MyPageTabBarItem(title: "구인구직", tag: 0)
        
        let competition = MyPageTabBarItem(title: "공모전", tag: 1)
        
        tabBar.setItems([job, competition], animated: true)
        tabBar.selectedItem = tabBar.items?.first
    }
    
    private func setConstraints() {
        tabBar.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview().inset(Constants.horizontalInset)
            $0.height.equalTo(Constants.tabBarHeight)
        }
        
        underLineView.snp.makeConstraints {
            $0.leading.trailing.equalTo(tabBar)
            $0.top.equalTo(tabBar.snp.bottom)
            $0.height.equalTo(1)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(underLineView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension ScrapViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return self.arrDropDownDataSource.count
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as ScrapPostCell
        
//        cell.configure(
//            deadline: "2023.01.20",
//            coorporate: "성균관대학교 영상학과",
//            gender: "남자",
//            period: "일주일",
//            casting: "수영선수"
//        )
        
        cell.configure(
            job: .actor,
            interests: [.ottDrama, .shortFilm],
            deadline: "2023.01.20",
            coorporate: "성균관대학교 영상학과",
            gender: "남자",
            period: "일주일",
            field: "미술"
        )
        
        return cell
    }

}
