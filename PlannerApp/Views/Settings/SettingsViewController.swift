//
//  SettingsViewController.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 06/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//


import UIKit
import SwiftyUserDefaults

class SettingsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
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
//        tableView.snp.makeConstraints { make in
//            make.edges.equalTo(view)
//        }
        
        
        //setting up the tableview constraints
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        
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

//class settingsTableViewCell: UITableViewCell {
//    let textSample:String = "Security"
//    let label = UILabel()
//
//    var didSetupContraints = false
//
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//
//        label.text = textSample
//        label.numberOfLines = 0
//        label.lineBreakMode = .byWordWrapping
//        contentView.addSubview(label)
//
//    }
//
//    override func updateConstraints() {
//        if !didSetupContraints {
//
//            label.snp.makeConstraints { make in
//                make.edges.equalTo(contentView).inset(UIEdgeInsetsMake(10, 20, 10, 0))
//            }
//            didSetupContraints = true
//        }
//
//        super.updateConstraints()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}


