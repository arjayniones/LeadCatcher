//
//  TodoListViewController.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 18/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit

class TodoListViewController: ViewControllerProtocol,UITableViewDelegate,UITableViewDataSource,LargeNativeNavbar {
    let tableView = UITableView()
    let todoListModel = TodoListViewModel()
    let todoNameLabels = TodoListViewModel.getTodoListItems()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "To Do List"
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
        
        
        var cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        
        cell = UITableViewCell(style: UITableViewCellStyle.subtitle,
                               reuseIdentifier: "cell")
        
        cell.imageView?.image = UIImage(named: "book-icon")
        cell.textLabel?.text = todoNameLabels[indexPath.row].eventName
        cell.textLabel?.numberOfLines = 0
    
        cell.detailTextLabel?.text = todoNameLabels[indexPath.row].dateTime
        cell.detailTextLabel?.textColor = UIColor.red
        //cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
       // cell.setNeedsUpdateConstraints()
        //cell.updateConstraintsIfNeeded()
        
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoNameLabels.count //total number of array using models
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //func to navigate to contact details view
        
        //let contactsDetailsVC = ContactDetailsViewController()
       // self.navigationController?.pushViewController(contactsDetailsVC, animated: true)
    }
    
}


