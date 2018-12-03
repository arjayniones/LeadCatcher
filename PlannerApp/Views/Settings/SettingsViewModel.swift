//
//  SettingsViewModel.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 07/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import Foundation
import SwiftyUserDefaults


class SettingsViewModel {
    static func getSettingsLabels() -> [SettingsLabels]{
        let labelNames = [
            //SettingsLabels(labelName: "Security"),
            SettingsLabels(labelName: "Summary"),
            //SettingsLabels(labelName: "Panel List"),
            SettingsLabels(labelName: "Map"),
            SettingsLabels(labelName: "Sync Phone Book Contacts"),
            SettingsLabels(labelName: "Message Templates"),
            //SettingsLabels(labelName: "Language"),
            SettingsLabels(labelName: "Resources"),
            SettingsLabels(labelName: "Change Background"),
            //SettingsLabels(labelName: "Log Out")
        ]
        return labelNames
        
    }
    
    
    
    
}

struct SettingsLabels {
    let labelName:String?
    
}
