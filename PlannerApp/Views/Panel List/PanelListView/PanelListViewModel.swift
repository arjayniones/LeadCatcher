//
//  PanelListViewModel.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 08/10/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import Foundation
import RealmSwift

class PanelListViewModel {
    
    var addPanelModel:AddPanelModel?
    let panelList:Results<PanelListModel>?
    let realmStore = RealmStore<PanelListModel>()
    var filteredPanel: Results<PanelListModel>?
    var subpredicates = ["panelName", "address","phoneNum"]
    var notificationToken: NotificationToken? = nil
    
    init() {
        self.panelList = realmStore.models(query: "deleted_at == nil")
    }
    
    func searchText(text:String) {
        let subpredicates = self.subpredicates.map { property in
            NSPredicate(format: "%K CONTAINS %@ && deleted_at == nil", property, text)
        }
        let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: subpredicates)
        self.filteredPanel = realmStore.models().filter(predicate)
    }
    
}
