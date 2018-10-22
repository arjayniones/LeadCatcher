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
    
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    fileprivate var searchFooter = SearchFooterView()
    let viewModel = ContactListViewModel()
    weak var delegate:ContactListViewControllerDelegate?
    var userInContactsSelection: Bool = false
    var userIdSelected:UUID?
    
    let allButton = ActionButton()
    let potentialButton = ActionButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Contact"
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            // Fallback on earlier versions
        }
        definesPresentationContext = true
        searchController.searchBar.delegate = self

        title = "Contacts"
        
        allButton.setTitle("All", for: .normal)
        allButton.setTitleColor(.white, for: .normal)
        allButton.setTitleColor(.black, for: .selected)
        allButton.isSelected = true
        allButton.backgroundColor = .white
        allButton.addTarget(self, action: #selector(filterPressed(sender:)), for: .touchUpInside)
        view.addSubview(allButton)
        
        potentialButton.setTitle("Potential", for: .normal)
        potentialButton.backgroundColor = CommonColor.naviBarBlackColor
        potentialButton.isSelected = false
        potentialButton.setTitleColor(.white, for: .normal)
        potentialButton.setTitleColor(.black, for: .selected)
        potentialButton.addTarget(self, action: #selector(filterPressed(sender:)), for: .touchUpInside)
        view.addSubview(potentialButton)
        
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
    
    @objc func filterPressed(sender:UIButton) {
        if sender == allButton && potentialButton.isSelected {
            //filter all
            allButton.isSelected = true
            potentialButton.isSelected = false
            allButton.backgroundColor = .white
            potentialButton.backgroundColor = CommonColor.naviBarBlackColor
            viewModel.filterContact(isPotential: false)
        } else if sender == potentialButton && allButton.isSelected {
            //filter potential
            allButton.isSelected = false
            potentialButton.isSelected = true
            allButton.backgroundColor = CommonColor.naviBarBlackColor
            potentialButton.backgroundColor = .white
            viewModel.filterContact(isPotential: true)
        }
        
        tableView.reloadData()
    }
    
    deinit {
        viewModel.notificationToken?.invalidate()
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
        self.tableView.reloadData()
    }
    
    override func updateViewConstraints() {
        
        if !didSetupConstraints {
            
            allButton.snp.makeConstraints { make in
                make.top.left.equalTo(view)
                make.height.equalTo(50)
            }
            
            potentialButton.snp.makeConstraints { make in
                make.top.right.equalTo(view)
                make.size.equalTo(allButton.snp.size)
                make.left.equalTo(allButton.snp.right)
            }
            
            tableView.snp.makeConstraints { make in
                make.left.right.equalTo(view)
                make.top.equalTo(allButton.snp.bottom)
                make.bottom.equalTo(view).inset(50)
            }
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        guard let data = viewModel.contactList  else {
            return []
        }
        
        let contactData: ContactModel
        
        if isFiltering() {
            contactData = viewModel.filteredContacts![indexPath.row]
        } else {
            contactData = data[indexPath.row]
        }
        
        let callAction = UITableViewRowAction(style: .normal, title: "Call" ) { (deleteAction, indexPath) -> Void in
            
            let contactNum = contactData.C_PhoneNo
            
            print(contactNum)
            let url:URL = URL(string: "tel://\(contactNum)")!
            UIApplication.shared.open(url, options: [:], completionHandler: { val in
                
            })
            
        }
    
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (deleteAction, indexPath) -> Void in
            self.viewModel.realmStore.delete(modelToDelete: contactData,hard:false)
            self.viewModel.removeImage(id:contactData.id)
        }
        
        return [callAction,deleteAction]
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactListCell")
        
        guard let data = viewModel.contactList  else {
            return cell!
        }
        
        let contactData: ContactModel
        
        if isFiltering() {
            contactData = viewModel.filteredContacts![indexPath.row]
        } else {
            contactData = data[indexPath.row]
        }
        
        if let userId = userIdSelected,userId == data[indexPath.row].id {
            cell?.accessoryType = .checkmark
        } else {
            cell?.accessoryType = .none
        }
        
        cell?.textLabel?.text = contactData.C_Name
        
        cell?.textLabel?.textColor = contactData.C_Scoring >= 3 ? .blue:.black
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let data = viewModel.contactList else {
            return 0
        }
        
        if isFiltering() {
            searchFooter.setIsFilteringToShow(filteredItemCount: viewModel.filteredContacts!.count, of: data.count)
            return viewModel.filteredContacts!.count
        }
        
        searchFooter.setNotFiltering()
        
        return data.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = viewModel.contactList  else {
            return
        }
        
        let contactData: ContactModel
        
        if isFiltering() {
            contactData = viewModel.filteredContacts![indexPath.row]
        } else {
            contactData = data[indexPath.row]
        }
        
        
        
        if userInContactsSelection {
            delegate?.didSelectCustomer(user:contactData)
            userIdSelected = contactData.id
            tableView.reloadData()
        } else {
            self.openContactForEditing(model: contactData)
//            let contactsDetailsVC = ContactDetailsViewController()
//            self.navigationController?.pushViewController(contactsDetailsVC, animated: true)
        }
    }
    
    func openContactForEditing(model:ContactModel) {
        let detailController = ContactDetailsViewController()
        detailController.isControllerEditing = true
        
        let contactModel = AddContactModel()
        contactModel.addContact_contactName = model.C_Name
        contactModel.addContact_dateOfBirth = model.C_DOB
        contactModel.addContact_address = model.C_Address
        contactModel.addContact_phoneNum = model.C_PhoneNo
        contactModel.addContact_email = model.C_Email
        contactModel.addContact_leadScore = model.C_Scoring
        contactModel.addContact_remarks = model.C_Remark
        contactModel.addContact_status = model.C_Status
        contactModel.addContact_id = model.id
        
        detailController.setupModel = contactModel
        
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
}

extension ContactListViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}

extension ContactListViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            viewModel.searchText(text: searchText)
            self.tableView.reloadData()
        }
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
}
   

