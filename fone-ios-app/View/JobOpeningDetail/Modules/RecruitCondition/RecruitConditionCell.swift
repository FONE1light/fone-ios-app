//
//  RecruitConditionCell.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 11/12/23.
//

import UIKit

struct RecruitCondition {
    let type, recruitmentEndDate, dday, casting, gender: String
    let careers, domains: [String]
    let numberOfRecruits, ageMin, ageMax: Int
    
    init?(type: String?, recruitmentEndDate: String?, dday: String?, recruitConditionInfo: RecruitConditionInfo?) {
        self.type = type ?? ""
        self.recruitmentEndDate = recruitmentEndDate ?? ""
        self.dday = dday ?? ""
        self.casting = recruitConditionInfo?.casting ?? ""
        self.gender = recruitConditionInfo?.gender ?? ""
        self.careers = recruitConditionInfo?.careers ?? []
        self.domains = recruitConditionInfo?.domains ?? []
        self.numberOfRecruits = recruitConditionInfo?.numberOfRecruits ?? 0
        self.ageMin = recruitConditionInfo?.ageMin ?? 0
        self.ageMax = recruitConditionInfo?.ageMax ?? 0
    }
}

class RecruitConditionCell: UICollectionViewCell {
    @IBOutlet weak var deadLineLabel: UILabel!
    @IBOutlet weak var separator: UIImageView!
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
        let isActorOpening = recruitCondition.type == Job.actor.name
        typeLabel.text = isActorOpening ? "모집배역" : "모집분야"
        deadLineLabel.text = recruitCondition.recruitmentEndDate
        ddayLabel.text = recruitCondition.dday
        ddayLabel.textColor = recruitCondition.dday == "마감" ? .gray_9E9E9E : .violet_6D5999
        let isAlways = recruitCondition.recruitmentEndDate.isEmpty
        deadLineLabel.isHidden = isAlways
        separator.isHidden = isAlways
        if isActorOpening {
            castingLabel.text = recruitCondition.casting
        } else {
            var domainStr = ""
            for domain in recruitCondition.domains {
                if let name = Domain.getType(serverName: domain)?.name {
                    domainStr += "\(name), "
                }
            }
            castingLabel.text = String(domainStr.dropLast(2))
        }
        numberOfRecruitsLabel.text = String(recruitCondition.numberOfRecruits)
        genderLabel.text = GenderType.getType(serverName: recruitCondition.gender)?.name
        let age = recruitCondition.ageMin <= 0 ? "연령무관" : "\(recruitCondition.ageMin) ~ \(recruitCondition.ageMax)살"
        ageLabel.text = age
        var careerStr = ""
        for career in recruitCondition.careers {
            careerStr += "\(CareerType(rawValue: career)?.string ?? ""), "
        }
        careerLabel.text =  String(careerStr.dropLast(2))
    }
}

extension RecruitConditionCell {
    static func cellHeight(_ item: [String]?) -> CGFloat {
        guard let item = item else { return 244 }
        var careerStr = ""
        for career in item {
            careerStr += "\(CareerType(rawValue: career)?.string ?? ""), "
        }
        let height = UILabel.getLabelHeight(width: UIScreen.main.bounds.width - 108, text: careerStr, font: UIFont.font_r(14), line: 0)
        return height + 224
    }
}
