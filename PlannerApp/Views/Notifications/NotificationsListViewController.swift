//
//  NotificationsListViewController.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 02/10/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import RealmSwift

class NotificationsListViewController: ViewControllerProtocol,NativeNavbar{
    
    fileprivate let tableView = UITableView()
    fileprivate let viewModel = NotificationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Notifications"
        
        definesPresentationContext = true
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dismissView))
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(LogsTableViewCell.self, forCellReuseIdentifier: "cellLog")
        view.addSubview(tableView)
        
        viewModel.notificationToken = viewModel.tasks?.observe { [weak self] (changes: RealmCollectionChange) in
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
    
    @objc func dismissView()
    {
        navigationController?.popViewController(animated: false)
    }
    
    deinit {
        viewModel.notificationToken?.invalidate()
    }
    
    
    override func updateViewConstraints() {
        if !didSetupConstraints {
            tableView.snp.makeConstraints { make in
                if #available(iOS 11.0, *) {
                    make.top.equalTo(view.safeArea.top).inset(UIEdgeInsets.zero)
                } else {
                    make.top.equalTo(view).inset(70)
                }
                make.left.right.equalTo(view).inset(UIEdgeInsets.zero)
                make.bottom.equalTo(view).inset(50)
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
        
        guard let data = viewModel.tasks else {
            return nil
        }
        
        let note: AddNote
        note = data[indexPath.row]
        
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (deleteAction, indexPath) -> Void in
            self.viewModel.realmStore.delete(modelToDelete: note, hard: false)
        }
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = viewModel.tasks else {
            return
        }
        
        let note: AddNote
        note = data[indexPath.row]
        
        try! viewModel.realmStore.write {
            note.status = "read"
        }
        
        self.openDetailsNoteForEditing(model: note)
    }
    
    func openDetailsNoteForEditing(model:AddNote) {
        let detailController = DetailsTodoListViewController()
        detailController.isControllerEditing = true
        
        let todoModel = AddNoteModel()
        todoModel.addNote_ID = model.id
        todoModel.addNote_alertDateTime = model.addNote_alertDateTime
        todoModel.addNote_repeat = model.addNote_repeat
        todoModel.addNote_subject = model.addNote_subject
        
        if let customerModel = RealmStore<ContactModel>().models(query: "id == '\(model.addNote_customerId!)'")?.first {
            todoModel.addNote_customer = customerModel
        }
        
        todoModel.addNote_taskType = model.addNote_taskType
        todoModel.addNote_notes = model.addNote_notes
        todoModel.addNote_location = model.addNote_location
        var checklist:[ChecklistTemp] = []
        
        for x in model.addNote_checklist {
            let checklisttemp = ChecklistTemp()
            checklisttemp.id = x.id
            checklisttemp.title = x.title
            checklisttemp.status = x.status
            checklist.append(checklisttemp)
        }
        
        todoModel.addNote_checkList = checklist
        
        detailController.setupModel = todoModel
        
        self.navigationController?.pushViewController(detailController, animated: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let data = viewModel.tasks else {
            return 0
        }
        
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellLog", for: indexPath) as! LogsTableViewCell
        //cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle,reuseIdentifier: "LogsTableViewCell")
        
        guard let data = viewModel.tasks else {
            return cell
        }
        
        let note: AddNote
        note = data[indexPath.row]
        
        cell.labelTitle.text = note.addNote_subject
        cell.iconImage.image = UIImage(named: note.addNote_taskType == "Customer Birthday" ? "cakeIcon":"taskIcon")
        cell.labelDate.text = convertDateTimeToString(date: note.addNote_alertDateTime!)
        
        if note.status == "Follow Up" {
            cell.iconImage.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        }
        else if note.status == "Completed" {
            cell.iconImage.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        }
        else if note.status == "Discontinue" {
            cell.iconImage.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        }
        else
        {
            cell.iconImage.backgroundColor = CommonColor.turquoiseColor
        }
        
        if note.addNote_taskType == "Customer Birthday" {
            cell.iconImage.backgroundColor = CommonColor.redColor
        }
        
        if note.status == "unread" {
            cell.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
            cell.labelDate.textColor = .red
        } else {
            cell.backgroundColor = .white
            cell.labelDate.textColor = CommonColor.buttonBlackColor
        }
        
        return cell
    }
}




