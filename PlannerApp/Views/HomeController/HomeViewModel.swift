//
//  HomeViewModel.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 02/10/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import RealmSwift

class HomeViewModel {
    
    var notificationToken: NotificationToken? = nil
    private let realmStore = RealmStore<AddNote>()
    var notes:Results<AddNote>?
    
    init() {
        notes = realmStore.models(query: "deleted_at == nil")
    }
}
