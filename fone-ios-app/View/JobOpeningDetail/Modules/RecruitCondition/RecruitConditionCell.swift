//
//  RecruitConditionCell.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 11/12/23.
//

import UIKit

struct RecruitCondition {
    let type, recruitmentEndDate, dday, casting, gender, career: String
    let domains: [String]
    let numberOfRecruits, ageMin, ageMax: Int
    
    init?(type: String?, recruitmentEndDate: String?, dday: String?, casting: String?, gender: String?, career: String?, domains: [String]?, numberOfRecruits: Int?, ageMin: Int?, ageMax: Int?) {
        guard let type = type, let recruitmentEndDate = recruitmentEndDate, let dday = dday, let casting = casting, let gender = gender, let career = career, let domains = domains, let numberOfRecruits = numberOfRecruits, let ageMin = ageMin, let ageMax = ageMax else { return nil }
        self.type = type
        self.recruitmentEndDate = recruitmentEndDate
        self.dday = dday
        self.casting = casting
        self.gender = gender
        self.career = career
        self.domains = domains
        self.numberOfRecruits = numberOfRecruits
        self.ageMin = ageMin
        self.ageMax = ageMax
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
        genderLabel.text = GenderType(rawValue: recruitCondition.gender)?.string
        ageLabel.text = "\(recruitCondition.ageMin) ~ \(recruitCondition.ageMax)살"
        careerLabel.text = CareerType(rawValue: recruitCondition.career)?.string
    }
}
