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
    
    init() {
        self.todoListData = RealmStore.model(type: AddNote.self, query: "deleted_at == nil")
    }
    
    func searchText(text:String) {
        let subpredicates = self.subpredicates.map { property in
            NSPredicate(format: "%K CONTAINS %@ && deleted_at == nil", property, text)
        }
        let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: subpredicates)
        self.filteredNotes = RealmStore.models(type: AddNote.self).filter(predicate)
    }
    
}
