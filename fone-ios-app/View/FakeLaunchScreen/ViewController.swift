//
//  ViewController.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/08/05.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    private let imageView = UIImageView(image: UIImage(resource: .logoFilmOne))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black_000000
        
        view.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(80)
        }
    }


}

