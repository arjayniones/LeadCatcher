//
//  AddTodoViewObject.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 18/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit

class AddTodoViewObject: NSObject {

    var icon:String = ""
    var title:String = ""
    var alertOptions:[String] = []
}

public enum TodoListTime: String {
    case type1 = "3 months before"
    case type2 = "2 months before"
    case type3 = "1 month before"
    case type4 = "Everyday"
}

public enum TaskType: String {
    case type1 = "Appointment"
    case type2 = "Customer Birthday"
    case type3 = "Other"
}
