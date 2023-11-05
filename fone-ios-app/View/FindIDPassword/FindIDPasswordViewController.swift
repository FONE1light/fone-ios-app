//
//  FindIDPasswordViewController.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/08/07.
//

import UIKit

class FindIDPasswordViewController: UIViewController, ViewModelBindableType {
    var viewModel: FindIDPasswordViewModel!
    
    @IBOutlet weak var selectedTabLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var idTabButton: UIButton!
    @IBOutlet weak var passwordTabButton: UIButton!
    @IBOutlet weak var findScreenCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()

        findScreenCollectionView.delegate = self
        findScreenCollectionView.dataSource = self
        findScreenCollectionView.register(FindIDCell.self)
        findScreenCollectionView.register(FindPasswordCell.self)
        findScreenCollectionView.decelerationRate = .fast
    }
    
    private func setNavigationBar() {
        navigationItem.titleView = NavigationTitleView(title: "아이디·비밀번호 찾기")
        navigationItem.leftBarButtonItem = NavigationLeftBarButtonItem(
            type: .back,
            viewController: self
        )
    }
    
    func bindViewModel() {
        idTabButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { _ in
                self.findScreenCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
                self.selectIDTab()
            }).disposed(by: rx.disposeBag)
        
        passwordTabButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { _ in
                self.findScreenCollectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .left, animated: true)
                self.selectPasswordTab()
            }).disposed(by: rx.disposeBag)
    }
    
    func selectIDTab() {
        self.idTabButton.setTitleColor(.red_CE0B39, for: .normal)
        self.passwordTabButton.setTitleColor(.gray_9E9E9E, for: .normal)
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, delay: 0, animations: {
            self.selectedTabLeadingConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    func selectPasswordTab() {
        self.idTabButton.setTitleColor(.gray_9E9E9E, for: .normal)
        self.passwordTabButton.setTitleColor(.red_CE0B39, for: .normal)
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3, delay: 0, animations: {
            self.selectedTabLeadingConstraint.constant = self.idTabButton.frame.width
            self.view.layoutIfNeeded()
        })
    }
}

extension FindIDPasswordViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as FindIDCell
            guard let viewModel = self.viewModel else { return cell }
            cell.configure(viewModel: viewModel)
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as FindPasswordCell
            guard let viewModel = self.viewModel else { return cell }
            cell.configure(viewModel: viewModel)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension FindIDPasswordViewController: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x < self.findScreenCollectionView.frame.width {
            self.selectIDTab()
        } else {
            self.selectPasswordTab()
        }
    }
}

extension FindIDPasswordViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        
        return CGSize(width: width, height: height)
    }
}
