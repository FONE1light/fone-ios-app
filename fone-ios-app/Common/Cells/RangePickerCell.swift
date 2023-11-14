//
//  RangePickerCell.swift
//  fone-ios-app
//
//  Created by Yukyung Huh on 11/14/23.
//

import UIKit
import FSCalendar

class RangePickerCell: FSCalendarCell {
    weak var selectionLayer: CAShapeLayer!
    weak var middleLayer: CAShapeLayer!
    
    fileprivate var lightPink =  UIColor(red: 206/255, green: 11/255, blue: 57/255, alpha: 1)
    fileprivate var darkPink =  UIColor(red: 255/255, green: 235/255, blue: 240/255, alpha: 1)
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let selectionLayer = CAShapeLayer()
        selectionLayer.fillColor = darkPink.cgColor
        selectionLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(selectionLayer, below: self.titleLabel!.layer)
        self.selectionLayer = selectionLayer
        
        let middleLayer = CAShapeLayer()
        middleLayer.fillColor = lightPink.cgColor
        middleLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(middleLayer, below: self.titleLabel!.layer)
        self.middleLayer = middleLayer
        
        self.shapeLayer.isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.titleLabel.frame = self.contentView.bounds
    }
    
    override func layoutSublayers(of layer: CALayer) {
        self.selectionLayer.frame = self.contentView.bounds
        self.middleLayer.frame = self.contentView.bounds
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        // Override the build-in appearance configuration
        if self.isPlaceholder {
            self.eventIndicator.isHidden = true
            self.titleLabel.textColor = UIColor.lightGray
        }
    }
}
