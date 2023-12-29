//
//  JobRegistrationViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/10/13.
//

import UIKit

class JobRegistrationViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: JobRegistrationViewModel!
    
    private lazy var tableView = UITableView().then {
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
//        $0.delegate = self
        $0.dataSource = self
        $0.register(with: JobRegistrationCell.self)
    }
    
    func bindViewModel() {
        
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
        //        return self.arrDropDownDataSource.count
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as JobRegistrationCell
        
//        cell.configure(
//            job: .staff,
//            categories: [.featureFilm, .youtube],
//            deadline: "2023.01.20",
//            coorporate: "성균관대학교 영상학과",
//            gender: "남자",
//            period: "일주일",
//            field: "미술"
//        )
        
        cell.configure(
            job: .actor,
            categories: [.ottDrama, .shortFilm],
            dDay: "D-11",
            coorporate: "성균관대학교 영상학과",
            casting: "수영선수"
        )
        
        return cell
    }

}
