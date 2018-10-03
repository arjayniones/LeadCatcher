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
        
        let view = UIView(frame: self.bounds)
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.12)
        self.backgroundView = view;
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.circleImageView.frame = self.contentView.bounds
        self.backgroundView?.frame = self.bounds.insetBy(dx: 1, dy: 1)
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        // Override the build-in appearance configuration
        if self.isPlaceholder {
//            self.eventIndicator.isHidden = true
            self.titleLabel.textColor = UIColor.lightGray
        }
    }
    
}
