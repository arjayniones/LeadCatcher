//
//  Utils.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 07/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import CoreLocation

class FileData {
    var filename:String = ""
    var data:Data?
    var url:URL?
}

func uuid() -> UUID {
    return NSUUID().uuidString.lowercased()
}

func convertDateTimeToString(date:Date,dateFormat:String = "EEEE,dd MMM yyyy hh:mm a") -> String {
    let dateFormatter: DateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat
    
    let selectedDate: String = dateFormatter.string(from:date)
    
    return selectedDate
}
func removeFile(fileData:FileData,completion: @escaping ((_ success: Bool) -> Void)) {
    //optionals data, dont put filename if url is given
    let documentsPath = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
    let logsPath = documentsPath.appendingPathComponent("MyFiles")
    let fileManager = FileManager.default
    
    var path:URL
    
    if fileData.filename == "" {
        path = fileData.url!
    } else {
        path = logsPath.appendingPathComponent("\(fileData.filename)")
    }
    
    do {
        if fileManager.fileExists(atPath: path.path) {
            try fileManager.removeItem(at: path)
        }
        completion(true)
    } catch {
        print(error)
        completion(false)
    }
}

func getFilePathString(filename:String) -> String {
    let documentsPath = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
    let logsPath = documentsPath.appendingPathComponent("MyFiles")
    
    let path = logsPath.appendingPathComponent("\(filename)")
    
    return path.path
}

func saveFileToDisk(fileData:FileData,completion: @escaping ((_ success: Bool) -> Void)) {
    
    let documentsPath = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
    let logsPath = documentsPath.appendingPathComponent("MyFiles")
    let fileManager = FileManager.default
    
    do {
        try fileManager.createDirectory(atPath: logsPath.path, withIntermediateDirectories: true, attributes: nil)
    } catch {
        print("Unable to create directory",error)
    }
    
    let path = logsPath.appendingPathComponent("\(fileData.filename)")
    
    guard let fileURL = fileData.url else {
        completion(false)
        return
    }
    
    if !fileManager.fileExists(atPath: path.path) {
        do {
            let file = try! Data(contentsOf: fileURL)
            try file.write(to: path, options:.atomic)
            
            if fileManager.fileExists(atPath: path.path) {
                try fileManager.removeItem(at: fileURL)
                completion(true)
            }
        } catch {
            completion(false)
        }
    }
}


func getPlaceDetails(coordinate:CLLocationCoordinate2D,complete: @escaping ((String?) -> Void)) {
    let geoCoder = CLGeocoder()
    let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
        
        // Place details
        var placeMark: CLPlacemark!
        placeMark = placemarks?[0]
        
        var  data = ""
        
        // Location name
        if let locationName = placeMark.location {
            print(locationName)
        }
        // Street address
        if let street = placeMark.thoroughfare {
            data += "\(street) "
            print(street)
        }
        // City
        if let city = placeMark.subAdministrativeArea {
            data += "\(city) "
            print(city)
        }
        // Zip code
        if let zip = placeMark.isoCountryCode {
            print(zip)
        }
        // Country
        if let country = placeMark.country {
            data += "\(country)"
            print(country)
        }
        
        complete(data)
    })
}
