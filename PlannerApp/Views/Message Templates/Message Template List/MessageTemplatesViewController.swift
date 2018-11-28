//
//  MessageTemplatesViewController.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 03/10/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import RealmSwift

class MessageTemplatesViewController: ViewControllerProtocol,LargeNativeNavbar {
    let tableView = UITableView()
    
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    fileprivate var searchFooter = SearchFooterView()
    let viewModel = MessageTemplateListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Message Templates"
        view.addBackground()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "search message templates".localized
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            // Fallback on earlier versions
        }
        definesPresentationContext = true
        
        searchController.searchBar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        let addButton = UIButton()
        addButton.setTitle("Add", for: .normal)
        addButton.titleLabel?.font = UIFont.ofSize(fontSize: 17, withType: .bold)
        addButton.addTarget(self, action: #selector(add), for: .touchUpInside)
        addButton.sizeToFit()
        addButton.frame = CGRect(x: 0, y: -2, width: addButton.frame.width, height: addButton.frame.height)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addButton)
        
        viewModel.notificationToken = viewModel.msgTemplateList?.observe { [weak self] (changes: RealmCollectionChange) in
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
        
        view.updateConstraintsIfNeeded()
        view.setNeedsUpdateConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateNavbarAppear()
        tableView.reloadData()
    }
    
    override func updateViewConstraints() {
        
        if !didSetupConstraints {
            
            tableView.snp.makeConstraints { make in
                make.top.equalTo(view.safeArea.top)
                make.left.right.equalTo(view)
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
    
    @objc func add(){
        
        let addMsgTempVC = MessageTemplatesDetailsViewController()
        self.navigationController?.pushViewController(addMsgTempVC, animated: true)
        
    }
    
   
}

extension MessageTemplatesViewController : UISearchBarDelegate {
    
    // MARK: - UISearchBar Delegate
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
}

extension MessageTemplatesViewController : UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            self.viewModel.searchText(text: searchText)
            self.tableView.reloadData()
        }
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
}

extension MessageTemplatesViewController :  UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        
        guard let data = viewModel.msgTemplateList  else {
            return cell
        }
        
        let msgTempData: MessageTemplatesModel
        
        if isFiltering() {
            msgTempData = viewModel.filteredMsgTemp![indexPath.row]
        } else {
            msgTempData = data[indexPath.row]
        }
        
        
        
        cell.textLabel?.text = msgTempData.msgTitle
        cell.imageView?.image = UIImage(named: "message-icon")
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        guard let data = self.viewModel.msgTemplateList else {
            return nil
        }
        
        let msgTemp: MessageTemplatesModel
        
        if isFiltering() {
            msgTemp = self.viewModel.filteredMsgTemp![indexPath.row]
        } else {
            msgTemp = data[indexPath.row]
        }
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "delete".localized) { (deleteAction, indexPath) -> Void in
            self.viewModel.realmStore.delete(modelToDelete: msgTemp, hard: false)
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "edit".localized) { (editAction, indexPath) -> Void in
            self.openDetailsMessageTempForEditing(model: msgTemp)
        }
        
        return [deleteAction, editAction]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = self.viewModel.msgTemplateList else {
            return
        }
        
        let msgTemp: MessageTemplatesModel
        
        if isFiltering() {
            msgTemp = self.viewModel.filteredMsgTemp![indexPath.row]
        } else {
            msgTemp = data[indexPath.row]
        }
        
        self.openDetailsMessageTempForEditing(model: msgTemp)
    }
    
    func openDetailsMessageTempForEditing(model:MessageTemplatesModel) {
        let detailController = MessageTemplatesDetailsViewController()
        detailController.isControllerEditing = true
        
        let msgTempModel = AddMessageTemplateModel()
        msgTempModel.addMsgTemp_title = model.msgTitle
        msgTempModel.addMsgTemp_body = model.msgBody
      
        detailController.setupModel = msgTempModel
        
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let data = viewModel.msgTemplateList else {
            return 0
        }
        
        if isFiltering() {
            searchFooter.setIsFilteringToShow(filteredItemCount: viewModel.filteredMsgTemp!.count, of: data.count)
            return viewModel.filteredMsgTemp!.count
        }
        
        searchFooter.setNotFiltering()
        
        return data.count
    }
    
}


