//
//  ContactListViewController.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 24/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import RealmSwift

protocol ContactListViewControllerDelegate:class {
    func didSelectCustomer(user:ContactModel)
}

class ContactListViewController: ViewControllerProtocol,UITableViewDelegate,UITableViewDataSource,LargeNativeNavbar {
    let tableView = UITableView()
    let viewModel = ContactListViewModel()
    weak var delegate:ContactListViewControllerDelegate?
    var userInContactsSelection: Bool = false
    var userIdSelected:UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Contacts"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsMultipleSelection = false
        tableView.estimatedRowHeight = 100
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "contactListCell")
        view.addSubview(tableView)
        
        let addButton = UIButton()
        let image = UIImage(named: "plus-grey-icon" )
        
        addButton.setImage(image, for: .normal)
        addButton.addTarget(self, action: #selector(addContact), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addButton)
        
        //need to implement this , correct reloading of table after it was been populated.
        
        viewModel.notificationToken = viewModel.contactList?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
        
        view.needsUpdateConstraints()
        view.updateConstraintsIfNeeded()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactListCell")
        
        guard let data = viewModel.contactList  else {
            return cell!
        }
        
        if let userId = userIdSelected,userId == data[indexPath.row].id {
            cell?.accessoryType = .checkmark
        } else {
            cell?.accessoryType = .none
        }
        
        cell?.textLabel?.text = data[indexPath.row].C_Name
        
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
        guard let data = viewModel.contactList  else {
            return
        }
        
        if userInContactsSelection {
            delegate?.didSelectCustomer(user:data[indexPath.row])
            userIdSelected = data[indexPath.row].id
            tableView.reloadData()
        } else {
            let contactsDetailsVC = ContactDetailsViewController()
            self.navigationController?.pushViewController(contactsDetailsVC, animated: true)
        }
    }
    
}
   

