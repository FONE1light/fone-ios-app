//
//  SNSImageView.swift
//  fone-ios-app
//
//  Created by 여나경 on 2/21/24.
//

import UIKit

enum SNSType {
    case instagram
    case youtube
    
    var selectedImage: UIImage? {
        switch self {
        case .instagram: UIImage(resource: .instagramButC)
        case .youtube: UIImage(resource: .youtubeButC)
        }
    }
    
    var deselectedImage: UIImage? {
        switch self {
        case .instagram: UIImage(resource: .instagramButG)
        case .youtube: UIImage(resource: .youtubeButG)
        }
    }
}

class SNSImageView: UIImageView {
    
    private let type: SNSType
    
    var isSelected: Bool = false {
        didSet {
            image = isSelected ? type.selectedImage : type.deselectedImage
        }
    }
    
    init(type: SNSType) {
        self.type = type
        super.init(frame: .zero)
        
        setupUI()
        setConstraints()
    }
    
    private func setupUI() {
        image = type.deselectedImage
    }
    
    private func setConstraints() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
