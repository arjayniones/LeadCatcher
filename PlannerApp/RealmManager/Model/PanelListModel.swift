//
//  PanelListModel.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 08/10/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class PanelListModel:Model{
    @objc dynamic var panelName: String = ""
    @objc dynamic var phoneNum: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var address: String = ""
    @objc dynamic var lat: Double = 0.0
    @objc dynamic var long: Double = 0.0
    @objc dynamic var location:LocationModel?
    
    
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
