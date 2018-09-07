//
//  DateExtension.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 07/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit

private let rfc3339DateFormatter1: DateFormatter = {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
    dateFormatter.timeZone = TimeZone(identifier: "UTC")!
    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
    return dateFormatter
}()

private let rfc3339DateFormatter3: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.timeZone = TimeZone(identifier: "UTC")!
    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
    return dateFormatter
}()


public extension Date {
    
    public static func fromRFC3339String(str: String) -> Date? {
        if let date = rfc3339DateFormatter1.date(from: str) {
            return date
        } else if let date = rfc3339DateFormatter3.date(from: str) {
            return date
        }
        return nil
    }
    
    public func toRFC3339String() -> String {
        return rfc3339DateFormatter1.string(from: self)
    }
    
}

//public func <(a: Date, b: Date) -> Bool {
//    return a.compare(b) == ComparisonResult.orderedAscending
//}
//
//public func >(a: Date, b: Date) -> Bool {
//    return a.compare(b) == ComparisonResult.orderedDescending
//}
//
//public func ==(a: Date, b: Date) -> Bool {
//    return a.compare(b) == ComparisonResult.orderedSame
//}

extension Date {
    
    private enum RoundedDuration: String {
        case Seconds = "seconds"
        case Minutes = "minutes"
        case Hours = "hours"
        case Days = "days"
        case Weeks = "weeks"
    }
    
    private func calc() -> (Int, RoundedDuration) {
        let oneMinuteMark: TimeInterval = 60
        let oneHourMark: TimeInterval = oneMinuteMark * 60
        let oneDayMark: TimeInterval = oneHourMark * 24
        let oneWeekMark: TimeInterval = oneDayMark * 7
        let differenceInSeconds = -self.timeIntervalSinceNow
        
        if differenceInSeconds < 0 {
            return(0, .Seconds)
        }
        
        switch differenceInSeconds {
        case 0...oneMinuteMark:
            return(Int(differenceInSeconds), .Seconds)
        case oneMinuteMark...oneHourMark:
            return(Int(differenceInSeconds / oneMinuteMark), .Minutes)
        case oneHourMark...oneDayMark:
            return(Int(differenceInSeconds / oneHourMark), .Hours)
        case oneDayMark...oneWeekMark:
            return(Int(differenceInSeconds / oneDayMark), .Days)
        default:
            return(Int(differenceInSeconds / oneWeekMark), .Weeks)
        }
    }
    
    var shortDescription: String {
        let (value, type) = calc()
        return "\(value)\(Array(type.rawValue)[0])"
    }
    
    var longDescription: String {
        let (value, type) = calc()
        let typeRaw = type.rawValue
        
        let index = typeRaw.index(typeRaw.startIndex, offsetBy: -1)
        
        let typeString = value == 1 ? String(typeRaw[index]) : typeRaw
        return "\(value) \(typeString) ago"
        
    }
}

