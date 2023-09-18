//
//  FindIDCell.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 2023/09/10.
//

import UIKit
import RxSwift

class FindIDCell: UICollectionViewCell {
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var authCodeView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    var timer: Timer?
    var leftSeconds = 180
    var phoneNumberSubject = BehaviorSubject<String>(value: "")
    
    lazy var phoneNumberIsValidSubject: Observable<Bool> = {
        phoneNumberSubject
            .filter { $0 != "" }
            .map { $0.hasPrefix("010") && $0.count == 11 }
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        phoneNumberTextField.rx.text.orEmpty
            .bind(to: phoneNumberSubject)
            .disposed(by: rx.disposeBag)
        
        phoneNumberIsValidSubject
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { (owner, isValid) in
                owner.sendButton.isEnabled = isValid
                let color: UIColor = isValid ? .red_F43663 : .gray_D9D9D9
                owner.sendButton.setTitleColor(color, for: .normal)
                owner.sendButton.borderColor = color
                
            }).disposed(by: rx.disposeBag)
        
        sendButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { _ in
                self.sendButton.setTitle("재전송", for: .normal)
                self.authCodeView.isHidden = false
                self.startTimer()
            }).disposed(by: rx.disposeBag)
    }
    
    func startTimer() {
        //기존에 타이머 동작중이면 중지 처리
        if timer != nil && timer!.isValid {
            timer!.invalidate()
        }
        
        //1초 간격 타이머 시작
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        if leftSeconds > 0 {
            leftSeconds -= 1
            let timerString = String(format:"%02d:%02d", Int(leftSeconds/60), leftSeconds%60)
            timeLabel.text = timerString
        } else {
            timer?.invalidate()
            timer = nil
            timeLabel.text = "00:00"
        }
    }
}
