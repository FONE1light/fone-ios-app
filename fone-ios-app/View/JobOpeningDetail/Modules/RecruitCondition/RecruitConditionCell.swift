//
//  RecruitConditionCell.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 11/12/23.
//

import UIKit

struct RecruitCondition {
    let type, recruitmentEndDate, dday, casting, gender: String
    let career, domains: [String]
    let numberOfRecruits, ageMin, ageMax: Int
    
    init?(type: String?, recruitmentEndDate: String?, dday: String?, recruitConditionInfo: RecruitConditionInfo?) {
        self.type = type ?? ""
        self.recruitmentEndDate = recruitmentEndDate ?? ""
        self.dday = dday ?? ""
        self.casting = recruitConditionInfo?.casting ?? ""
        self.gender = recruitConditionInfo?.gender ?? ""
        self.career = recruitConditionInfo?.career ?? []
        self.domains = recruitConditionInfo?.domains ?? []
        self.numberOfRecruits = recruitConditionInfo?.numberOfRecruits ?? 0
        self.ageMin = recruitConditionInfo?.ageMin ?? 0
        self.ageMax = recruitConditionInfo?.ageMax ?? 0
    }
}

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
    
    func configure(recruitCondition: RecruitCondition) {
        typeLabel.text = recruitCondition.type == Job.actor.name ? "모집배역" : "모집분야"
        deadLineLabel.text = recruitCondition.recruitmentEndDate
        ddayLabel.text = recruitCondition.dday
        ddayLabel.textColor = recruitCondition.dday == "마감" ? .gray_9E9E9E : .violet_6D5999
        castingLabel.text = recruitCondition.casting
        numberOfRecruitsLabel.text = String(recruitCondition.numberOfRecruits)
        genderLabel.text = GenderType.getType(serverName: recruitCondition.gender)?.name
        ageLabel.text = "\(recruitCondition.ageMin) ~ \(recruitCondition.ageMax)살"
        var careerStr = ""
        for career in recruitCondition.career {
            careerStr += "\(CareerType(rawValue: career)?.string ?? ""), "
        }
        careerLabel.text =  String(careerStr.dropLast(2))
    }
}
