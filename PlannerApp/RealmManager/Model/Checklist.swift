//
//  Checklist.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 26/10/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class Checklist: Model {
    @objc dynamic var title: String = "";
    @objc dynamic var status: String = "";
    @objc dynamic var textTag: String = "";
    
    func newInstance() {
        id = uuid()
        created_at = Date()
        updated_at = Date()
    }
    
}


