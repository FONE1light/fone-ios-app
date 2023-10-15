//
//  ProfileRegistrationViewController.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/10/13.
//

import UIKit

class ProfileRegistrationViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: ProfileRegistrationViewModel!
    
    private var profiles: [Profile] = [
        Profile(imageUrl: nil, name: "정용식", age: "38", isSaved: true, birthYear: "1985", job: .actor),
        Profile(imageUrl: nil, name: "정용식", age: "38", isSaved: true, birthYear: "1985", job: .actor),
        Profile(imageUrl: nil, name: "정용식", age: "38", isSaved: true, birthYear: "1985", job: .actor),
        Profile(imageUrl: nil, name: "정용식", age: "38", isSaved: true, birthYear: "1985", job: .actor),
        Profile(imageUrl: nil, name: "정용식", age: "38", isSaved: true, birthYear: "1985", job: .actor),
        Profile(imageUrl: nil, name: "정용식", age: "38", isSaved: true, birthYear: "1985", job: .actor),
    ]
    
    private lazy var tableView = UITableView().then {
        $0.register(with: ProfileRegistrationCell.self)
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.dataSource = self
        $0.contentInset.top = 30
        $0.backgroundColor = .gray_F8F8F8
    }
    
    func bindViewModel() {
        
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
        return profiles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(for: indexPath) as ProfileRegistrationCell
        let profile = profiles[indexPath.row]
        cell.configure(name: profile.name, job: .actor, birthYear: "1985", age: "38")
        return cell
    }
}
