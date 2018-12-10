//
//  UserFiles.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 07/12/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class UserFiles: Model {
    @objc dynamic var filename: String = "";
    @objc dynamic var fileType: String = "";
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        filename    <- map["filename"]
        fileType    <- map["fileType"]
    }
    
    func newInstance() -> UserFiles {
        let userFiles = UserFiles()
        
        userFiles.id = uuid()
        userFiles.created_at = Date()
        userFiles.updated_at = Date()
        userFiles.deleted_at = nil
        
        return userFiles
    }
    
}
