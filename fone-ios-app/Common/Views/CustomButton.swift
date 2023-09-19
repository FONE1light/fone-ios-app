//
//  CustomButton.swift
//  fone-ios-app
//
//  Created by 여나경 on 2023/09/04.
//

import UIKit
import RxRelay

enum ButtonDesignType {
    case auth // 회원가입 - 인증에 사용되는 버튼
    case bottom // 하단 버튼 - '다음', '로그인하기' 등
}

extension ButtonDesignType {
    
    var titleFont: UIFont? {
        switch self {
        case .auth: return .font_r(14)
        case .bottom: return .font_m(16)
        }
    }
    
    var disabledTitleColor: UIColor? {
        switch self {
        case .auth: return .gray_9E9E9E
        default: return nil
        }
    }
    
    var defaultTitleColor: UIColor? {
        switch self {
        case .auth: return .red_CE0B39
        case .bottom: return .white_FFFFFF
        }
    }
    
    var disabledBorderColor: UIColor? {
        switch self {
        case .auth: return .gray_D9D9D9
        default: return nil
        }
    }
    
    var defaultBorderColor: UIColor? {
        switch self {
        case .auth: return .red_F43663
        default: return nil
        }
    }
    
    var disabledBackgroundColor: UIColor? {
        switch self {
        default: return nil
        }
    }
    
    var defaultBackgroundColor: UIColor? {
        switch self {
        case .bottom: return .red_C0002C
        default: return nil
        }
    }

    var shadowType: ShadowType? {
        switch self {
        case .bottom: return .shadowBt
        default: return nil
        }
    }
}

class CustomButton: UIButton {
    
    private var disabledBackgroundColor: UIColor?
    private var defaultBackgroundColor: UIColor? {
        didSet {
            backgroundColor = defaultBackgroundColor
        }
    }
    private var disabledTitleColor: UIColor?
    private var defaultTitleColor: UIColor? {
        didSet {
            setTitleColor(defaultTitleColor, for: .normal)
        }
    }
    private var disabledBorderColor: UIColor?
    private var defaultBorderColor: UIColor? {
        didSet {
            borderColor = defaultBorderColor ?? .black_000000
        }
    }
    
    // isEnabled 값이 바뀌었을 때 design properties 변경
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                if let color = defaultBackgroundColor {
                    self.backgroundColor = color
                }
                
                if let color = defaultTitleColor {
                    self.setTitleColor(color, for: .normal)
                }
                
                if let color = defaultBorderColor {
                    self.borderColor = color
                }
                
            } else {
                if let color = disabledBackgroundColor {
                    self.backgroundColor = color
                }
                
                if let color = disabledTitleColor {
                    self.setTitleColor(color, for: .disabled)
                }
                
                if let color = disabledBorderColor {
                    self.borderColor = color
                }
            }
        }
    }
    
    // isActivated 값이 바뀌었을 때 design properties 변경
    /// 활성화된 상태인지 아닌지
    /// - isEnabled와 비슷하나, UI는 비활성화 상태처럼 보이지만 선택 가능해야할 때 isActivated를 사용
    /// - 참고: 비활성화된 버튼을 눌렀을 때 활성화되어야 한다면 isEnabled 사용 불가능. isEnabled = false이면 rx.tap 클로저가 실행되지 않아서 특정 액션 연결 불가능하므로.
    var isActivated: Bool = false {
        didSet {
            if isActivated {
                if let color = defaultBackgroundColor {
                    self.backgroundColor = color
                }
                
                if let color = defaultTitleColor {
                    self.setTitleColor(color, for: .normal)
                }
                
                if let color = defaultBorderColor {
                    self.borderColor = color
                }
                
            } else {
                if let color = disabledBackgroundColor {
                    self.backgroundColor = color
                }
                
                if let color = disabledTitleColor {
                    self.setTitleColor(color, for: .normal)
                }
                
                if let color = disabledBorderColor {
                    self.borderColor = color
                }
            }
        }
    }
    
    init(_ title: String? = nil, type: ButtonDesignType? = nil) {
        super.init(frame: .zero)
        
        cornerRadius = 5
        setTitle(title, for: .normal)
        
        guard let type = type else { return }
        
        if let titleFont = type.titleFont {
            titleLabel?.font = titleFont
        }
        
        if let shadowType = type.shadowType {
            applyShadow(shadowType: shadowType)
        }
        
        // properties 초기화
        setBackgroundColor(type.defaultBackgroundColor, for: .normal)
        setBackgroundColor(type.disabledBackgroundColor, for: .disabled)
        
        defaultTitleColor = type.defaultTitleColor
        disabledTitleColor = type.disabledTitleColor
        
        guard type.defaultBorderColor != nil else { return }
        self.borderWidth = 1
        setBorderColor(type.defaultBorderColor, for: .normal)
        setBorderColor(type.disabledBorderColor, for: .disabled)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CustomButton {
    
    func setBackgroundColor(_ color: UIColor?, for state: UIControl.State) {
        switch state {
        case .disabled:
            disabledBackgroundColor = color
        case .normal:
            defaultBackgroundColor = color
        default: break
        }
    }
    
    func setBorderColor(_ color: UIColor?, for state: UIControl.State) {
        switch state {
        case .disabled:
            disabledBorderColor = color
        case .normal:
            defaultBorderColor = color
        default: break
        }
    }
}
