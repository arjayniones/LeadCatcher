//
//  ContactListViewModel.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 24/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import RealmSwift

class ContactListViewModel {
    let contactList:Results<ContactModel>?
   
    var notificationToken: NotificationToken? = nil
    var filteredContacts: Results<ContactModel>?
    var subpredicates = ["C_Name", "C_MobilePhoneNo","C_Email"]
    
    let realmStore = RealmStore<ContactModel>()
    
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
