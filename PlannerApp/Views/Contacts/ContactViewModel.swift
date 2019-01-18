//
//  ContactViewModel.swift
//  PlannerApp
//
//  Created by Lim Ai Zhi on 18/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import Foundation
import LocalAuthentication
import RealmSwift
import SwiftyUserDefaults
import Contacts

class ContactViewModel {
    private init()
    {
        
    }
    fileprivate static var realmStore = RealmStore<ContactModel>()
    
    class func processUserContact(contacts:[CNContact], completetion:@escaping(_ value:String)->Void)
    {
        // delete all the contact that 'C_From = PhoneBook' to prevent duplicate contact info
        //deletePhoneBookContact(from: "PhoneBook");
        
        for contact in contacts {
            print(contact.identifier)
            
            var cName = "\(contact.givenName) \(contact.familyName)";
            if cName.prefix(1) == " "
            {
                cName = contact.familyName
            }
            let cDOB = contact.birthday?.date as Date?;
            let cPhoneNumber:String = (contact.phoneNumbers.first?.value)?.stringValue ?? "";
            let cEmail = contact.emailAddresses.first?.value;
            var cAddress = "";
            
            if contact.postalAddresses.count > 0
            {
                cAddress = "\(contact.postalAddresses[0].value.street), \(contact.postalAddresses[0].value.city), \(contact.postalAddresses[0].value.state), \(contact.postalAddresses[0].value.country)";
            }
            
            // insert data into contact table
            let result = realmStore.models(query: "id == '\(contact.identifier)'")
            if result?.count == 0
            {
                let contactID = importDataContactModel(cName: cName, cDOB: cDOB, cPhoneNo: cPhoneNumber, cEmail: cEmail as String? ?? "", cFrom: "PhoneBook",cAddress: cAddress, contactIdentifier:contact.identifier );
                
                if contactID.count > 0
                {
                    //print("Success import contact from phone book");
                }
            }
            else
            {
                let contactID = updateDataContactModel(cName: cName, cDOB: cDOB, cPhoneNo: cPhoneNumber, cEmail: cEmail as String? ?? "", cFrom: "PhoneBook",cAddress: cAddress, contactIdentifier:contact.identifier,result:result! );
                
                if contactID.count > 0
                {
                    //print("Success import contact from phone book");
                }
            }
            
            
            
        }
        completetion("Success");
    }
    
    //insert phonebook data into contact table and return usertable UDID in string
    class func importDataContactModel(cName:String, cDOB:Date?, cPhoneNo:String, cEmail:String, cFrom:String, cAddress:String, contactIdentifier:String)->String
    {
        //realmStore.store.beginWrite();
        //let data = ContactModel().newInstance();
        let data = ContactModel()
        data.id = contactIdentifier;
        data.created_at = Date()
        data.updated_at = Date()
        data.C_Name = cName;
        data.C_DOB = cDOB;
        data.C_PhoneNo = cPhoneNo;
        data.C_Email = cEmail;
        data.C_From = cFrom;
        data.C_Address = cAddress;
        //realmStore.store.add(data)
        realmStore.add(model: data)
        //try! realmStore.store.commitWrite()
        return data.id;
    }
    
    class func updateDataContactModel(cName:String, cDOB:Date?, cPhoneNo:String, cEmail:String, cFrom:String, cAddress:String, contactIdentifier:String, result:Results<ContactModel>)->String
    {
        
        let data = ContactModel()
        data.id = contactIdentifier;
        data.created_at = result[0].created_at;
        data.updated_at = Date()
        data.C_Name = cName;
        data.C_DOB = cDOB;
        data.C_PhoneNo = cPhoneNo;
        data.C_Email = cEmail;
        data.C_From = cFrom;
        data.C_Address = cAddress;
        data.C_Remark = result[0].C_Remark;
        data.C_Scoring = result[0].C_Scoring;
        data.C_Status = result[0].C_Status;
        data.C_Facebook = result[0].C_Facebook
        data.C_Whatsapp = result[0].C_Whatsapp;
        data.C_Linkedin = result[0].C_Linkedin;
        data.C_Twitter = result[0].C_Twitter;
        data.C_ToFollow = result[0].C_ToFollow;
        data.C_LastComm = result[0].C_LastComm;
        //realmStore.store.add(data)
        realmStore.add(model: data)
        //try! realmStore.store.commitWrite()
        return data.id;
    }
    
    // datele all contact that C_From = PhoneBook
    class func deletePhoneBookContact(from:String) {
        realmStore.store.beginWrite();
        if let data = realmStore.models(query: "C_From == '\(from)'") {
            //print(data.count);
            if data.count > 0
            {
                realmStore.store.delete(data)
            }
            
        }
        try! realmStore.store.commitWrite()
    }
    
    // update deleted date but not actual delete from table when user delete particular contact from contact table
    class func deleteParticularContact(id:String) {
        let _ = realmStore.models(query: String(format:"id = '\(id)'"))
        realmStore.delete(hard: false)
    }
    
    // insert contact info into contact table
    class func insertDataContactModel(cName:String, cDOB:Date?, cAddress:String, cPhoneNo:String, cEmail:String, cScore:Int, cRemark:String, cStatus:String) -> String
    {
        let data = ContactModel().newInstance();
        data.C_Name = cName;
        data.C_Address = cAddress;
        data.C_DOB = cDOB;
        data.C_PhoneNo = cPhoneNo;
        data.C_Email = cEmail;
        data.C_Scoring = cScore;
        data.C_Remark = cRemark;
        data.C_Status = cStatus;
        data.C_From = "KeyIn"
        data.add();
        
        return data.id;
    }
    
    // update contact info
    class func updateDataContactModel(id:String, cName:String, cDOB:Date?, cAddress:String, cPhoneNo:String, cEmail:String, cScore:Int, cRemark:String, cStatus:String)->Bool {
        if let contactModel = realmStore.models(query: "id = '\(id)'")?.first {
            contactModel.C_Name = cName;
            contactModel.C_DOB = cDOB;
            contactModel.C_Address = cAddress;
            contactModel.C_PhoneNo = cPhoneNo;
            contactModel.C_Email = cEmail;
            contactModel.C_Scoring = cScore;
            contactModel.C_Remark = cRemark;
            contactModel.C_Status = cStatus;
            return true
        }
        
        return false
    }
    
    // query contact info
    class func queryContactTable(checkType:String, id:String)->Results<ContactModel> {
        // query particular contact info by id
        return realmStore.models(query:  "id = '\(id)'")!
    }
    
    class func queryContactHistoryTable( id:String)->Results<ContactHistory> {
        // query particular contact info by id
        let realmStore = RealmStore<ContactHistory>()
        return realmStore.models(query:  "CH_CID = '\(id)'")!
    }
    
    class func queryContactSocialTable( id:String)->Results<ContactSocial> {
        // query particular contact info by id
        let realmStore = RealmStore<ContactSocial>()
        return realmStore.models(query:  "CS_CID = '\(id)'")!
    }
    
    // cHistoryType is used to diff history type which include : sms, email and call
    class func insertDataContactHistoryModel(cID:String, cHistoryType:String)->Bool
    {
        let data = ContactHistory().newInstance();
        data.CH_CID = cID; 
        data.CH_CallingDate = Date();
        data.CH_HistoryType = cHistoryType;
        
        data.add();
        updateContactLastCommColumn(id: cID)
        return true;
    }
    
    // insert contact social data
    class func insertDataContactSocialModel(id:String, url:String)
    {
        let data = ContactSocial().newInstance();
        data.CS_CID = id;
        data.CS_SocialUrl = "https://facebook.com";
        data.add();
    }
    
    class func updateContactLastCommColumn(id:String)
    {
        self.realmStore.store.beginWrite();
        let addNoteModel = self.realmStore.queryToDo(id: id)?.first;
        addNoteModel?.C_LastComm = Date().toString(withFormat: "yyyy-MM-dd HH:mm:ss")
        
        self.realmStore.store.add(addNoteModel!, update: true);
        //let addNoteModel = realmStore.qu
        try! self.realmStore.store.commitWrite()
    }
    
}
