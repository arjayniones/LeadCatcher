//
//  SessionService.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 06/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

extension DefaultsKeys {
    static let SessionUserId = DefaultsKey<UUID?>("session_user_id")
}

class SessionService {

    static var isLoggedIn: Bool {
        return Defaults[.SessionUserId] != nil
    }
    
    private static var logoutCallbacks: [(performAlways: Bool, fn: () -> ())] = []
    
    static func logout() {
        for (_, fn) in logoutCallbacks {
            fn()
        }
        
        Defaults[.SessionUserId] = nil
        
        logoutCallbacks = logoutCallbacks.filter { (performAlways, _) in performAlways }
    }
    
    static func onLogout(performAlways: Bool = false, fn: @escaping () -> ()) {
        logoutCallbacks.append((performAlways, fn))
    }
}
