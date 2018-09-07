//
//  ServiceManager.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 07/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import Foundation

class APIDataSource {
    var method: APIMethod!
    var identifier: String!
    var parameters: [String: AnyObject]? = nil
    var apiURL: String!
    var imageData: NSData?
}

class APINavigation {
    var errors: AnyObject?
    var validationErrors: AnyObject?
    var warnings: AnyObject?
    var infos: AnyObject?
    
    init(data: AnyObject) {
        
    }
}

public enum APIMethod: String {
    case GET, POST
}

class APIResponseData {
    var identifier: String!
    var data: AnyObject?
    var currentPage: Int = 0
    var totalPage: Int = 0
    var previousURL: String?
    var nextURL: String?
    var navigation: APINavigation?
    
    init(_ response: AnyObject?, method: APIMethod, identifier: String!) {
        self.identifier = identifier
        if let _dataResponse = response {
            if let result: NSDictionary = _dataResponse["data"] as? NSDictionary {
                switch method {
                case .POST:
                    self.data = result
                    break
                case .GET:
                    self.data = [result] as AnyObject
                    
                    if let currentPage:String = result["currentPage"] as? String {
                        self.currentPage = Int(currentPage) ?? 0
                    }
                    if let totalPage:String = result["totalPage"] as? String {
                        self.totalPage = Int(totalPage) ?? 0
                    }
                    if let previousURL:String = result["previous"] as? String {
                        self.previousURL = previousURL
                    }
                    if let nextURL:String = result["next"] as? String {
                        self.nextURL = nextURL
                    }
                    
                    break
                }
            }
        }
    }
}

class ServiceManager {
    
    static let networking = Networking()
    
    class func request(dataSource: APIDataSource, completion: @escaping ((_ data: APIResponseData) -> Void))  -> URLSessionTask? {
        print("Service get pool request identifier: ", dataSource.identifier)
        
        let method: APIMethod = dataSource.method
        switch method {
        case .POST:
            return ServiceManager.networking.POST(url: dataSource.apiURL, parameters: dataSource.parameters) { (responseObject) in
                switch responseObject {
                case .Success(let response):
                    completion(APIResponseData(response, method: .POST, identifier: dataSource.identifier))
                    break
                default:
                    print("POST FAILED:", dataSource.identifier)
                    completion(APIResponseData(nil, method: .POST, identifier: dataSource.identifier))
                    break
                }
            }
        case .GET:
            return ServiceManager.networking.GET(url: dataSource.apiURL, parameters: dataSource.parameters) { (responseObject) in
                switch responseObject {
                case .Success(let response):
                    completion(APIResponseData(response, method: .GET, identifier: dataSource.identifier))
                    break
                default:
                    print("GET FAILED:", dataSource.identifier)
                    completion(APIResponseData(nil, method: .GET, identifier: dataSource.identifier))
                    break
                }
            }
        }
    }
}

