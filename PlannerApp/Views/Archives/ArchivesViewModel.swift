//
//  ArchivesViewModel.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 10/10/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import Foundation
import RealmSwift

class ArchivesViewModel {
    
     let msgTemplateList:Results<MessageTemplatesModel>?
    let realmStore = RealmStore<MessageTemplatesModel>()
    var filteredMsgTemp: Results<MessageTemplatesModel>?
    var subpredicates = ["msgTitle", "msgBody"]
    var notificationToken: NotificationToken? = nil
    
    init() {
        self.msgTemplateList = realmStore.models(query: "deleted_at == nil")
    }
    
    func searchText(text:String) {
        let subpredicates = self.subpredicates.map { property in
            NSPredicate(format: "%K CONTAINS %@ && deleted_at == nil", property, text)
        }
        let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: subpredicates)
        self.filteredMsgTemp = realmStore.models().filter(predicate)
    }
    
}




