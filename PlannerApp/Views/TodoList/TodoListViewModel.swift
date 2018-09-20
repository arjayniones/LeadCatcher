//
//  TodoListViewModel.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 20/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import Foundation


class TodoListViewModel {
    
    var detailRows:[AddTodoListViewObject] = []
    
    
//    init() {
//        
//       
//        
//        let row1 = AddTodoListViewObject()
//        row1.eventName = "Meeting with Mr. Liew"
//        row1.dateTime = "Sept 25, 2018 at 12: 30"
//        self.detailRows.append(row1)
//        
//        let row2 = AddTodoListViewObject()
//        row2.eventName = "Meeting with Mr. Tan"
//        row2.dateTime = "September 22, 2018 at 9:00"
//        self.detailRows.append(row2)
//        
//        let row3 = AddTodoListViewObject()
//        row3.eventName = "Meeting with Mr. Wang"
//        row3.dateTime = "September 23, 2018 at 9:00"
//        self.detailRows.append(row3)
//        
//       
//    }
    
    static func getTodoListItems() -> [TodoListItems]{
        let labelNames = [
            
            TodoListItems(eventName: "Meeting with Mr. Tan", dateTime: "September 23, 2018 at 9:30"),
            TodoListItems(eventName: "Meeting in Starbucks Petaling Street with Mr. Sy ", dateTime: "September 23, 2018 at 9:30"),
            TodoListItems(eventName: "Meeting at Subang Jaya with Mr. Dee" , dateTime: "September 24, 2018 at 9:30"),
            TodoListItems(eventName: "Meeting at Subang Jaya with Mr. Lee" , dateTime: "September 25, 2018 at 9:30"),
            TodoListItems(eventName: "Meeting at Subang Jaya with Mr. Lim" , dateTime: "September 26, 2018 at 9:30"),
            TodoListItems(eventName: "Meeting at Subang Jaya with Mr. Zhi" , dateTime: "September 27, 2018 at 9:30")
            
        ] // write loop here to populate
        return labelNames
        
    }
    
}

struct TodoListItems {
    let eventName:String?
    let dateTime:String?
    
}
