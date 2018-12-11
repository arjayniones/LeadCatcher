//
//  SummaryViewModel.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 25/10/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import Kingfisher

class SummaryViewModel {
    var detailRows:[SummaryCollectionViewObjects] = []
    var contactList:Results<ContactModel>?
    var todoList: Results<AddNote>?
    var notificationToken: NotificationToken? = nil
    var filteredContacts: Results<ContactModel>?
    
    let realmStoreContact = RealmStore<ContactModel>()
    let realmStoreTodo = RealmStore<AddNote>()
    
    init() {
        
        let row1 = SummaryCollectionViewObjects()
        row1.nameLbl = "No. of Leads"
        contactList = realmStoreContact.models(query: "deleted_at == nil")
        row1.valueLbl = (contactList?.count)!
        self.detailRows.append(row1)
        
        let row2 = SummaryCollectionViewObjects()
        row2.nameLbl = "No. of Potential"
        contactList = realmStoreContact.models(query: "C_Status == 'Potential' && deleted_at == nil")
        row2.valueLbl = (contactList?.count)!
        self.detailRows.append(row2)
        
        let row3 = SummaryCollectionViewObjects()
        row3.nameLbl = "No. of Customers"
        contactList = realmStoreContact.models(query: "C_Status == 'Customer' && deleted_at == nil")
        row3.valueLbl = (contactList?.count)!
        self.detailRows.append(row3)
        
        let row4 = SummaryCollectionViewObjects()
        row4.nameLbl = "No. of Appointments"
        todoList = realmStoreTodo.models()
        row4.valueLbl =  (todoList?.count)!
        self.detailRows.append(row4)
        
        let row5 = SummaryCollectionViewObjects()
        row5.nameLbl = "No. Follow-Ups"
        row5.valueLbl = 0
        self.detailRows.append(row5)
        
        let row6 = SummaryCollectionViewObjects()
        row6.nameLbl = "No. of Disqualified"
        contactList = realmStoreContact.models(query: "C_Status == 'Disqualified' && deleted_at == nil")
        
        row6.valueLbl = (contactList?.count)!
        self.detailRows.append(row6)
        
        
    }
    
    func exportContactData() {
        
        let data:NSMutableArray  = NSMutableArray()
        contactList = ContactListViewModel.init().contactList;
        
        // prepare excel data row
        for i in 0..<contactList!.count{
            let exportData:NSMutableDictionary = NSMutableDictionary()
            exportData.setObject(contactList![i].C_Name, forKey: "Name" as NSCopying);
            exportData.setObject("\"\(contactList![i].C_Address)\"", forKey: "Address" as NSCopying);
            exportData.setObject(contactList![i].C_DOB ?? "", forKey: "DOB" as NSCopying);
            exportData.setObject(contactList![i].C_PhoneNo, forKey: "PhoneNo" as NSCopying);
            exportData.setObject(contactList![i].C_Scoring, forKey: "Scoring" as NSCopying);
            exportData.setObject(contactList![i].C_PhoneNo, forKey: "PhoneNo" as NSCopying);
            exportData.setObject(contactList![i].C_Status, forKey: "Status" as NSCopying);
            data.add(exportData);
        }
        
        if contactList!.count > 0
        {
            // prepare excel header
            let fields:NSMutableArray = NSMutableArray()
            fields.add("Name");
            fields.add("Address");
            fields.add("PhoneNo")
            fields.add("DOB");
            fields.add("Scoring");
            fields.add("Status");
            
            // prepare export info
            let writeCSVObj = CSV();
            writeCSVObj.rows = data;
            writeCSVObj.delimiter = DividerType.comma.rawValue;
            writeCSVObj.fields = fields as NSArray;
            writeCSVObj.name = "CustomerInfo";
            
            let result = CSVExport.export(writeCSVObj);
            
            if result.result.isSuccess
            {
                print("File Path: \(String(describing: result.filePath))");
            }
            else
            {
                print("fail to create excel file");
            }
        }
        else
        {
            print("Empty database");
        }
        
    
    }
    
    func generateDateForFilter(mth:Int, yrs:Int)->(Date, Date)
    {
        let selectedMonth = mth
        let selectedYear = yrs
        var components = DateComponents()
        components.month = selectedMonth
        components.year = selectedYear
        let startDateOfMonth = Calendar.current.date(from: components)
        
        //Now create endDateOfMonth using startDateOfMonth
        components.year = 0
        components.month = 1
        components.day = -1
        let endDateOfMonth = Calendar.current.date(byAdding: components, to: startDateOfMonth!)
        
        let predicate = NSPredicate(format: "updated_at >= %@ AND updated_at <= %@",startDateOfMonth! as CVarArg,endDateOfMonth! as CVarArg);
        
        let results = realmStoreContact.models().filter(predicate);
        
        return (startDateOfMonth!, endDateOfMonth!)
    }
    
    func exportToDoData() {
        
        let data:NSMutableArray  = NSMutableArray()
        let viewModel = TodoListViewModel()
        contactList = ContactListViewModel.init().contactList;
        
        for j in 0..<contactList!.count
        {
            todoList = viewModel.getToDoListByContactID(test: contactList![j].id);
            
            for i in 0..<todoList!.count{
                let exportData:NSMutableDictionary = NSMutableDictionary()
                exportData.setObject("\"\(todoList![i].addNote_subject)\"", forKey: "Subject" as NSCopying);
                exportData.setObject(todoList![i].addNote_notes, forKey: "Notes" as NSCopying);
                exportData.setObject(todoList![i].addNote_taskType, forKey: "TaskType" as NSCopying);
                exportData.setObject(todoList![i].addNote_location?.name, forKey: "Location" as NSCopying);
                exportData.setObject(todoList![i].status, forKey: "Status" as NSCopying);
                data.add(exportData);
            }
            
        }
        
        if contactList!.count > 0
        {
            // prepare excel header
            let fields:NSMutableArray = NSMutableArray()
            fields.add("Subject");
            fields.add("Notes");
            fields.add("TaskType")
            fields.add("Location");
            fields.add("Status");
            
            // prepare export info
            let writeCSVObj = CSV();
            writeCSVObj.rows = data;
            writeCSVObj.delimiter = DividerType.comma.rawValue;
            writeCSVObj.fields = fields as NSArray;
            writeCSVObj.name = "ToDoInfo";
            
            let result = CSVExport.export(writeCSVObj);
            
            if result.result.isSuccess
            {
                print("File Path: \(String(describing: result.filePath))");
            }
            else
            {
                print("fail to create excel file");
            }
        }
        else
        {
            print("Empty database");
        }
        
        
    }
    
    
}

    
    
    

