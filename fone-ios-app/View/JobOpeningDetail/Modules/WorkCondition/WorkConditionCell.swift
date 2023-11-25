//
//  WorkConditionCell.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 11/12/23.
//

import UIKit

class WorkConditionCell: UICollectionViewCell {
    @IBOutlet weak var salaryTypeLabel: UILabel!
    @IBOutlet weak var salaryLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var workDaysLabel: UILabel!
    @IBOutlet weak var workingTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(salaryType: String?, salary: Int?, location: String?, period: String?, workDays: [String]?, workingTime: String?) {
        salaryTypeLabel.text = SalaryType(rawValue: salaryType ?? "")?.string
        salaryLabel.text = "\(String(salary ?? 0).insertComma)원"
        locationLabel.text = location
        periodLabel.text = period
        workingTimeLabel.text = workingTime
        if let workDays = workDays {
            var workDaysStr = ""
            for day in workDays {
                workDaysStr += "\(day.weekDay), "
            }
            workDaysLabel.text = String(workDaysStr.dropLast(2))
        }
    }
}
