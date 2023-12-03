//
//  RecruitConditionInfoViewController.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 11/26/23.
//

import UIKit

class RecruitConditionInfoViewController: UIViewController {
    @IBOutlet weak var stepIndicator: StepIndicator!
    @IBOutlet weak var castingTextField: LabelTextField!
    @IBOutlet weak var numberTextField: LabelTextField!
    @IBOutlet weak var careerCollectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    
    private let items: [Selection] = [
        CareerType.NEWCOMER,
        CareerType.LESS_THAN_1YEARS,
        CareerType.LESS_THAN_3YEARS,
        CareerType.LESS_THAN_6YEARS,
        CareerType.LESS_THAN_10YEARS,
        CareerType.MORE_THAN_10YEARS,
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setUI()
        careerCollectionView.delegate = self
        careerCollectionView.dataSource = self
        careerCollectionView.register(CareerSelectionCell.self, forCellWithReuseIdentifier: CareerSelectionCell.identifier)
        careerCollectionView.allowsMultipleSelection = true
        nextButton.applyShadow(shadowType: .shadowBt)
    }
    
    private func setNavigationBar() {
        navigationItem.titleView = NavigationTitleView(title: "배우 모집하기")
        navigationItem.leftBarButtonItem = NavigationLeftBarButtonItem(
            type: .back,
            viewController: self
        )
    }
    
    private func setUI() {
        stepIndicator.xibInit(index: 1, totalCount: 6)
        castingTextField.xibInit(label: "모집배역", placeholder: "ex) 30대 중반 경찰", textFieldHeight: 44, isRequired: true, textFieldLeadingOffset: 76)
        numberTextField.xibInit(label: nil, placeholder: nil, textFieldLeadingOffset: 0, textFieldKeyboardType: .numberPad)
    }
}

extension RecruitConditionInfoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: CareerSelectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(CareerSelectionCell.self)", for: indexPath) as? CareerSelectionCell else {
            return UICollectionViewCell()
        }
        
        cell.setItem(items[indexPath.row])
        
        return cell
    }
}

extension RecruitConditionInfoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 32 - 16) / 3
        return CGSize(width: width, height: 32)
    }
}
