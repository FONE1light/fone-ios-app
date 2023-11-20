//
//  ContactInfoCell.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 11/12/23.
//

import UIKit

class ContactInfoCell: UICollectionViewCell {
    @IBOutlet weak var managerLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(manager: String?, email: String?) {
        managerLabel.text = manager
        emailLabel.text = email
    }
}
