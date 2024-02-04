//
//  SalaryTypeBottomSheet.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 1/28/24.
//

import UIKit
import RxRelay

class SalaryTypeBottomSheet: UIView {
    @IBOutlet weak var annualButton: UISortButton!
    @IBOutlet weak var monthlyButton: UISortButton!
    @IBOutlet weak var dailyButton: UISortButton!
    @IBOutlet weak var hourlyButton: UISortButton!
    @IBOutlet weak var perSessionButton: UISortButton!
    
    var salaryTypeRelay: PublishRelay<SalaryType>?
    
    init(frame: CGRect, salaryTypeRelay: PublishRelay<SalaryType>) {
        super.init(frame: frame)
        loadNib(SalaryTypeBottomSheet.self, relay: salaryTypeRelay)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    @IBAction func annualTapped(_ sender: UIButton) {
        let buttonTags = [1, 2, 3, 4, 5]
        
        buttonTags.filter { $0 != sender.tag }.forEach { tag in
            if let button = self.viewWithTag(tag) as? UIButton {
                button.isSelected = false
            }
            sender.isSelected = true
        }
        
        var salaryType = SalaryType.ANNUAL
        switch sender.tag {
        case 1: salaryType = .ANNUAL
        case 2: salaryType = .MONTHLY
        case 3: salaryType = .DAILY
        case 4: salaryType = .HOURLY
        case 5: salaryType = .PER_SESSION
        default:
            break
        }
        salaryTypeRelay?.accept(salaryType)
    }
}
