//
//  RecruitConditionCell.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 11/12/23.
//

import UIKit

class RecruitConditionCell: UICollectionViewCell {
    @IBOutlet weak var deadLineLabel: UILabel!
    @IBOutlet weak var ddayLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var castingLabel: UILabel!
    @IBOutlet weak var numberOfRecruitsLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var careerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(type: String, deadLine: String, dday: String ,casting: String, domains: [String], numberOfRecruits: Int, gender: String, ageMin: Int, ageMax: Int, career: String) {
        typeLabel.text = type == Job.actor.name ? "모집배역" : "모집분야"
        deadLineLabel.text = deadLine
        ddayLabel.text = dday
        ddayLabel.textColor = dday == "마감" ? .gray_9E9E9E : .violet_6D5999
        castingLabel.text = casting
        numberOfRecruitsLabel.text = String(numberOfRecruits)
        genderLabel.text = GenderType(rawValue: gender)?.string
        ageLabel.text = "\(ageMin) ~ \(ageMax)살"
        careerLabel.text = CareerType(rawValue: career)?.string
    }
}
