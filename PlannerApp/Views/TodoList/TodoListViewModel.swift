//
//  TodoListViewModel.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 20/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import RealmSwift
import UIKit

class TodoListViewModel {
    
    var todoListData:Results<AddNote>?
    
    var filteredNotes: Results<AddNote>?
    
    var notificationToken: NotificationToken? = nil
    
    var subpredicates = ["addNote_subject", "addNote_notes","status"]
    
    let realmStore = RealmStore<AddNote>()
    
    var timeByString:TimeStatus?
    
    var filteredDates: [AddNote] = []
    
    init() {
        self.todoListData = realmStore.models(query: "deleted_at == nil && status != 'Completed'",sortingKey: "addNote_alertDateTime", ascending: false)
        
        
//        //fetch per date element
//        if let fetchData = self.todoListData {
//            fetchData.forEach{ (data) in
//                print(data.addNote_alertDateTime!.isContain(this: 11, filterElement: .month))
//            }
//        }
    }
    
    func searchText(text:String) {
        let subpredicates = self.subpredicates.map { property in
            NSPredicate(format: "%K CONTAINS %@ && deleted_at == nil", property, text)
        }
        let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: subpredicates)
        self.filteredNotes = realmStore.models().filter(predicate)
    }
    
    func searchAppointmentByDay(fromDate:Date,toDate:Date) -> Int {
        return realmStore.models().filter("addNote_alertDateTime >= %@ && addNote_alertDateTime < %@ && addNote_taskType == %@ && deleted_at == nil",fromDate,toDate,"Appointment").count
    }
    
    func searchAppointmentByDayData(fromDate:Date,toDate:Date) -> AddNote? {
        return realmStore.models().filter("addNote_alertDateTime >= %@ && addNote_alertDateTime < %@ && addNote_taskType == %@ && deleted_at == nil",fromDate,toDate,"Appointment").first ?? nil
    }
    
    func searchBirthdayByDay(fromDate:Date,toDate:Date) -> Int {
        return realmStore.models().filter("addNote_alertDateTime >= %@ && addNote_alertDateTime < %@ && addNote_taskType == %@ && deleted_at == nil",fromDate,toDate,"Customer Birthday").count
    }
    
    func getCustomersCount() -> Int {
        return RealmStore<ContactModel>().models().filter("C_Status == %@","Customer").count
    }
    
    func getGreetingByTime() {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 6..<12 : self.timeByString = .morning
        case 12 : self.timeByString = .noon
        case 13..<17 : self.timeByString = .afternoon
        case 17..<22 : self.timeByString = .evening
        default: self.timeByString = .evening
        }
    }
    
    func getAppointmentHeaderMessage() -> String {
        
//        var message = "📌 You have "
//        message += "\(self.searchAppointmentByDay(fromDate: Date().startOfDay, toDate: Date().endOfDay)?.count ?? 0)"
//        message += " appointment(s) today."
        
        return "Today overview :"
    }
    
    func fontColorByTime() -> UIColor {
        guard let x = timeByString else {
            return .black
        }
        
        switch x {
        case .morning:
            return .black
        case .noon:
            return .black
        case .afternoon:
            return .black
        case .evening:
            return .black//.lightGray
        }
    }
    
    func getHeaderMessage() -> String {
        guard let x = timeByString else {
            return "Good Day, "
        }
        
        switch x {
        case .morning:
            return "Good Morning, "
        case .noon:
            return "Good Day,"
        case .afternoon:
            return "Good Afternoon, "
        case .evening:
            return "Good Evening, "
        }
    }
    
    func getToDoListByContactID(test:String) -> Results<AddNote>?
    {
        return realmStore.models(query: "addNote_customerId == '\(test)' && (status == 'Pending' || status == 'unread' || status == 'Follow Up' || status == 'read')");
    }
    
    func updateToDoListStatus(id:String, status:String){
        self.realmStore.store.beginWrite();
        let addNoteModel = self.realmStore.queryToDo(id: id)?.first;
        addNoteModel?.status = status
        
        self.realmStore.store.add(addNoteModel!, update: true);
        //let addNoteModel = realmStore.qu
        try! self.realmStore.store.commitWrite()
    }
    
}
