//
//  NotificationViewModel.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 02/10/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import Foundation
import RealmSwift

class NotificationViewModel {
    let tasks:Results<AddNote>?
    var notificationToken: NotificationToken? = nil
    var realmStore = RealmStore<AddNote>()
    
    init() {
        tasks = realmStore.models(query: "status != ''")
    }
    
}
