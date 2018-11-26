//
//  HomeNavController.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 06/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit

class HomeNavController: BaseNavigationController {

    let controller = HomeViewControllerV2()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pushViewController(controller, animated: true)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
