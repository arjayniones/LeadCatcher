//
//  RealmStore.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 07/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import RealmSwift

public typealias RealmStoreNotificationToken = NotificationToken

class RealmStore<T: Model> {
    
    let store = try! Realm()
    
    fileprivate var model: Results<T>?
    
    /**
     Add object(Model) to store
     
     - parameter model: object (Model)
     */

    func add(model: Object) {
        
        print("saved into: ",store.configuration.fileURL)
        try! write {
            store.add(model, update: true)
        }
    }
    
    /**
     Get all object with object type
     
     - parameter type: Object Type
     
     - returns: List Model Result (Model)
     */
    func models() -> Results<T> {
        let model = store.objects(T.self)
        self.model = model
        return model
    }
    
    /**
     Get object with id (primary key)
     
     - parameter type: Object type
     - query:   any string
     
     - returns: Object (Model)
     */
    func models(query: String) -> Results<T>? {
        let model = store.objects(T.self).filter(query)
        self.model = model
        return model
    }
    
    /**
     Change value of object in block
     
     - parameter block: block()
     
     - throws:
     */
    func write( block: (() throws -> Void)) throws {
        store.beginWrite()
        try block()
        try! store.commitWrite()
    }
    
    /**
     Delete object (Model)
     
     - parameter model: object (Model)
     */
    
    func delete(hard:Bool) {
        guard let model = self.model else {
            return
        }
        
        if !hard {
            try! write {
                let _ = model.map { $0.deleted_at = Date() }
            }
            return
        }
        
        let store = try! Realm()
        store.delete(model)
    }
    func delete(modelToDelete: T?,hard:Bool) {
        if modelToDelete != nil {
            assert((modelToDelete != nil))
            if !hard {
                try! write {
                    let _ = modelToDelete.map { $0.deleted_at = Date() }
                }
                return
            }
            
            try! write {
                store.delete(modelToDelete!)
            }
            
            return
        }
        
        if let model = self.model {
            if !hard {
                try! write {
                    let _ = model.map { $0.deleted_at = Date() }
                }
            }
        }
    }
}

