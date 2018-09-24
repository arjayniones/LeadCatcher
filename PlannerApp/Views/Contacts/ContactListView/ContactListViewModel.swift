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
    var subpredicates = ["addNote_subject", "addNote_notes"]
    
    init() {
        
        contactList = RealmStore.models(type: ContactModel.self)
    }
        
}
