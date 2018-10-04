//
//  ActionButton.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 06/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit

class ActionButton: UIButton {
    
    var isActive:Bool = false {
        didSet {
            backgroundColor = isActive ? UIColor.red.withAlphaComponent(0.2):.clear
        }
    }
    
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel?.font = UIFont.ofSize(fontSize: 17, withType: .regular)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

