//
//  DatePickerViewController.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 11/25/23.
//

import UIKit

protocol DateTimePickerVCDelegate: AnyObject {
    func updateDateTime(_ dateTime: String, label: UILabel?)
}

class DatePickerViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dimView: UIView!
    
    @IBAction func handleDatePicker(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy.MM.dd(EEEEE)"
        
        dateFormatter.string(from: self.datePicker.date)
        
        self.delegate?.updateDateTime(dateFormatter.string(from: self.datePicker.date),label: resultLabel)
        self.dismiss(animated: false)
    }
    weak var delegate: DateTimePickerVCDelegate?
    var resultLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDatePicker()
        initUI()
    }
    
    func setDatePicker() {
        datePicker.preferredDatePickerStyle = .inline
        
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.calendar.locale = Locale(identifier: "ko_KR")
        
        datePicker.timeZone = .autoupdatingCurrent
        datePicker.setValue(UIColor.white, forKey: "backgroundColor")
        datePicker.minimumDate = Date()
    }
    
    func initUI() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.delegate = self
        self.dimView.addGestureRecognizer(tapGesture)
        
        setDatePicker()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive event: UIEvent) -> Bool {
        self.dismiss(animated: false)
        return true
    }
}
