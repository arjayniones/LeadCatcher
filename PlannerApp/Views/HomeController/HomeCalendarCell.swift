//
//  HomeCalendarCell.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 03/10/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import FSCalendar
import UIKit

class HomeCalendarCell: FSCalendarCell {
    
//    weak var circleImageView: UIImageView!
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
//        let circleImageView = UIImageView(image: UIImage(named: "push-pin")!)
//        self.contentView.insertSubview(circleImageView, at: 0)
//        self.circleImageView = circleImageView
        
        self.shapeLayer.isHidden = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        self.circleImageView.frame = CGRect(x: self.contentView.center.x, y: self.contentView.center.y - 32, width: 32, height: 32)
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
