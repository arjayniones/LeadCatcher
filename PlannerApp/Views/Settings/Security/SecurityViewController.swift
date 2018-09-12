//
//  SecurityViewController.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 06/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//


import UIKit

class SecurityViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    let tableView = UITableView()
   
    let securityLabels = SecurityViewModel.getSecurityLabels() // model with getlabel func
    let changePasscodeVC = ChangePasscodeViewController()
    let securityModel = SecurityViewModel() //model
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        tableView.reloadData()
    }
    override func updateViewConstraints() {
//        tableView.snp.makeConstraints { make in
//            make.edges.equalTo(view)
//        }
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "securityCell", for: indexPath)
        print(securityLabels[indexPath.row].labelName)
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
            navigationController?.pushViewController(changePasscodeVC, animated: true)
        }
    }
    
    @objc func switchChanged(_ sender : UISwitch!){
        
        print("table row switch Changed \(sender.tag)")
        print("The switch is \(sender.isOn ? "ON" : "OFF")")
        
        
        SecurityViewModel.enableTouchID(bool:sender.isOn)
        
       
    }
    
    
}

//class securityTableViewCell: UITableViewCell {
//
//    let label = UILabel()
//
//    var didSetupContraints = false
//
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//
//
//        label.text =
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
//                make.edges.equalTo(contentView).inset(UIEdgeInsetsMake(10, 10, 10, 0))
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


