//
//  TodoListViewModel.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 20/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import RealmSwift



class TodoListViewModel {
    
    var todoListData:Results<AddNote>?
    
    var filteredNotes: Results<AddNote>?
    
    var notificationToken: NotificationToken? = nil
    
    var subpredicates = ["addNote_subject", "addNote_notes"]
    
    let realmStore = RealmStore<AddNote>()
    
    var timeByString:TimeStatus?
    
    var filteredDates: [AddNote] = []
    
    init() {
        self.todoListData = realmStore.models(query: "deleted_at == nil")
    }
    
    func searchText(text:String) {
        let subpredicates = self.subpredicates.map { property in
            NSPredicate(format: "%K CONTAINS %@ && deleted_at == nil", property, text)
        }
        let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: subpredicates)
        self.filteredNotes = realmStore.models().filter(predicate)
    }
    
    func searchAppointmentByDay(fromDate:Date,toDate:Date) -> Results<AddNote>? {
        return realmStore.models().filter("addNote_alertDateTime >= %@ && addNote_alertDateTime < %@ && addNote_taskType == %@ && deleted_at == nil",fromDate,toDate,"Appointment")
    }
    
    func getAppointmentHeaderMessage() -> String {
        
        let message = "📌 You have \(self.searchAppointmentByDay(fromDate: Date().startOfDay, toDate: Date().endOfDay)?.count ?? 0) appointment(s) today."
        
        return message
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
            return .lightGray
        }
    }
    
    func getHeaderMessage() -> String {
        guard let x = timeByString else {
            return "Good Day,"
        }
        
        switch x {
        case .morning:
            return "Good Morning,"
        case .noon:
            return "Good Day,"
        case .afternoon:
            return "Good Afternoon,"
        case .evening:
            return "Good Evening,"
        }
    }
    
}
