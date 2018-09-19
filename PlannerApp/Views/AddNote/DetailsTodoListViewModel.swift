//
//  DetailsTodoListViewModel.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 18/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import UserNotifications

class DetailsTodoListViewModel {
    var detailRows:[AddTodoViewObject] = []
    
    var contentChosen:UNMutableNotificationContent?
    var dateChosen:UNCalendarNotificationTrigger?
    var addNoteModel: AddNoteModel?
    
    init() {
        
        let row1 = AddTodoViewObject()
        row1.icon = "calendar-icon"
        row1.title = "Start Date Time"
        self.detailRows.append(row1)
        
        let row2 = AddTodoViewObject()
        row2.icon = "repeat-icon"
        row2.title = "Alert"
        row2.alertOptions = ["3 months before","2 months before","1 month before","Everyday"]
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
    
    func setupNotificationDateSettings(chosenTime:DateComponents) {
        
//        var date = DateComponents()
//        date.hour = 22
        
        let calendarTrigger = UNCalendarNotificationTrigger(dateMatching: chosenTime, repeats: true)
        self.dateChosen = calendarTrigger
        
        // will fire when the user comes within specified metres of the designated coordinate
        
        //            let center = CLLocationCoordinate2D(latitude: 40.0, longitude: 120.0)
        //            let region = CLCircularRegion(center: center, radius: 500.0, identifier: "Location")
        
        //            region.notifyOnEntry = true;
        //            region.notifyOnExit = false;
        //            let locationTrigger = UNLocationNotificationTrigger(region: region, repeats: false)
    }
    
    func convertToTime() {
        ["3 months before","2 months before","1 month before","Everyday"]
        
        if let time = self.addNoteModel?.addNote_alertDateTime {
            if time == "3 months before" {
                
            }
        }
    }
    
    func setupNotificationInfoSettings(message:NotificationMessage) {
        let content = UNMutableNotificationContent()
        content.title = message.title
        content.subtitle = message.subtitle
        content.body = message.body
        content.badge = 1
        content.sound = UNNotificationSound.default()
        self.contentChosen = content
    }
    
    func prepareData() -> Bool {
        guard let messageTitle = self.addNoteModel?.addNote_taskType else {
            return false
        }
        
        guard let messageSubject = self.addNoteModel?.addNote_subject else {
            return false
        }
        
        guard let messageBody = self.addNoteModel?.addNote_notes else {
            return false
        }
        
        let message = NotificationMessage()
        message.title = messageTitle
        message.subtitle = messageSubject
        message.body = messageBody
        self.setupNotificationInfoSettings(message: message)
        
        return true
    }
    
    func saveSchedule(completion: @escaping ((_ success:Bool) -> Void)) {
        guard prepareData() else {
            completion(false)
            return
        }
        
        if let content = self.contentChosen,let triggerTime = self.dateChosen {
            let request = UNNotificationRequest(identifier: "LocalNotification", content: content, trigger: triggerTime)
            UNUserNotificationCenter.current().add(request) { error in
                if error != nil {
                    completion(false)
                } else {
                    completion(true)
                }
            }
        } else {
            completion(false)
        }
        
    }
}

class NotificationMessage {
    var title: String = ""
    var subtitle: String = ""
    var body: String = ""
}

