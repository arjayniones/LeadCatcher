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
    
    var todoListData:Results<AddNote>
    
    var notificationToken: NotificationToken? = nil
    
    init() {
        self.todoListData = RealmStore.models(type: AddNote.self)
        
        
    }
    
}

struct TodoListItems {
    let eventName:String?
    let dateTime:String?
    
}
