//
//  TodoListViewModel.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 20/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import Foundation
import RealmSwift


class TodoListViewModel {
    
    var todoListData:Results<AddNote>?
    
    var notificationToken: NotificationToken? = nil
    
    var subpredicates = ["addNote_subject", "addNote_notes"]
    
    init() {
        self.todoListData = RealmStore.model(type: AddNote.self, query: "deleted_at == nil")
    }
    
}

struct TodoListItems {
    let eventName:String?
    let dateTime:String?
    
}
