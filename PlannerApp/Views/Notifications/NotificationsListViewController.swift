//
//  NotificationsListViewController.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 02/10/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import RealmSwift

class NotificationsListViewController: ViewControllerProtocol,LargeNativeNavbar{
    
    fileprivate let tableView = UITableView()
    fileprivate let viewModel = TodoListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Notifications"
        
       
        definesPresentationContext = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        viewModel.notificationToken = viewModel.todoListData?.observe { [weak self] (changes: RealmCollectionChange) in
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
        view.needsUpdateConstraints()
    }
    
    deinit {
        viewModel.notificationToken?.invalidate()
    }
    
    
    override func updateViewConstraints() {
        if !didSetupConstraints {
            tableView.snp.makeConstraints { make in
                make.edges.equalTo(view).inset(UIEdgeInsets.zero)
            }
            
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let selectionIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
        super.viewWillAppear(animated)
        
        updateNavbarAppear()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}




extension NotificationsListViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        guard let data = viewModel.todoListData else {
            return nil
        }
        
        let note: AddNote
        
        
            note = data[indexPath.row]
        
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (deleteAction, indexPath) -> Void in
            RealmStore.delete(model: note)
            
        }
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (editAction, indexPath) -> Void in
            
            self.openDetailsNoteForEditing(model: note)
        }
        
        return [deleteAction, editAction]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = viewModel.todoListData else {
            return
        }
        
        let note: AddNote
        
       
            note = data[indexPath.row]
        
        //add validation here to check if its birthday or notes
        //self.openDetailsNoteForEditing(model: note)
    }
    
    func openDetailsNoteForEditing(model:AddNote) {
        let detailController = DetailsTodoListViewController()
        detailController.isControllerEditing = true
        
        let todoModel = AddNoteModel()
        todoModel.addNote_alertDateTime = model.addNote_alertDateTime
        todoModel.addNote_repeat = model.addNote_repeat
        todoModel.addNote_subject = model.addNote_subject
        
        if let customerModel = RealmStore.model(type: ContactModel.self, query: "id == '\(model.addNote_customerId!)'")?.first {
            todoModel.addNote_customer = customerModel
        }
        
        
        todoModel.addNote_taskType = model.addNote_taskType
        todoModel.addNote_notes = model.addNote_notes
        todoModel.addNote_location = model.addNote_location
        
        detailController.setupModel = todoModel
        
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let data = viewModel.todoListData else {
            return 0
        }
        
        
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell = UITableViewCell(style: UITableViewCellStyle.subtitle,reuseIdentifier: "cell")
        
        guard let data = viewModel.todoListData else {
            return cell
        }
        
        let note: AddNote
        
       
            note = data[indexPath.row]
        
        //write validations here if birthday change icon to "birthday-icon" if meeting change icon to "meeting-icon"
        
        cell.textLabel!.text = note.addNote_subject
        cell.imageView?.image = UIImage(named: "meeting-icon")
        cell.detailTextLabel?.text = convertDateTimeToString(date: note.addNote_alertDateTime!)
        cell.detailTextLabel?.textColor = .red
        return cell
    }
}




