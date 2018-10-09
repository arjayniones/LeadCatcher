//
//  MessageTemplatesModel.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 09/10/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class MessageTemplatesModel:Model{
    @objc dynamic var msgTitle: String = ""
    @objc dynamic var msgBody: String = ""
   
 
    
    
    func newInstance() {
        id = uuid()
        created_at = Date()
        updated_at = Date()
    }
    
}
