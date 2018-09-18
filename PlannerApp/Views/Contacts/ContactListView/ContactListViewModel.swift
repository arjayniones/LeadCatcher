//
//  ContactListViewModel.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 18/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import Foundation

import SwiftyUserDefaults


class ContactListViewModel {
    static func getContactListNames() -> [ContactListNames]{
        let labelNames = [
            
            ContactListNames(contactName: "name 1"),
            ContactListNames(contactName: "name 2"),
            ContactListNames(contactName: "name 3"),
            ContactListNames(contactName: "name 4"),
            ContactListNames(contactName: "name 5"),
            ContactListNames(contactName: "name 6")
            
        ] // write loop here to populate
        return labelNames
        
}

}

struct ContactListNames {
    let contactName:String?
    
}
