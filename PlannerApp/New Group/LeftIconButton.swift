//
//  LeftIconButton.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 23/11/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit

class LeftIconButton: UIButton {
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentHorizontalAlignment = .left
        let availableSpace = bounds.inset(by: contentEdgeInsets)
        let availableWidth = availableSpace.width - imageEdgeInsets.right - (imageView?.frame.width ?? 0) - (titleLabel?.frame.width ?? 0)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: (availableWidth/2), bottom: 0, right: 0)
    }
}
