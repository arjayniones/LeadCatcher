//
//  ContactModel.swift
//  PlannerApp
//
//  Created by Lim Ai Zhi on 18/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class ContactModel:Model{
    @objc dynamic var C_Name:String = "";
    @objc dynamic var C_DOB:Date?;
    @objc dynamic var C_Address:String = "";
    @objc dynamic var C_PhoneNo:String = "";
    @objc dynamic var C_MobilePhoneNo:String = "";
    @objc dynamic var C_Email:String = "";
    @objc dynamic var C_Scoring:Int = 0;
    @objc dynamic var C_Remark:String = "";
    @objc dynamic var C_Status:String = "";
    @objc dynamic var C_From:String = "";
    @objc dynamic var C_LastComm:String = "";
    @objc dynamic var C_ToFollow:String = "";
    
    func newInstance() -> ContactModel {
        let contactInfo = ContactModel()
        contactInfo.id = uuid()
        contactInfo.created_at = Date()
        contactInfo.updated_at = Date()
        contactInfo.deleted_at = nil
        
        return contactInfo;
    }
    
}
