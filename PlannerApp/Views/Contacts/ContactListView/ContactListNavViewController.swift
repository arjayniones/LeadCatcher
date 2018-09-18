//
//  ContactListNavViewController.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 18/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import Foundation
import UIKit

class ContactListNavViewController: BaseNavigationController {
    
    let controller = ContactListViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pushViewController(controller, animated: true)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
