//
//  ContactDetailsViewModel.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 18/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import RealmSwift
import Kingfisher
import SwiftyUserDefaults

class ContactDetailsViewModel {
    var detailRows:[AddContactViewObject] = []
    var addContactModel:AddContactModel?
    var logDetails:[AddContactViewObject] = []
    var addLogDetails:LogsModel?
    var socialList:[SocialClass]? = [];
    var profileImage:UIImage?
    
    init() {
        
        
        //log init
        self.addLogDetails = LogsModel()
        //about init
        self.addContactModel = AddContactModel()
        //self.socialList = [SocialClass()];
        /*
        let log1 = AddContactViewObject()
        log1.title = "Called"
        log1.desc = "Had a successful call"
        log1.dateTime = "3 minutes ago"
        self.logDetails.append(log1)
        
        let log2 = AddContactViewObject()
        log2.title = "Emailed"
        log2.desc = "Had sent Birthday Greetings email"
        self.logDetails.append(log2)
         */
        
        let social1 = SocialClass();
        social1.socailUrl = "";
        social1.socialName = "Facebook";
        self.socialList?.append(social1);
        
        let social2 = SocialClass();
        social2.socailUrl = "";
        social2.socialName = "Whatsapp";
        self.socialList?.append(social2);
     
        let social3 = SocialClass();
        social3.socailUrl = "";
        social3.socialName = "Twitter";
        self.socialList?.append(social3);
        
        let social4 = SocialClass();
        social4.socailUrl = "";
        social4.socialName = "Linkedin";
        self.socialList?.append(social4);
        
        let row1 = AddContactViewObject()
        row1.icon = "person-icon"
        row1.title = "Contact Name"
        self.detailRows.append(row1)
        
        let row2 = AddContactViewObject()
        row2.icon = "calendar-icon"
        row2.title = "Date of Birth"
        self.detailRows.append(row2)
        
        let row3 = AddContactViewObject()
        row3.icon = "location-icon"
        row3.title = "Address"
        self.detailRows.append(row3)
        
        let row4 = AddContactViewObject()
        row4.icon = "phone-icon"
        row4.title = "Phone Number"
        self.detailRows.append(row4)
        
        let row5 = AddContactViewObject()
        row5.icon = "email-icon"
        row5.title = "Email"
        self.detailRows.append(row5)
        
        let row6 = AddContactViewObject()
        row6.icon = "notes-icon"
        row6.title = "Lead Scoring"
        row6.alertOptions = ["5","4","3","2","1"]
        self.detailRows.append(row6)
        
        let row7 = AddContactViewObject()
        row7.icon = "subject-icon"
        row7.title = "Write Remarks"
        self.detailRows.append(row7)
        
        let row8 = AddContactViewObject()
        row8.icon = "task-icon"
        row8.title = "Status"
        row8.alertOptions = ["Potential","Nurture","Disqualified","Customer"]
        
        self.detailRows.append(row8)
        
        
    
    }
    
    func prepareData() -> Bool {
        guard let contactName = self.addContactModel?.addContact_contactName else {
            return false
        }
        
        guard let dateOfBirth = self.addContactModel?.addContact_dateOfBirth else {
            return false
        }
        
        guard let address = self.addContactModel?.addContact_address else {
            return false
        }
        
        guard let phoneNum = self.addContactModel?.addContact_phoneNum else {
            return false
        }
        
        guard let email = self.addContactModel?.addContact_email else {
            return false
        }
        
        guard let leadScore = self.addContactModel?.addContact_leadScore else {
            return false
        }
        
        guard let remarks = self.addContactModel?.addContact_remarks else {
            return false
        }
        
        guard let status = self.addContactModel?.addContact_status else {
            return false
        }
        
//        guard let dateAdded = self.addContactModel?.addContact_dateAdded else {
//            return false
//        }
//        
//        guard let lastComm = self.addContactModel?.addContact_lastComm else {
//            return false
//        }
//        
//        guard let toFollow = self.addContactModel?.addContact_toFollow else {
//            return false
//        }
        
        print("Customer Details:  \n\nName: \(contactName)\nDate of Birth: \(dateOfBirth)\nAddress: \(address)\nPhone Number: \(phoneNum)\nEmail: \(email)\nLead Score: \(leadScore)\nRemarks: \(remarks)\nStatus: \(status)")
        
        return true
    }
    
    func saveContact(completion: @escaping ((_ success:Bool) -> Void)) {
        guard prepareData() else {
            completion(false)
            return
        }
        
        
        self.saveToRealm()
        completion(true)
        
        return
    }
   
    func saveToRealm() {
        if let image = profileImage {
            if let id = self.addContactModel?.addContact_id {
                ImageCache.default.store(image, forKey: "profile_"+id)
            }
        }
        
        DispatchQueue.main.async {
            
            for data in self.socialList!
            {
                let addSocial = ContactSocial().newInstance()
                addSocial.CS_CID = Defaults[.ContactID]!;
                addSocial.CS_SocialType = data.socialName;
                addSocial.CS_SocialUrl = data.socailUrl;
                print(data.socailUrl);
                addSocial.add();
            }
//            if self.socialList != nil{
//                let data = self.socialList?[0];
//                let addSocial = ContactSocial().newInstance()
//                addSocial.CS_CID = Defaults[.ContactID]!;
//                addSocial.CS_SocialType = (data?.socialName)!;
//                addSocial.CS_SocialUrl = (data?.socailUrl)!;
//                addSocial.add();
//            }
            
            if let addContactMod = self.addContactModel {
                let addContact = ContactModel().newInstance()
                addContact.C_Name = addContactMod.addContact_contactName
                addContact.C_DOB = addContactMod.addContact_dateOfBirth
                addContact.C_Address = addContactMod.addContact_address
                addContact.C_PhoneNo = addContactMod.addContact_phoneNum
                addContact.C_Email = addContactMod.addContact_email
                addContact.C_Remark = addContactMod.addContact_remarks
                addContact.C_Scoring = addContactMod.addContact_leadScore
                addContact.C_Status = addContactMod.addContact_status
                addContact.C_DateAdded = addContactMod.addContact_dateAdded
                addContact.C_LastComm = addContactMod.addContact_lastComm
                addContact.C_ToFollow = addContactMod.addContact_toFollow
                addContact.C_Facebook = addContactMod.addContact_Facebook
                addContact.C_Whatsapp = addContactMod.addContact_Whatsapp
                addContact.C_Twitter = addContactMod.addContact_Twitter
                addContact.C_Linkedin = addContactMod.addContact_Linkedin
                
//                if let location = addContactMod.addContact_address{
//                    addContact.C_Address = location
//                }
                addContact.add()
                
                //ContactViewModel.insertDataContactSocialModel(id: Defaults[.ContactID]!, url: "");
                
            }
        }
    }
    
    //azlim: return NSURL for QuickLook
    class func getDirectoryInNSURL(fileName:String)->NSURL
    {
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        // destination file url
        let destinationUrl = documentsDirectoryURL.appendingPathComponent(fileName)
        
        let url = destinationUrl as NSURL;
        
        return url;
    }
    
}

class AddContactModel {
    var addContact_id:UUID = ""
    var addContact_contactName: String = ""
    var addContact_dateOfBirth: Date?
    //var addContact_address:LocationModel?
    var addContact_address: String = ""
    var addContact_phoneNum: String = ""
    var addContact_email: String = ""
    var addContact_leadScore: Int = 0
    var addContact_remarks: String = ""
    var addContact_status: String = ""
    var addContact_dateAdded: Date?
    var addContact_lastComm: String = ""
    var addContact_toFollow: String = ""
    var addContact_Facebook: String = ""
    var addContact_Whatsapp: String = ""
    var addContact_Twitter: String = ""
    var addContact_Linkedin: String = ""
    
    
}

class LogsModel {
    
    var log_date: String = ""
    var log_task: String = ""
    var log_details: String = ""
    
}

class SocialClass{
    //var id:UUID = "";
    var socialName:String = "";
    var socailUrl:String = "";
}

