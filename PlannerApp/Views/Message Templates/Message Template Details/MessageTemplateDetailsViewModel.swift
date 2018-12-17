//
//  MessageTemplateDetailsViewModel.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 09/10/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class MessageTemplateDetailsViewModel {
    
    let realmStore = RealmStore<MessageTemplatesModel>()
    var isControllerEditing:Bool = false
    var addMessageTemplateModel:AddMessageTemplateModel?
    init() {
        
        self.addMessageTemplateModel = AddMessageTemplateModel()
        
        
    }
    
    
    func prepareData() -> Bool {
        guard let msgTemp_Title = self.addMessageTemplateModel?.addMsgTemp_title else {
            return false
        }
        
        guard let msgTemp_Body = self.addMessageTemplateModel?.addMsgTemp_body else {
            return false
        }
        
      
        
        
        return true
    }
    
    func updateData(id:String, title:String, body:String)
    {
        realmStore.store.beginWrite();
        let addNoteModel = realmStore.queryToDo(id: id)?.first;
        addNoteModel?.msgTitle = title;
        addNoteModel?.msgBody = body;
        
        try! realmStore.store.commitWrite()
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
        if let addMsgTempMod = self.addMessageTemplateModel {
            let addMsgTemp = MessageTemplatesModel()
            addMsgTemp.newInstance()
            addMsgTemp.msgTitle = addMsgTempMod.addMsgTemp_title
            addMsgTemp.msgBody = addMsgTempMod.addMsgTemp_body
           
            addMsgTemp.add()
            
        }
    }
    
    
    
}

class AddMessageTemplateModel {
    var addMsgTemp_title: String = ""
    var addMsgTemp_body: String = ""
    
}
