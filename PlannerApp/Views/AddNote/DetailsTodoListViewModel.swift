//
//  DetailsTodoListViewModel.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 18/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit

class DetailsTodoListViewModel {
    var detailRows:[AddTodoViewObject] = []
    
    init() {
        
        let row1 = AddTodoViewObject()
        row1.icon = "calendar-icon"
        row1.title = "Alert date time"
        row1.alertOptions = ["3 months before","2 months before","1 month before","Everyday"]
        self.detailRows.append(row1)
        
        let row2 = AddTodoViewObject()
        row2.icon = "repeat-icon"
        row2.title = "Repeat"
        self.detailRows.append(row2)
        
        let row3 = AddTodoViewObject()
        row3.icon = "subject-icon"
        row3.title = "Subject"
        self.detailRows.append(row3)
        
        let row4 = AddTodoViewObject()
        row4.icon = "person-icon"
        row4.title = "Customer"
        self.detailRows.append(row4)
        
        let row5 = AddTodoViewObject()
        row5.icon = "task-icon"
        row5.title = "Task type"
        row5.alertOptions = ["Appointment","Customer Birthday","Other"]
        self.detailRows.append(row5)
        
        let row6 = AddTodoViewObject()
        row6.icon = "notes-icon"
        row6.title = "Notes"
        self.detailRows.append(row6)
        
        let row7 = AddTodoViewObject()
        row7.icon = "location-icon"
        row7.title = "Location"
        self.detailRows.append(row7)
    }
}

