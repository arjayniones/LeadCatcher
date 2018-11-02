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
        deletePhoneBookContact(from: "PhoneBook");
        
        for contact in contacts {
            let cName = "\(contact.givenName) \(contact.familyName)";
            let cDOB = contact.birthday?.date as Date?;
            let cPhoneNumber:String = (contact.phoneNumbers.first?.value)?.stringValue ?? "";
            let cEmail = contact.emailAddresses.first?.value;
            var cAddress = "";
            
            if contact.postalAddresses.count > 0
            {
                cAddress = "\(contact.postalAddresses[0].value.street), \(contact.postalAddresses[0].value.city), \(contact.postalAddresses[0].value.state), \(contact.postalAddresses[0].value.country)";
            }
            
            // insert data into contact table
            let contactID = importDataContactModel(cName: cName, cDOB: cDOB, cPhoneNo: cPhoneNumber, cEmail: cEmail as String? ?? "", cFrom: "PhoneBook",cAddress: cAddress);

            if contactID.count > 0
            {
                //print("Success import contact from phone book");
            }
            
        }
        completetion("Success");
    }
    
    //insert phonebook data into contact table and return usertable UDID in string
    class func importDataContactModel(cName:String, cDOB:Date?, cPhoneNo:String, cEmail:String, cFrom:String, cAddress:String)->String
    {
        let data = ContactModel().newInstance();
        data.C_Name = cName;
        data.C_DOB = cDOB;
        data.C_PhoneNo = cPhoneNo;
        data.C_Email = cEmail;
        data.C_From = cFrom;
        data.C_Address = cAddress;
        data.add();
        
        return data.id;
    }
    
    // datele all contact that C_From = PhoneBook
    class func deletePhoneBookContact(from:String) {
        if realmStore.models(query: "C_From = '\(from)'") != nil {
            realmStore.delete(hard: false)
        }
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
    
    class func insertDataContactHistoryModel(cID:String, cHistoryType:String)->Bool
    {
        let data = ContactHistory().newInstance();
        data.CH_CID = cID; 
        data.CH_CallingDate = Date();
        data.CH_HistoryType = cHistoryType;
        
        data.add();
        
        return true;
    }
    
}
