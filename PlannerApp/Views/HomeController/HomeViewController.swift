//
//  HomeViewController.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 12/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController,NativeNavbar {
    
    let calendarView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Dashboard"
        
        view.backgroundColor = .yellow
        
        calendarView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height/2)
        calendarView.backgroundColor = .red
        view.addSubview(calendarView)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateNavbarAppear()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
