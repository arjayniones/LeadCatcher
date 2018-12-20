//
//  ContactListViewModel.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 24/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import RealmSwift
import Kingfisher
import UIKit

class ContactListViewModel {
    var contactList:Results<ContactModel>?
   
    var notificationToken: NotificationToken? = nil
    var filteredContacts: Results<ContactModel>?
    var subpredicates = ["C_Name", "C_MobilePhoneNo","C_Email"]
    
    let realmStore = RealmStore<ContactModel>()
    
    init() {
        contactList = realmStore.models(query: "deleted_at == nil")
    }
    
    func searchText(text:String, status:String) {
        if status != "All"
        {
            let subpredicates = self.subpredicates.map { property in
                NSPredicate(format: "%K CONTAINS %@ && deleted_at == nil && C_Status == %@", property, text, status)
            }
            let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: subpredicates)
            self.filteredContacts = contactList?.filter(predicate)
        }
        else
        {
            let subpredicates = self.subpredicates.map { property in
                NSPredicate(format: "%K CONTAINS %@ && deleted_at == nil", property, text)
            }
            let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: subpredicates)
            self.filteredContacts = contactList?.filter(predicate)
        }
        
    }
    
    func removeImage(id:UUID) {
        ImageCache.default.removeImage(forKey: "profile_"+id, fromDisk: true)
    }
    
    func filterContact(isPotential:Bool,isCustomer:Bool,isDisqualified:Bool) {
        
        if isPotential {
            contactList = realmStore.models(query: "C_Status == 'Potential' && deleted_at == nil")?
                .sorted(byKeyPath: "C_Scoring", ascending: false)
        } else if isCustomer {
            contactList = realmStore.models(query: "C_Status == 'Customer' && deleted_at == nil")?
                .sorted(byKeyPath: "C_Scoring", ascending: false)
            
        } else if isDisqualified {
            contactList = realmStore.models(query: "C_Status == 'Disqualified' && deleted_at == nil")
            print(contactList?.count)
            
        } else {
            contactList = realmStore.models(query: "deleted_at == nil")
        }
    }
    
    func filterLastContactedDate(customerId:String) -> Date? {
        if let data = RealmStore<ContactHistory>().models(query: "CH_CID == '\(customerId)'",
                                                          sortingKey: "created_at",
                                                          ascending: false) {
            return data.first?.created_at
        }
        return nil
    }
}
