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
            SettingsLabels(labelName: "About"),
            //SettingsLabels(labelName: "Log Out")
        ]
        return labelNames
        
    }
    
    func dateFilterForClusterMapView()->NSPredicate
    {
        
        let todayStart = Calendar.current.startOfDay(for: Date())
        let todayEnd: Date = {
            let components = DateComponents(day: 1, second: -1)
            return Calendar.current.date(byAdding: components, to: todayStart)!
        }()
        
        let predicate = NSPredicate(format: "addNote_alertDateTime BETWEEN %@ ", [todayStart, todayEnd]);
        return predicate
        //let results = realmStoreContact.models().filter(predicate);
        
        //return results;
    }
}

struct SettingsLabels {
    let labelName:String?
    
}
