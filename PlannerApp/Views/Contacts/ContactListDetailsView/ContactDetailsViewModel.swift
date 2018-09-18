//
//  ContactDetailsViewModel.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 18/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import Foundation

import UIKit

class ContactDetailsViewModel {
    var detailRows:[[String:String]]
    
    init() {
        self.detailRows = [["icon":"person-icon","title":"Name"],
                           ["icon":"calendar-icon","title":"Date of Birth"],
                           ["icon":"location-icon","title":"Address"],
                           ["icon":"phone-icon","title":"Phone Number"],
                           ["icon":"email-icon","title":"Email"],
                           ["icon":"notes-icon","title":"Leads Scoring"],
                           ["icon":"subject-icon","title":"Write Remarks"],
                           ["icon":"task-icon","title":"Status"]
        ]
    }
}
