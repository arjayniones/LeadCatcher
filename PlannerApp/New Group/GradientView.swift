//
//  GradientView.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 26/11/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit

class GradientView: UIView {
    
    var colors:[CGColor] = [UIColor.lightGray.cgColor,UIColor.white.cgColor]
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations: [CGFloat] = [0.0, 1.0]
        let gradient = CGGradient(colorsSpace: colorSpace,
                                  colors: colors as CFArray,
                                  locations: colorLocations)!
        let startPoint = CGPoint(x: 0, y:0)
        let endPoint = CGPoint(x: 0, y: bounds.height)
        context.drawLinearGradient(gradient,
                                   start: startPoint,
                                   end: endPoint,
                                   options: [])
    }
}
