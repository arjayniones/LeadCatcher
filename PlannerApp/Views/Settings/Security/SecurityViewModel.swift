//
//  SecurityViewModel.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 07/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import Foundation
import SwiftyUserDefaults


class SecurityViewModel {
    static let realmStore = RealmStore<UserModel>()
    
    static func getSecurityLabels() -> [SecurityLabels]{
        let labelNames = [
            SecurityLabels(labelName: "Use Touch ID"),
            SecurityLabels(labelName: "Change Passcode")
        ] 
        return labelNames
    }
    
    static func enableTouchID(bool:Bool) {

        if let update = realmStore.models(query: "id = '\(Defaults[.SessionUserId]!)'")?.first {
            try! realmStore.write {
                update.U_EnableTouchID = bool
            }
        }
    }
    
     func checkTouchIDUpdate() -> Bool{
        if let update = SecurityViewModel.realmStore.models(query: "id = '\(Defaults[.SessionUserId]!)'")?.first {
              return update.U_EnableTouchID
        }
            
        return false
    }
}


struct SecurityLabels {
    let labelName:String?
    
}
