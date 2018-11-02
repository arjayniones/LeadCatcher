//
//  SummaryViewModel.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 25/10/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import Kingfisher

class SummaryViewModel {
    var detailRows:[SummaryCollectionViewObjects] = []
    var contactList:Results<ContactModel>?
    var todoList: Results<AddNote>?
    var notificationToken: NotificationToken? = nil
    var filteredContacts: Results<ContactModel>?
    
    let realmStoreContact = RealmStore<ContactModel>()
    let realmStoreTodo = RealmStore<AddNote>()
    
    init() {
        
        let row1 = SummaryCollectionViewObjects()
        row1.nameLbl = "No. of Leads"
        contactList = realmStoreContact.models(query: "deleted_at == nil")
        row1.valueLbl = (contactList?.count)!
        self.detailRows.append(row1)
        
        let row2 = SummaryCollectionViewObjects()
        row2.nameLbl = "No. of Potential"
        contactList = realmStoreContact.models(query: "C_Status == 'Potential' && deleted_at == nil")
        row2.valueLbl = (contactList?.count)!
        self.detailRows.append(row2)
        
        let row3 = SummaryCollectionViewObjects()
        row3.nameLbl = "No. of Customers"
        contactList = realmStoreContact.models(query: "C_Status == 'Customer' && deleted_at == nil")
        row3.valueLbl = (contactList?.count)!
        self.detailRows.append(row3)
        
        let row4 = SummaryCollectionViewObjects()
        row4.nameLbl = "No. of Appointments"
        todoList = realmStoreTodo.models()
        row4.valueLbl =  (todoList?.count)!
        self.detailRows.append(row4)
        
        let row5 = SummaryCollectionViewObjects()
        row5.nameLbl = "No. Follow-Ups"
        row5.valueLbl = 0
        self.detailRows.append(row5)
        
        let row6 = SummaryCollectionViewObjects()
        row6.nameLbl = "No. of Disqualified"
        contactList = realmStoreContact.models(query: "C_Status == 'Disqualified' && deleted_at == nil")
        
        row6.valueLbl = (contactList?.count)!
        self.detailRows.append(row6)
        
        
    }
    
    
}

    
    
    

