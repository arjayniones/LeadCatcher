//
//  ContactDetailsViewModel.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 18/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import RealmSwift

class ContactDetailsViewModel {
    var detailRows:[AddTodoViewObject] = []
    
    init() {
        let rowData = [["icon":"person-icon","title":"Name"],
                           ["icon":"calendar-icon","title":"Date of Birth"],
                           ["icon":"location-icon","title":"Address"],
                           ["icon":"phone-icon","title":"Phone Number"],
                           ["icon":"email-icon","title":"Email"],
                           ["icon":"notes-icon","title":"Leads Scoring"],
                           ["icon":"subject-icon","title":"Write Remarks"],
                           ["icon":"task-icon","title":"Status"]]
        
        for row in rowData {
            let a = AddTodoViewObject()
            a.icon = row["icon"]!
            a.title = row["title"]!
            self.detailRows.append(a)
        }
    }
}
