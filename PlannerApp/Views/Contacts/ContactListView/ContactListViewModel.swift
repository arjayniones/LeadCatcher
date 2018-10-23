//
//  ContactListViewModel.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 24/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import RealmSwift
import Kingfisher

class ContactListViewModel {
    var contactList:Results<ContactModel>?
   
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
        self.filteredContacts = contactList?.filter(predicate)
    }
    
    func removeImage(id:UUID) {
        ImageCache.default.removeImage(forKey: "profile_"+id, fromDisk: true)
    }
    
    func filterContact(isPotential:Bool) {
        
        if isPotential {
            contactList = realmStore.models(query: "C_Scoring >= 3 && deleted_at == nil")?
                .sorted(byKeyPath: "C_Scoring", ascending: false)
        } else {
            contactList = realmStore.models(query: "deleted_at == nil")
        }
    }
        
}
