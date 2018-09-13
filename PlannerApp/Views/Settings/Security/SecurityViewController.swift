//
//  SecurityViewController.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 06/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//


import UIKit

class SecurityViewController: ViewControllerProtocol,UITableViewDelegate,UITableViewDataSource,LargeNativeNavbar {
    let tableView = UITableView()
   
    let securityLabels = SecurityViewModel.getSecurityLabels() // model with getlabel func
    let securityModel = SecurityViewModel() //model
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         title = "Security"
        
        view.backgroundColor =  .yellow
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "securityCell")
         view.addSubview(tableView)
        
        view.setNeedsUpdateConstraints()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateNavbarAppear()
        tableView.reloadData()
    }
    
    override func updateViewConstraints() {
        
        if !didSetupConstraints {
            tableView.snp.makeConstraints { make in
                make.edges.equalTo(view)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "securityCell", for: indexPath)
        cell.textLabel?.text = securityLabels[indexPath.row].labelName
        
        if indexPath.row == 0 {
            cell.accessoryType = UITableViewCellAccessoryType.none
            
            //here is programatically switch make to the table view
            let switchView = UISwitch(frame: .zero)
            switchView.setOn(securityModel.checkTouchIDUpdate(), animated: true)
            switchView.tag = indexPath.row // for detect which row switch Changed
            switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
            cell.accessoryView = switchView
            
        }else {
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return securityLabels.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1 {
            let changePasscodeVC = ChangePasscodeViewController()
            navigationController?.pushViewController(changePasscodeVC, animated: true)
        }
    }
    
    @objc func switchChanged(_ sender : UISwitch!){
        
        print("table row switch Changed \(sender.tag)")
        print("The switch is \(sender.isOn ? "ON" : "OFF")")
        
        
        SecurityViewModel.enableTouchID(bool:sender.isOn)
        
       
    }
    
    
}

