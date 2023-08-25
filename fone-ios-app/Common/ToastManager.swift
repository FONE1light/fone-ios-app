//
//  ToastManager.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/08/19.
//

import UIKit
import SnapKit

struct Application {
    static var keyWindow: UIWindow {
        return UIApplication.shared.windows.first { $0.isKeyWindow } ?? UIWindow()
    }
}

enum ToastPositionType {
    case withBottomSheet
    case withButton
    case withNothing
    // TODO: case withKeyboard
}

class ToastManager {
    static let toastWidth: CGFloat = UIScreen.main.bounds.size.width - 32
    
    // FIXME: completion이 필요없다면 삭제
    static func show(_ message: String, positionType: ToastPositionType = .withNothing, completion: (() -> Void)? = nil) {
        let toast = makeToastLabel(message: message)
        
        Application.keyWindow.addSubview(toast)
        setPosition(toast: toast, positionType: positionType)
        
        UIView.animate(withDuration: 2, delay: 0, options: []) {
            toast.alpha = 0.0
        } completion: { _ in
            toast.removeFromSuperview()
            completion?()
        }
    }
    
    fileprivate static func makeToastLabel(message: String) -> UILabel {
        return ToastLabel(message: message)
    }
    
    fileprivate static func setPosition(toast: UILabel, positionType: ToastPositionType) {
        toast.layoutIfNeeded()
        toast.preferredMaxLayoutWidth = toastWidth
        toast.translatesAutoresizingMaskIntoConstraints = false
        toast.invalidateIntrinsicContentSize()
        toast.sizeToFit()
        
        toast.snp.makeConstraints {
            $0.height.equalTo(toast.intrinsicContentSize.height)
            $0.width.equalTo(toastWidth)
            $0.centerX.equalTo(Application.keyWindow)
        }
        
        switch positionType {
        case .withBottomSheet:
            toast.snp.makeConstraints {
                $0.top.equalTo(Application.keyWindow).offset(54)
            }
        case .withButton:
            toast.snp.makeConstraints {
                $0.bottom.equalTo(Application.keyWindow).inset(102)
            }
        case .withNothing:
            toast.snp.makeConstraints {
                $0.bottom.equalTo(Application.keyWindow).inset(54)
            }
        }
    }
}

class ToastLabel: UILabel {
    let topInset: CGFloat = 15
    let bottomInset: CGFloat = 15
    let leftInset: CGFloat = 16
    let rightInset: CGFloat = 16
    
    convenience init(message: String) {
        self.init()
        self.layer.zPosition = 999
        
        self.backgroundColor = UIColor(hex: 0x362C4C)
        self.textColor = UIColor.white
        self.textAlignment = .left
        self.alpha = 0.9
        self.clipsToBounds = true
        self.layer.cornerRadius = 5
        self.font = UIFont.font_m(13)
        self.text = message
        self.numberOfLines = 0
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}
