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
    
    func configure(salaryType: String?, salary: Int?, city: String?, district: String?, period: String?, workDays: [String]?, startTime: String?, endTime: String?) {
        let salaryType = SalaryType(rawValue: salaryType ?? "")
        salaryTypeLabel.text = salaryType?.string
        let salary = salaryType == .LATER_ON ? "" : "\(String(salary ?? 0).insertComma)원"
        salaryLabel.text = salary
        let location = city == "전체" ? "미정" : "\(city ?? "") \(district ?? "")"
        locationLabel.text = location
        periodLabel.text = period
        let time = startTime == nil ? "추후협의" : "\(startTime ?? "") ~ \(endTime ?? "")"
        workingTimeLabel.text = time
        if let workDays = workDays {
            var workDaysStr = ""
            for day in workDays {
                workDaysStr += "\(day.weekDay), "
            }
            workDaysLabel.text = String(workDaysStr.dropLast(2))
        }
    }
}
