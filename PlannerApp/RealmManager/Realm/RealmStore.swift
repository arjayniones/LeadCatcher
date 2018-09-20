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

class RealmStore {
    
    /**
     Add object(Model) to store
     
     - parameter model: object (Model)
     */

    static func add(model: Object) {
        let store = try! Realm()
        print("saved into: ",store.configuration.fileURL)
        try! RealmStore.write {
            store.add(model, update: true)
        }
    }
    
    /**
     Get all object with object type
     
     - parameter type: Object Type
     
     - returns: List Model Result (Model)
     */
    static func models<T: Object>(type: T.Type) -> Results<T> {
        let store = try! Realm()
        return store.objects(T.self)
    }
    
    /**
     Get object with id (primary key)
     
     - parameter type: Object type
     - query:   any string
     
     - returns: Object (Model)
     */
    static func model<T: Object>(type: T.Type, query: String) -> T? {
        let store = try! Realm()
        if let model:T = store.objects(T.self).filter(query).first {
            return  model
        }
        return nil
    }
    
    /**
     Change value of object in block
     
     - parameter block: block()
     
     - throws:
     */
    static func write( block: (() throws -> Void)) throws {
        let store = try! Realm()
        store.beginWrite()
        try block()
        try! store.commitWrite()
    }
    
    /**
     Delete object (Model)
     
     - parameter model: object (Model)
     */
    static func delete(model: Model) {
        let store = try! Realm()
        try! RealmStore.write {
            store.delete(model)
        }
    }
    
}

