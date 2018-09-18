//
//  DetailsTodoListViewModel.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 18/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit

class DetailsTodoListViewModel {
    var detailRows:[[String:String]]
    
    init() {
        self.detailRows = [["icon":"calendar-icon","title":"Alert date time"],
                           ["icon":"repeat-icon","title":"Repeat"],
                           ["icon":"subject-icon","title":"Subject"],
                           ["icon":"person-icon","title":"Customer"],
                           ["icon":"task-icon","title":"Task type"],
                           ["icon":"notes-icon","title":"Notes"],
                           ["icon":"location-icon","title":"Location"]]
    }
}
