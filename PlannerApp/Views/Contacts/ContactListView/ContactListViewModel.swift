//
//  ContactListViewModel.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 18/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import RealmSwift

class ContactListViewModel {
    let contactList:Results<ContactModel>?
    
    init() {
        
        contactList = RealmStore.models(type: ContactModel.self)
    }
        
}
