//
//  ContactListViewController.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 18/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit

class ContactListViewController: ViewControllerProtocol,UITableViewDelegate,UITableViewDataSource,LargeNativeNavbar {
    let tableView = UITableView()
    let viewModel = ContactListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Contacts"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        let addButton = UIButton()
        //addButton.setTitle("+", for: .normal)
        let image = UIImage(named: "plus-grey-icon" )
        
        addButton.setImage(image, for: .normal)
        addButton.addTarget(self, action: #selector(addContact), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addButton)
        
        view.needsUpdateConstraints()
    }
    @objc func addContact() {
        let contactsDetailsVC = ContactDetailsViewController()
        self.navigationController?.pushViewController(contactsDetailsVC, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        guard let data = viewModel.contactList  else {
            return cell!
        }
        
        cell?.textLabel?.text = data[indexPath.row].C_Name
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        return cell!
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let data = viewModel.contactList  else {
            return 0
        }
        
        return data.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contactsDetailsVC = ContactDetailsViewController()
        self.navigationController?.pushViewController(contactsDetailsVC, animated: true)
    }
    
}
   

