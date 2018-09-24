//
//  Model.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 07/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import RealmSwift
import Realm
import ObjectMapper

typealias UUID = String

public enum ObjectChanged {
    case Initial
    case Update
    case Delete
    case Error(NSError)
}


class Model: Object, Mappable {
    
    @objc dynamic var id : UUID = ""
    @objc dynamic var created_at  : Date?
    @objc dynamic var updated_at  : Date?
    @objc dynamic var deleted_at  : Date?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required init() { super.init() }
    required init?(map: Map) { super.init() }
    required init(value: AnyObject, schema: RLMSchema) { super.init(value: value, schema: schema) }
    required init(realm: RLMRealm, schema: RLMObjectSchema) { super.init(realm: realm, schema: schema) }
    
    required init(value: Any, schema: RLMSchema) {
        fatalError("init(value:schema:) has not been implemented")
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        deleted_at <- map["deleted_at"]
    }
    
    func add() {
        RealmStore.add(model: self)
    }
    
    func map<T: Model>(type: T.Type, value: AnyObject) -> T? {
        if let value: [String : AnyObject] = value as? [String : AnyObject] {
            return Mapper<T>().map(JSON: value)
        }
        return nil
    }
    
    func loadData<T: Model>(result: @escaping ((Results<T>) -> Void)) {
        let data = RealmStore.models(type: T.self)
        result(data)
    }
    
    func changed<T: Model>(type: T.Type, block: @escaping (_: T?, _: ObjectChanged) -> Void) ->
        NotificationToken {
            
            let data = RealmStore.models(type: T.self).filter("id == '\(id)'")
            
            return data.observe{ (changes: RealmCollectionChange) in
                switch changes {
                case .initial(let result):
                    block(result.first, ObjectChanged.Initial)
                case .update(let result, deletions: let deletions, insertions: _, modifications: let modifications):
                    if deletions.count > 0 {
                        block(result.first, ObjectChanged.Delete)
                    } else if modifications.count > 0 {
                        block(result.first, ObjectChanged.Update)
                    } else {
                        block(nil, ObjectChanged.Initial)
                    }
                case .error(let error):
                    block(nil, ObjectChanged.Error(error as NSError))
                }
            }
    }
}

extension Model {
    
    class func object<T:Model>(type: T.Type, id: UUID) -> T? {
        return RealmStore.models(type: T.self).filter("id == '\(id)'").first
    }
}

