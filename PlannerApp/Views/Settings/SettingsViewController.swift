//
//  SettingsViewController.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 06/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//


import UIKit
import SwiftyUserDefaults

class SettingsViewController: ViewControllerProtocol,UITableViewDelegate,UITableViewDataSource {
    let tableView = UITableView()
    let settingsModel = SettingsViewModel()
    
     let settingsLabels = SettingsViewModel.getSettingsLabels() // model with get settings label func
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor =  .yellow
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        edgesForExtendedLayout = []
        
        view.setNeedsUpdateConstraints()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func updateViewConstraints() {
        
        if !didSetupConstraints {
            
            tableView.snp.makeConstraints { make in
                make.top.left.right.equalTo(view)
                make.bottom.equalTo(view).inset(50)
            }
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        
        cell.textLabel?.text = settingsLabels[indexPath.row].labelName
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsLabels.count //total number of array using models
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let securityVC = SecurityViewController()
            self.navigationController?.pushViewController(securityVC, animated: true) //call security navigation view controller
        }
        else if indexPath.row == 10{
            popUpLogOut(title: "Log out", message: "Are you sure you want to log out?")
            
        }
    }
    
    func popUpLogOut(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default,handler: { val in
            SessionService.logout()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
}


