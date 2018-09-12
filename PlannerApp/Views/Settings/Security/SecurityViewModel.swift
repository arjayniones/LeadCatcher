//
//  SecurityViewModel.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 07/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import Foundation


class SecurityViewModel {
    static func getSecurityLabels() -> [SecurityLabels]{
        let labelNames = [
            SecurityLabels(labelName: "Use Touch ID"),
            SecurityLabels(labelName: "Change Passcode")
        ] 
        return labelNames
    }
}


struct SecurityLabels {
    let labelName:String?
    
}
