//
//  CalendarViewController.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 11/9/23.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController {
    @IBOutlet weak var calendar: FSCalendar!
    
    private var firstDate: Date?
    private var lastDate: Date?
    private var datesRange: [Date]?
    private var multipleDates: [String] = []
    
    let dateFormatter = DateFormatter()
    
    fileprivate var lightPink =  UIColor(red: 206/255, green: 11/255, blue: 57/255, alpha: 1)
    fileprivate var darkPink =  UIColor(red: 255/255, green: 235/255, blue: 240/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar.delegate = self
        calendar.dataSource = self
        
        calendar.scrollDirection = .vertical
        calendar.allowsMultipleSelection = true
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        datesRange = []
        multipleDates.removeAll()
        calendar.reloadData()
        if firstDate == nil {
            firstDate = date
            datesRange = [firstDate!]
            print("datesRange contains: \(datesRange!)")
            return
        }
        // only first date is selected:
        if firstDate != nil && lastDate == nil {
            if date <= firstDate! {
                calendar.deselect(firstDate!)
                firstDate = date
                datesRange = [firstDate!]
                print("datesRange contains1: \(datesRange!)")
                self.configureVisibleCells()
                return
            }
            var range = datesRange(from: firstDate!, to: date)
            range.remove(at: 0)
            range = range.dropLast()
            lastDate = range.last
            datesRange = range
            print("datesRange contains2: \(datesRange!)")
            self.multipleDates = covertDatesToStrArray(dateArr: datesRange!)
            self.configureVisibleCells()
            return
        }
        // both are selected:
        if firstDate != nil && lastDate != nil {
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }
            lastDate = nil
            firstDate = nil
            datesRange = []
            print("datesRange contains3: \(datesRange!)")
        }
        self.configureVisibleCells()
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        for (i,_) in datesRange!.enumerated() {
            if date == datesRange![i] {
                datesRange?.remove(at: i)
                break
            }
        }
        self.multipleDates = covertDatesToStrArray(dateArr: datesRange!)
        self.configureVisibleCells()
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    func covertDatesToStrArray(dateArr: [Date]) -> [String] {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let stringDates = dateArr.map { dateFormatter.string(from: $0) }
        return stringDates
    }
    
    func datesRange(from: Date, to: Date) -> [Date] {
        if from > to { return [Date]() }
        var tempDate = from
        var array = [tempDate]
        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }
        return array
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        if self.multipleDates.contains(dateString){
            return #colorLiteral(red: 1, green: 0.9215686275, blue: 0.9411764706, alpha: 1)
        } else {
            let calendar = Calendar.current
            let weekday = calendar.component(.weekday, from: date)
            if weekday == 7 { // Saturday is represented by 7
                return UIColor.white
            }
        }
        return nil // Return nil for default appearance
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        debugPrint(dateString)
        
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        if self.multipleDates.contains(dateString){
            return UIColor.white
        }else if weekday == 7{
            return UIColor.black
        } else {
            return UIColor.white
        }
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        self.configureCell(cell: cell, for: date, at: position)
    }
    
    // MARK: - Private functions
    private func configureVisibleCells() {
        calendar.visibleCells().forEach { (cell) in
            let date = calendar.date(for: cell)
            let position = calendar.monthPosition(for: cell)
            self.configureCell(cell: cell, for: date!, at: position)
        }
    }
    
    private func configureCell(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        guard firstDate != nil, lastDate != nil else { return }
        
//        if (position != .current) {
//            rangeCell.middleLayer.isHidden = true
//            rangeCell.selectionLayer.isHidden = true
//        }
//        
        if date == firstDate {
            cell.cornerRadius = 20
            cell.contentView.backgroundColor = darkPink
        } else if date == lastDate {
            cell.cornerRadius = 20
            cell.contentView.backgroundColor = darkPink
        } else if date >= firstDate! && date <= lastDate! {
            cell.cornerRadius = 0
            cell.contentView.backgroundColor = lightPink
        } else { return }
    }
}
