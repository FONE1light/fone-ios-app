//
//  FilterViewController.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 12/25/23.
//

import UIKit
import RxSwift
import RxCocoa

class FilterViewController: UIViewController, ViewModelBindableType {
    var viewModel: FilterViewModel!
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var genderClearButton: CustomButton!
    @IBOutlet weak var genderSelectionBlock: SelectionBlock!
    @IBOutlet weak var ageClearButton: CustomButton!
    // TODO: 나이 무조건 연결되도록.
    @IBOutlet weak var ageSelectionView: FullWidthSelectionView!
    @IBOutlet weak var categoryClearButton: CustomButton!
    @IBOutlet weak var categorySelectionBlock: SelectionBlock!
    
    @IBOutlet weak var confirmButton: CustomButton!

    private let selectedGenders = BehaviorSubject<[GenderType]>(value: [])
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func bindViewModel() {
        resetButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                //TODO: 초기화
            }.disposed(by: rx.disposeBag)
        
        closeButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.viewModel.sceneCoordinator.close(animated: true)
            }.disposed(by: rx.disposeBag)
        
        confirmButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                // TODO: ageSelectionView > selectedItemsRelay 설정(selectedItems와 연결)
                guard let genders = owner.genderSelectionBlock.selectedItems.value as? [GenderType],
                      let ages = owner.ageSelectionView.selectedItemsRelay.value as? [FilterAge],
                      let categories = owner.categorySelectionBlock.selectedItems.value as? [Category] else { return }
                        
                let filterOptions = FilterOptions(genders: genders, age: ages, categories: categories)
                owner.viewModel.applyFilter(filterOptions)
                owner.viewModel.sceneCoordinator.close(animated: true)
            }.disposed(by: rx.disposeBag)
    }
    
    private func setupUI() {
        genderClearButton.xibInit("전체선택", type: .clear)
        ageClearButton.xibInit("연령무관", type: .clear)
        categoryClearButton.xibInit("전체선택", type: .clear)
        confirmButton.xibInit("보러가기", type: .bottom)
        
        genderSelectionBlock.setSelections(GenderType.allCases)
        let width = UIScreen.main.bounds.width - 16 * 2
        ageSelectionView.xibInit(of: FilterAge.allCases, width: width)
        categorySelectionBlock.setSelections(Category.allCases)
    }
}

enum FilterAge: Selection, CaseIterable {
    case underNine
    case tenToNineTeen
    case twentyToTwentyfour
    case twentyfiveToTwentynine
    case thirtyToThirtyFour
    case thirtyfiveToThirtynine
    case fourties
    case fifties
    case overSixty
    
    var name: String {
        switch self {
        case .underNine: return "9세 이하"
        case .tenToNineTeen: return "10~19세"
        case .twentyToTwentyfour: return "20~24세"
        case .twentyfiveToTwentynine: return "25~29세"
        case .thirtyToThirtyFour: return "30~34세"
        case .thirtyfiveToThirtynine: return "35~39세"
        case .fourties: return "40대"
        case .fifties: return "50대"
        case .overSixty: return "60세 이상"
        }
    }
    
    // 사용 X
    var serverName: String { "" }
    
    var tagTextColor: UIColor? {
        UIColor.violet_6D5999
    }
    
    var tagBackgroundColor : UIColor? {
        UIColor.gray_EEEFEF
    }
    
    var tagCornerRadius: CGFloat? {
        return 11
    }
    
    var ageMax: Int {
        switch self {
        case .underNine: 9
        case .tenToNineTeen: 19
        case .twentyToTwentyfour: 24
        case .twentyfiveToTwentynine: 29
        case .thirtyToThirtyFour: 34
        case .thirtyfiveToThirtynine: 39
        case .fourties: 49
        case .fifties: 59
        case .overSixty: 200
        }
    }
    
    var ageMin: Int {
        switch self {
        case .underNine: 0
        case .tenToNineTeen: 10
        case .twentyToTwentyfour: 20
        case .twentyfiveToTwentynine: 25
        case .thirtyToThirtyFour: 30
        case .thirtyfiveToThirtynine: 35
        case .fourties: 40
        case .fifties: 50
        case .overSixty: 60
        }
    }
}
