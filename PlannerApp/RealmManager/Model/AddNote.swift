//
//  AddNoteModel.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 19/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import ObjectMapper
import CoreLocation

class AddNote: Model {
    @objc dynamic var addNote_alertDateTime: Date?
    @objc dynamic var addNote_repeat: String = ""
    @objc dynamic var addNote_subject: String = ""
    @objc dynamic var addNote_customerId: UUID?
    @objc dynamic var addNote_taskType: String = ""
    @objc dynamic var addNote_notes: String = ""
    var addNote_location:CLLocation?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
//        U_Username    <- map["U_UserName"]
//        U_Password    <- map["U_Password"]
//        U_EnableTouchID <- map["U_EnableTouchID"]
    }
    
    func newInstance() {
        id = uuid()
        created_at = Date()
        updated_at = Date()
    }
}
