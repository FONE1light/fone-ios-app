//
//  WorkInfoCell.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 11/12/23.
//

import UIKit

class WorkInfoCell: UICollectionViewCell {
    @IBOutlet weak var produceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var logLineLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(produce: String?, title: String?, director: String?, genres: [String]?, logline: String?) {
        produceLabel.text = produce
        titleLabel.text = title
        directorLabel.text = director
        var genreString = ""
        for genre in genres ?? [] {
            genreString.append(Genre(rawValue: genre)?.koreanName ?? "")
        }
        logLineLabel.text = logline ?? "비공개"
    }
}

extension WorkInfoCell {
    static func cellHeight(_ item: String?) -> CGFloat {
        let height = UILabel.getLabelHeight(width: UIScreen.main.bounds.width - 138, text: item ?? "비공개", font: UIFont.font_r(14), line: 0)
        return height + 200
    }
}
