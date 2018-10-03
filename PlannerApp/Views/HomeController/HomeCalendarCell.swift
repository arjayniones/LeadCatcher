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
    
    weak var circleImageView: UIImageView!
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let circleImageView = UIImageView(image: UIImage(named: "circle")!)
        self.contentView.insertSubview(circleImageView, at: 0)
        self.circleImageView = circleImageView
        
        self.shapeLayer.isHidden = true
        self.backgroundColor = .clear
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.circleImageView.frame = self.contentView.bounds
    }
    
}
