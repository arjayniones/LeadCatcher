//
//  LocationModel.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 24/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper

class LocationModel:Model {
    @objc dynamic var name: String = ""
    @objc dynamic var lat: Double = 0.0
    @objc dynamic var long: Double = 0.0
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        //
    }
    
    func newInstance() {
        id = uuid()
        created_at = Date()
        updated_at = Date()
    }
    
    
}
