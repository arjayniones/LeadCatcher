//
//  PanelListDetailViewModel.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 08/10/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class PanelListDetailsViewModel {
    
    var isControllerEditing:Bool = false
    var addPanelModel:AddPanelModel?
    var notificationToken: NotificationToken? = nil
    
    
    init() {
        
        self.addPanelModel = AddPanelModel()
        
       
        
        
    }
    
   
func prepareData() -> Bool {
    guard let panelName = self.addPanelModel?.addPanel_name else {
        return false
    }
    
    guard let phoneNum = self.addPanelModel?.addPanel_phoneNum else {
        return false
    }
    
    guard let address = self.addPanelModel?.addPanel_address else {
        return false
    }
    
    guard let email = self.addPanelModel?.addPanel_email else {
        return false
    }
    
    guard let lat = self.addPanelModel?.addPanel_lat else {
        return false
    }
    
    guard let long = self.addPanelModel?.addPanel_long else {
        return false
    }
    
    
    return true
}

func savePanel(completion: @escaping ((_ success:Bool) -> Void)) {
    guard prepareData() else {
        completion(false)
        return
    }
    
    
    self.saveToRealm()
    completion(true)
    
    return
}



func saveToRealm() {
    if let addPanelMod = self.addPanelModel {
        let addPanel = PanelListModel()
        addPanel.newInstance()
        addPanel.panelName = addPanelMod.addPanel_name
        addPanel.phoneNum = addPanelMod.addPanel_phoneNum
        addPanel.email = addPanelMod.addPanel_email
        addPanel.address = addPanelMod.addPanel_address
        addPanel.lat = addPanelMod.addPanel_lat
        addPanel.long = addPanelMod.addPanel_long
        addPanel.add()
        
    }
}



}

class AddPanelModel {
    var addPanel_name: String = ""
    var addPanel_phoneNum: String = ""
    var addPanel_address: String = ""
    var addPanel_email: String = ""
    var addPanel_lat: Double = 0.0
    var addPanel_long: Double = 0.0
    var addPanel_location:LocationModel?
}
