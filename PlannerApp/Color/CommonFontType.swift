//
//  CommonFontType.swift
//  PlannerApp
//
//  Created by Lim Ai Zhi on 06/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit

public enum CommonFontType: String {
    case regular = "Regular"
    case bold = "Bold"
}

public extension UIFont {
    
    public class func ofSize(fontSize: CGFloat, withType type: CommonFontType) -> UIFont {
        
        switch type {
        case .regular: return UIFont(name: "SFProText-Regular", size: fontSize)!
        case .bold: return UIFont(name: "SFProText-Bold", size: fontSize)!
        }
    }
    
}
