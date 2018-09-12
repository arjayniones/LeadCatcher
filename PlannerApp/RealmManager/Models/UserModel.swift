//
//  UserModel.swift
//  PlannerApp
//
//  Created by Lim Ai Zhi on 07/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class UserModel: Model {
    @objc dynamic var U_Username: String = "";
    @objc dynamic var U_Password: String = "";
    @objc dynamic var U_EnableTouchID: Bool = false;
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        U_Username    <- map["U_UserName"]
        U_Password    <- map["U_Password"]
        U_EnableTouchID <- map["U_EnableTouchID"]
    }
    
    func newInstance() -> UserModel {
        let userInfo = UserModel()
        userInfo.id = uuid()
        userInfo.created_at = Date().toRFC3339String()
        userInfo.updated_at = Date().toRFC3339String()
        userInfo.deleted_at = ""
        
        return userInfo
    }
    
}

