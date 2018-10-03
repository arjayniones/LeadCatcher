//
//  DetailsTodoListViewModel.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 18/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation

class DetailsTodoListViewModel {
    var detailRows:[AddTodoViewObject] = []
    
    var contentChosen:UNMutableNotificationContent?
    var dateChosen:UNCalendarNotificationTrigger?
    var addNoteModel: AddNoteModel?
    
    init() {
        
        self.addNoteModel = AddNoteModel()
        
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
    
    func verifyRepeatTime(date: Date) -> Bool {
        
        return true
        
        if let repeatTime = self.addNoteModel?.addNote_repeat {
            
            let index = ["3 months before","2 months before","1 month before","Everyday"].index(of: repeatTime)!
            
            var intToMinus:Int = -1
            
            switch index {
            case 0:
                intToMinus = -3
                
            case 1:
                intToMinus = -2
            case 2:
                intToMinus = -1
            case 3:
                guard let dateMinus = Calendar.current.date(byAdding: .day, value: -1, to: date) else {
                    return false
                }
                if isDateLessThan(a: dateMinus, b: Date()) {
                    return false
                } else {
                    return true
                }
            default:
                return false
            }
            
            guard let dateMinus = Calendar.current.date(byAdding: .month, value: intToMinus, to: date) else {
                return false
            }
            
            if isDateLessThan(a: dateMinus, b: Date()) {
                return false
            }
            
            return true
        }
        
        return false
    }
    
    
    func setupNotificationDateSettings() -> Bool {
        if let date = self.addNoteModel?.addNote_alertDateTime {
            
            guard verifyRepeatTime(date:date) else {
                return false
            }
            
            let comps = Calendar.current.dateComponents([.year, .month, .day ,.hour,.minute], from: date)
            
            let calendarTrigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: true)
            self.dateChosen = calendarTrigger
            
            return true
        }
        
        return false
        
        
        // will fire when the user comes within specified metres of the designated coordinate
        
        //            let center = CLLocationCoordinate2D(latitude: 40.0, longitude: 120.0)
        //            let region = CLCircularRegion(center: center, radius: 500.0, identifier: "Location")
        
        //            region.notifyOnEntry = true;
        //            region.notifyOnExit = false;
        //            let locationTrigger = UNLocationNotificationTrigger(region: region, repeats: false)
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
        
        guard let customerName = self.addNoteModel?.addNote_customer?.C_Name else {
            return false
        }
        
        guard self.addNoteModel?.addNote_location != nil else {
            return false
        }
        
        guard setupNotificationDateSettings() else {
            return false
        }
        
        let message = NotificationMessage()
        message.title = messageTitle + " with \(customerName)"
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
                    self.saveToRealm()
                    completion(true)
                }
            }
        } else {
            completion(false)
        }
        
    }
    
    func saveToRealm() {
        DispatchQueue.main.async {
            if let addNoteMod = self.addNoteModel {
                let addNote = AddNote()
                addNote.newInstance()
                addNote.addNote_alertDateTime = addNoteMod.addNote_alertDateTime
                addNote.addNote_repeat = addNoteMod.addNote_repeat
                addNote.addNote_subject = addNoteMod.addNote_subject
                addNote.addNote_customerId = addNoteMod.addNote_customer?.id
                addNote.addNote_taskType = addNoteMod.addNote_taskType
                addNote.addNote_notes = addNoteMod.addNote_notes
                
                if let location = addNoteMod.addNote_location {
                    addNote.addNote_location = location
                }
                addNote.add()
            }
        }
    }
}

class AddNoteModel {
    var addNote_alertDateTime: Date?
    var addNote_repeat: String = ""
    var addNote_subject: String = ""
    var addNote_customer: ContactModel?
    var addNote_taskType: String = ""
    var addNote_notes: String = ""
    var addNote_location:LocationModel?
}


class NotificationMessage {
    var title: String = ""
    var subtitle: String = ""
    var body: String = ""
}

