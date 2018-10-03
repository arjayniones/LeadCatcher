//
//  SummaryBarEntry.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 02/10/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import Foundation

import Foundation
import UIKit

struct SummaryBarEntry {
    let color: UIColor
    
    /// Ranged from 0.0 to 1.0
    let height: Float
    
    /// To be shown on top of the bar
    let textValue: String
    
    /// To be shown at the bottom of the bar
    let title: String
}
