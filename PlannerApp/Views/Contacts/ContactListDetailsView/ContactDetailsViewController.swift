//
//  ContactDetailsViewController.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 18/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit

class ContactDetailsViewController: ViewControllerProtocol,LargeNativeNavbar {
    
    let tableView = UITableView()
    
    fileprivate let viewModel: ContactDetailsViewModel
    
    required init() {
        viewModel = ContactDetailsViewModel()
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
        title = "Contact Details"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(ContactDetailsTableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        view.needsUpdateConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateNavbarAppear()
    }
    
    override func updateViewConstraints() {
        
        if !didSetupConstraints {
            
            tableView.snp.makeConstraints { make in
                make.edges.equalTo(view)
            }
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ContactDetailsViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = viewModel.detailRows[indexPath.row]
        
        if data["title"]! == "Notes" {
            self.present(NotesViewController(), animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContactDetailsTableViewCell
        let data = viewModel.detailRows[indexPath.row]
        cell.leftIcon = data["icon"]!
        cell.title = data["title"]!
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.detailRows.count
    }
    
}
