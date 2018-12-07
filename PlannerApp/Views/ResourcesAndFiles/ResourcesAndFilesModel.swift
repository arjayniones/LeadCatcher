//
//  ResourcesAndFilesModel.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 07/12/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import RealmSwift

class ResourcesAndFilesModel {
    var notificationToken: NotificationToken? = nil
    let realmStore = RealmStore<UserFiles>()
    var files:Results<UserFiles>?
    
    init() {
        files = realmStore.models(query: "deleted_at == nil")
    }
    
    func saveFile(userFiles:UserFiles,dataFile:FileData) {
        saveFileToDisk(fileData: dataFile, completion: { val in
            if val {
                DispatchQueue.main.async {
                    self.realmStore.add(model: userFiles)
                }
            }
        })
    }
}
