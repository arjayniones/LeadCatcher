//
//  SampleModel.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 07/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class SampleModel: Model {
    @objc dynamic var username: String = ""
    var lastname = List<SampleModel2>()
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        username    <- map["username"]
        lastname    <- map["lastname"]
    }
}
