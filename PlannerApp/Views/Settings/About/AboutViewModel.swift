//
//  AboutViewModel.swift
//  PlannerApp
//
//  Created by Lim Ai Zhi on 27/12/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import Foundation
import UIKit

struct AboutViewModel {
    var companyLogoName:String = ""
    var companyName:String = "Software International Corporation (M) Sdn Bhd (354411-H)"
    var companyAddr:String = "Lot 1-1A, Support Service Building, Technology Park Malaysia, Bukit Jadil, 57000 Kuala Lumpur\n"
    var companyWebsite:String = "www.sicmsb.com\n"
    var companyEmail:String = "enquiry@sicmsb.com"
    
    
    func customStringValue(string1:String, string2:String) -> NSAttributedString {
        let attrs1 = [NSAttributedString.Key.font : UIFont.italicSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor : CommonColor.darkGrayColor]
        let attrs2 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor : CommonColor.systemBlueColor]
        let attributedString1 = NSMutableAttributedString(string:string1, attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string:string2, attributes:attrs2)
        
        attributedString1.append(attributedString2)
        return attributedString1
    }
}

