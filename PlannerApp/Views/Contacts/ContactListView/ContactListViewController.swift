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
    let contactListModel = ContactListViewModel()
    let contactNameLabels = ContactListViewModel.getContactListNames()
    
    
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
       //add nav to maps here
        let contactsDetailsVC = ContactDetailsViewController()
        self.navigationController?.pushViewController(contactsDetailsVC, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        
        cell.textLabel?.text = contactNameLabels[indexPath.row].contactName
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        cell.setNeedsUpdateConstraints()
        //cell.updateConstraintsIfNeeded()
        
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactNameLabels.count //total number of array using models
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //func to navigate to contact details view
        
        let contactsDetailsVC = ContactDetailsViewController()
        self.navigationController?.pushViewController(contactsDetailsVC, animated: true)
    }
    
}
   

