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
    let realmStore = RealmStore<ContactModel>()
    var errorMsg = ""
    
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
        
        let row1 = AddContactViewObject()
        row1.icon = "person-iconx2"
        row1.title = "Contact Name"
        self.detailRows.append(row1)
        
        let row2 = AddContactViewObject()
        row2.icon = "calendar-iconx2"
        row2.title = "Date of Birth"
        self.detailRows.append(row2)
        
        let row3 = AddContactViewObject()
        row3.icon = "location-iconx2"
        row3.title = "Address"
        self.detailRows.append(row3)
        
        let row4 = AddContactViewObject()
        row4.icon = "phone-gray"
        row4.title = "Phone Number"
        self.detailRows.append(row4)
        
        let row5 = AddContactViewObject()
        row5.icon = "mail-x2"
        row5.title = "Email"
        self.detailRows.append(row5)
        
        let row6 = AddContactViewObject()
        row6.icon = "star2-x2"
        row6.title = "Lead Scoring"
        row6.alertOptions = ["5","4","3","2","1"]
        self.detailRows.append(row6)
        
        let row7 = AddContactViewObject()
        row7.icon = "notes-iconx2"
        row7.title = "Write Remarks"
        self.detailRows.append(row7)
        
        let row8 = AddContactViewObject()
        row8.icon = "user-check-x2"
        row8.title = "Status"
        row8.alertOptions = ["Potential","Others","Customer"]
        self.detailRows.append(row8)
        
        let row9 = AddContactViewObject();
        row9.icon = "facebook-icon";
        row9.title = "Facebook";
        self.detailRows.append(row9)
        
        let row10 = AddContactViewObject();
        row10.icon = "whatsapp-icon";
        row10.title = "Whatsapp";
        self.detailRows.append(row10)
        
        let row11 = AddContactViewObject();
        row11.icon = "twitter-icon";
        row11.title = "Twitter";
        self.detailRows.append(row11)
        
        let row12 = AddContactViewObject();
        row12.icon = "linkedin-icon";
        row12.title = "LinkedIn";
        self.detailRows.append(row12)
        
        
        
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
        
        if !checkEmailFormat(email: email)
        {
            errorMsg = "Invalid email found"
            return false
        }
        else if !checkTelNoFormat(telNo: phoneNum)
        {
            errorMsg = "Invalid phone number"
            return false
        }
        errorMsg = ""
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
    
    func checkEmailFormat(email:String)->Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func checkTelNoFormat(telNo:String)->Bool
    {
        let allowedCharacters = CharacterSet(charactersIn:"+0123456789 ")//Here change this characters based on your requirement
        let characterSet = CharacterSet(charactersIn: telNo)
        return allowedCharacters.isSuperset(of: characterSet)
        
    }
    
    func saveContact(completion: @escaping ((_ success:String) -> Void)) {
        guard prepareData() else {
            completion(errorMsg)
            return
        }
        
        self.saveToRealm()
        completion("true")
        
        return
    }
    
    func updateContactList(id:String)
    {
        if let image = profileImage {
            //if let id = self.addContactModel?.addContact_id {
                ImageCache.default.store(image, forKey: "profile_"+id)
            //}
        }
        
        realmStore.store.beginWrite();
        let updateContactModel = realmStore.queryToDo(id: id)?.first;
        if let data = self.addContactModel
        {
            updateContactModel?.updated_at = Date();
            updateContactModel?.C_Name = data.addContact_contactName;
            updateContactModel?.C_DOB = data.addContact_dateOfBirth;
            updateContactModel?.C_Address = data.addContact_address;
            updateContactModel?.C_PhoneNo = data.addContact_phoneNum;
            updateContactModel?.C_Email = data.addContact_email;
            updateContactModel?.C_Scoring = data.addContact_leadScore;
            updateContactModel?.C_Remark = data.addContact_remarks;
            updateContactModel?.C_Status = data.addContact_status;
            updateContactModel?.C_Facebook = data.addContact_Facebook;
            //updateContactModel?.C_Whatsapp = data.addContact_Whatsapp;
            updateContactModel?.C_Twitter = data.addContact_Twitter;
            updateContactModel?.C_Linkedin = data.addContact_Linkedin;
            if data.addContact_Whatsapp.prefix(1) == "0"
            {
                updateContactModel!.C_Whatsapp = "6\(data.addContact_Whatsapp)"
            }
            else
            {
                updateContactModel!.C_Whatsapp = data.addContact_Whatsapp
            }
            //for x in ()!
            //{
            //realmStore.store.delete((addNoteModel?.addNote_checklist)!);
            //}
            
            
            try! self.realmStore.store.commitWrite()
        }
        
    }
   
    func saveToRealm() {
        
        
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
                
                if let image = self.profileImage {
                    ImageCache.default.store(image, forKey: "profile_"+addContact.id)
                }
                
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
                if addContactMod.addContact_Whatsapp.prefix(1) == "0"
                {
                    addContact.C_Whatsapp = "6\(addContactMod.addContact_Whatsapp)"
                }
                else
                {
                    addContact.C_Whatsapp = addContactMod.addContact_Whatsapp
                }
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
    var addContact_from:String = ""
    
    
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

