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
    @objc dynamic var addNote_location:LocationModel?
    @objc dynamic var status:Int = 0
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
    }
    
    func newInstance() -> UUID {
        id = uuid()
        created_at = Date()
        updated_at = Date()
        
        return id
    }
}
