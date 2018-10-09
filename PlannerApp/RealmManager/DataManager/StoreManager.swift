//
//  StoreManager.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 07/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import RealmSwift

class StoreManager {
    class func local<T: Model >(
        type: T.Type,
        dataSource: APIDataSource,
        complete: ((_ data: [T]?) -> Void)) {
        var response = [T]()
        let model = RealmStore<T>().models()
        
        if model.count != 0 {
            for data in model {
                response.append(data)
            }
            complete(response)
            return
        }
        
        complete(nil)
        return
    }
    
    class func service<T: Model >(
        type: T.Type,
        dataSource: APIDataSource,
        complete: @escaping ((_ data: [T]?) -> Void)) {
        let _ = ServiceManager.request(dataSource: dataSource) { (data) in
            if let data = data.data as? [AnyObject] {
                print("array",data)
                
                var genericObjects = [T]()
                for (_, object) in data.enumerated() {
                    let genericObject = T()
                    if let obj:T = genericObject.map(type: type, value: object) {
                        RealmStore<T>().add(model: obj)
                        genericObjects.append(obj)
                    }
                }
                complete(genericObjects)
                return
            } else if let data: AnyObject = data.data {
                print("not array",data)
                let genericObject = T()
                if let obj:T = genericObject.map(type: type, value: data) {
                    RealmStore<T>().add(model: obj)
                    complete([obj])
                    return
                }
                complete(nil)
                return
            } else {
                complete(nil)
                return
            }
        }
        
       
    }
    
    class func data<T: Model >(
        type: T.Type,
        dataSource: APIDataSource,
        local: ((_ data: [T]?) -> Void),
        service: @escaping ((_ data: [T]?) -> Void)) {
        StoreManager.local(type: type, dataSource: dataSource) { (data) in
            local(data)
        }
        StoreManager.service(type: type, dataSource: dataSource) { (data) in
            service(data)
        }
    }
    
}

