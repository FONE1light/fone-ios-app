//
//  FilterViewController.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 12/25/23.
//

import UIKit

class FilterViewController: UIViewController, ViewModelBindableType {
    var viewModel: FilterViewModel!
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var genderClearButton: CustomButton!
    @IBOutlet weak var genderSelectionBlock: SelectionBlock!
    @IBOutlet weak var ageClearButton: CustomButton!
    @IBOutlet weak var ageSelectionView: FullWidthSelectionView!
    @IBOutlet weak var categoryClearButton: CustomButton!
    @IBOutlet weak var categorySelectionBlock: SelectionBlock!
    
    @IBOutlet weak var confirmButton: CustomButton!
    
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
                //TODO: 필터 조건 적용된 리스트 받아오기
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
    
    // TODO: 구현
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
}
