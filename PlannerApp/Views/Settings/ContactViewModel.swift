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
    
    class func processUserContact(contacts:[CNContact])
    {
        deletePhoneBookContact(from: "PhoneBook");
        
        for contact in contacts {
            let cName = "\(contact.givenName) \(contact.familyName)";
            let cDOB = contact.birthday?.date as Date?;
            let cPhoneNumber:String = (contact.phoneNumbers.first?.value)?.stringValue ?? "";
            let cEmail = contact.emailAddresses.first?.value;
            
            let contactID = insertDataUserModel(cName: cName, cDOB: cDOB, cPhoneNo: cPhoneNumber, cEmail: cEmail as String? ?? "", cFrom: "PhoneBook");

            if contactID.count > 0
            {
                print("Success import contact from phone book");
            }
            
        }
    }
    
    //insert phonebook data into contact table and return usertable UDID in string
    class func insertDataUserModel(cName:String, cDOB:Date?, cPhoneNo:String, cEmail:String, cFrom:String)->String
    {
        let data = ContactModel().newInstance();
        data.C_Name = cName;
        data.C_DOB = cDOB;
        data.C_PhoneNo = cPhoneNo;
        data.C_Email = cEmail;
        data.C_From = cFrom;
        data.add();
        
        return data.id;
    }
    
    class func deletePhoneBookContact(from:String)
    {
        let objectTobeDeleted = RealmStore.models(type: ContactModel.self).filter("C_From = %@","PhoneBook");
        
        let store = try! Realm()
        try! RealmStore.write {
            store.delete(objectTobeDeleted);
        }
        
    }
    
}
