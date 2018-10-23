//
//  ArchivesViewController.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 03/10/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit

class ArchivesViewController: ViewControllerProtocol,UITableViewDelegate,UITableViewDataSource,LargeNativeNavbar {
    let tableView = UITableView()
    
    let viewModel = ArchivesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Archives"
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
        
        
        cell!.textLabel?.text = "Archives \(indexPath.row + 1)"
        cell!.imageView?.image = UIImage(named: "archive-icon")
        cell!.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        cell!.setNeedsUpdateConstraints()
        cell!.updateConstraintsIfNeeded()
        
        return cell!
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10 //settingsLabels.count //total number of array using models
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
//        guard let data = viewModel.todoListData else {
//            return nil
//        }
        
        let note: AddNote
        
//        if isFiltering() {
//            note = viewModel.filteredNotes![indexPath.row]
//        } else {
//            note = data[indexPath.row]
//        }
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "delete".localized) { (deleteAction, indexPath) -> Void in
           // self.viewModel.realmStore.delete(modelToDelete: note, hard: false)
            
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "restore".localized) { (editAction, indexPath) -> Void in
            //self.openDetailsNoteForEditing(model: note)
        }
        
        return [deleteAction, editAction]
    }
    
    
    
}

