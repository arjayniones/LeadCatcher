//
//  SettingsViewModel.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 07/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import Foundation


class SettingsViewModel {
    static func getSettingsLabels() -> [SettingsLabels]{
        let labelNames = [
            SettingsLabels(labelName: "Security"),
            SettingsLabels(labelName: "Summary"),
            SettingsLabels(labelName: "Notifications"),
            SettingsLabels(labelName: "Panel List"),
            SettingsLabels(labelName: "Map"),
            SettingsLabels(labelName: "Sync Phone Book Contacts"),
            SettingsLabels(labelName: "Message Settings"),
            SettingsLabels(labelName: "Language"),
            SettingsLabels(labelName: "Archives"),
            SettingsLabels(labelName: "Change Password"),
            SettingsLabels(labelName: "Log Out")
        ]
        return labelNames
        
    }
}


struct SettingsLabels {
    let labelName:String?
    
}
