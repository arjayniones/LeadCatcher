//
//  Utils.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 07/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit

func uuid() -> UUID {
    return NSUUID().uuidString.lowercased()
}

func convertDateTimeToString(date:Date) -> String {
    let dateFormatter: DateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy hh:mm"
    
    let selectedDate: String = dateFormatter.string(from:date)
    
    return selectedDate
}
