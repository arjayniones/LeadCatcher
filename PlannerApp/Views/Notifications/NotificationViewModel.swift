//
//  NotificationViewModel.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 02/10/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import Foundation

import RealmSwift

class NotificationViewModel {
    let contactList:Results<ContactModel>?
    var notificationToken: NotificationToken? = nil
    var filteredContacts: Results<ContactModel>?
    var subpredicates = ["C_Name", "C_MobilePhoneNo","C_Email"]
    var realmStore = RealmStore<ContactModel>()
    
    init() {
        contactList = realmStore.models(query: "deleted_at == nil")
    }
    
    
    func searchText(text:String) {
        let subpredicates = self.subpredicates.map { property in
            NSPredicate(format: "%K CONTAINS %@ && deleted_at == nil", property, text)
        }
        let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: subpredicates)
        self.filteredContacts = realmStore.models().filter(predicate)
    }
    
}
