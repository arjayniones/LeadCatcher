//
//  ViewControllerProtocol.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 13/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit

class ViewControllerProtocol: UIViewController {

    var didSetupConstraints = false

    required init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
