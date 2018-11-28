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
    @objc dynamic var C_DateAdded:Date?;
    @objc dynamic var C_From:String = "";
    @objc dynamic var C_LastComm:String = "";
    @objc dynamic var C_ToFollow:String = "";
    //let ContactSocial = List<ContactSocial>();
    
    func newInstance() -> ContactModel {
        let contactInfo = ContactModel()
        contactInfo.id = uuid()
        contactInfo.created_at = Date()
        contactInfo.updated_at = Date()
        contactInfo.deleted_at = nil
        
        return contactInfo;
    }
    
}

class ContactHistory:Model{
    @objc dynamic var CH_CID:String = ""; // customer uuid
    @objc dynamic var CH_CallingDate:Date?;
    @objc dynamic var CH_HistoryType:String = ""; // contact history type
    
    func newInstance() -> ContactHistory{
        let contactHistory = ContactHistory();
        contactHistory.id = uuid();
        contactHistory.created_at = Date();
        contactHistory.updated_at = nil;
        contactHistory.deleted_at = nil;
        
        return contactHistory;
    }
    
}

class ContactSocial:Model{
    @objc dynamic var CS_CID:String = ""; // customer uuid
    @objc dynamic var CS_SocialType:String = ""; // social type like facebook, twitter
    @objc dynamic var CS_SocialUrl:String = "";
    
    func newInstance() -> ContactSocial{
        let contactSocial = ContactSocial();
        contactSocial.id = uuid();
        contactSocial.created_at = Date();
        contactSocial.updated_at = nil;
        contactSocial.deleted_at = nil;
        
        return contactSocial;
    }
    
}
