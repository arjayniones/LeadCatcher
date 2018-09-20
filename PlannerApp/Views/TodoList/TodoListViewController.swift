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
        addButton.setTitle("Edit", for: .normal)
//        let image = UIImage(named: "plus-grey-icon" )
//
//        addButton.setImage(image, for: .normal)
        addButton.addTarget(self, action: #selector(EditTodoList), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addButton)
        
        view.needsUpdateConstraints()
    }
    @objc func EditTodoList() {
        //edit code here swipe left and right to the change or add buttons
        
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
        
        let data = todoListModel.todoListData[indexPath.row]
        print(data)
        
        let date = data.addNote_alertDateTime
        let dateString = date?.toString(withFormat: "yyyy-MM-dd HH:mm:ss")
        cell.textLabel?.text = data.addNote_subject as? String
        cell.textLabel?.numberOfLines = 0
    
        cell.detailTextLabel?.text = dateString
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
        return todoListModel.todoListData.count //total number of array using models
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //func to navigate to contact details view
        
        let data = todoListModel.todoListData[indexPath.row]
        let selectedID = data.id
        let contactsDetailsVC = ContactDetailsViewController()
        self.navigationController?.pushViewController(contactsDetailsVC, animated: true)
    }
    
}

extension Date {
    
    func toString(withFormat format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let myString = formatter.string(from: self)
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = format
        
        return formatter.string(from: yourDate!)
    }
}

