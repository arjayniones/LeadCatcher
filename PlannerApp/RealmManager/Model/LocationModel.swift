//
//  LocationModel.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 24/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit

class LocationModel {
    var name: String
    var lat: Double
    var long: Double
    
    init(name: String, lat: Double, long: Double)  {
        self.name = name
        self.lat = lat
        self.long = long
    }
}
