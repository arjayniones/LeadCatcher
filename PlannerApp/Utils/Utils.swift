//
//  Utils.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 07/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import CoreLocation

func uuid() -> UUID {
    return NSUUID().uuidString.lowercased()
}

func convertDateTimeToString(date:Date) -> String {
    let dateFormatter: DateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE,dd MMM yyyy hh:mm a"
    
    let selectedDate: String = dateFormatter.string(from:date)
    
    return selectedDate
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
