//
//  LanguageSettingsViewController.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 03/10/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit

class LanguageSettingsViewController: ViewControllerProtocol,UITableViewDelegate,UITableViewDataSource,LargeNativeNavbar {
    let tableView = UITableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "change_language".localized
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if indexPath.row == 0 {
            cell!.textLabel?.text = "English (EN)"
        } else if indexPath.row == 1 {
            cell!.textLabel?.text = "Chinese (ZH)"
        }
        else if indexPath.row == 2 {
            cell!.textLabel?.text = "Bahasa Melayu (MY)"
        }
        
        return cell!
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            Language.language = .english
            break
        case 1:
            Language.language = .chinese
            break
        case 2:
            Language.language = .malay
            break
        default:
            break
        }
        
        self.navigationController?.popViewController(animated: true)
      
    }
    
    
    
}

