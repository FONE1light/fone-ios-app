//
//  UIImageView+Extension.swift
//  fone-ios-app
//
//  Created by 여나경 on 12/12/23.
//

import UIKit

extension UIImageView {
    /// `url`로부터 이미지를 로드함
    func load(url stringUrl: String?) {
        guard let url = stringUrl?.url else { return }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
