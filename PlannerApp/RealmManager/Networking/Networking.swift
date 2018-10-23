//
//  Networking.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 07/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import Alamofire

public enum Result<T: AnyObject> {
    case Success(T?)
    case Failure(Int)
    case Cancel(T?)
    case NotFound(T?)
}

class Networking {
    
    var request: Alamofire.Request?
    
    var headers: [String: String]? {
        set{}
        get{
            return nil
        }
    }
    
    let baseUrl:String = "http://192.168.1.129:5000/api/v1/"
    
    class func handleStatusCode(status: Int) {
        switch status {
        case 401:
            print("Handle StatusCode 401: Not Authenticate (https://en.wikipedia.org/wiki/List_of_HTTP_status_codes)")
            break
        case 417:
            print("Handle StatusCode 417: Expectation Failed (https://en.wikipedia.org/wiki/List_of_HTTP_status_codes)")
            break
        case 404:
            print("Handle StatusCode: 404 Not Found (https://en.wikipedia.org/wiki/List_of_HTTP_status_codes)")
            break
        default:
            break
        }
    }
    
    func POST(url: String, parameters: [String: AnyObject]? , completion: @escaping ((_ responseObject: Result<AnyObject>) -> Void)) -> URLSessionTask? {
        
        self.request = Alamofire.request(baseUrl + url,
                                         method: .post,
                                         parameters: parameters,
                                         headers:headers).responseJSON { (response) in
                                            if response.result.isSuccess {
                                                completion(Result.Success(response.result.value as AnyObject))
                                            } else {
                                                print("POST Failed Request: ", self.request?.request?.url ?? "")
                                                print(response.response)
                                                if let response = response.response {
                                                    completion(Result.Failure(response.statusCode))
                                                } else {
                                                    completion(Result.Failure(-1))
                                                }
                                            }
        }
        
        return self.request?.task
    }
    
    
    func GET(url: String, parameters: [String: AnyObject]? , completion: @escaping ((_ responseObject: Result<AnyObject>) -> Void)) -> URLSessionTask? {
        
        self.headers = ["Content-Type":"application/json"]
        
        self.request = Alamofire.request(baseUrl + url,
                                         method: .get,
                                         parameters: parameters,
                                         headers:headers).responseJSON { response in
                                            
                                            if response.result.isSuccess {
                                                completion(Result.Success(response.result.value as AnyObject))
                                            } else {
                                                print("GET Faild Request: ", self.request?.request?.url)
                                                if let response = response.response {
                                                    completion(Result.Failure(response.statusCode))
                                                } else {
                                                    completion(Result.Failure(-1))
                                                }
                                            }
        }
        
        return self.request?.task
    }
    
    //
    //    func delete(sourceService: APIDataSource, completion: (error: NSError?, data: [String: AnyObject]?) -> ()) {
    //
    //    }
    //
    //    func update(sourceService: APIDataSource, completion: (error: NSError?, data: [String: AnyObject]?) -> ()) {
    //
    //    }
    //
    //    func upload(sourceService: APIDataSource, completion: (error: NSError?, data: [String: AnyObject]?) -> ()) {
    //
    //    }
    //
    func dowload(sourceService: APIDataSource, completion: @escaping ((_ success: Bool) -> Void)) {
            
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        self.request = Alamofire.download(
                sourceService.apiURL,
                method: .get,
                parameters: sourceService.parameters,
                encoding: JSONEncoding.default,
                headers: nil,
                to: destination).downloadProgress(closure: { (progress) in
                    print("destination")
                }).response(completionHandler: { (DefaultDownloadResponse) in
                    print("destination value")
                })
        }
    
    func cancelTask() {
        self.request?.task?.cancel()
    }
    
}

