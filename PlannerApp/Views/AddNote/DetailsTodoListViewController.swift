//
//  DetailsTodoListViewController.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 18/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit

class DetailsTodoListViewController: ViewControllerProtocol,LargeNativeNavbar,NotesViewControllerDelegate {
    
    var userNotes: String = ""
    
    let tableView = UITableView()
    
    fileprivate let viewModel:DetailsTodoListViewModel
    
    required init() {
        viewModel = DetailsTodoListViewModel()
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
        title = "New to do"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(DetailsTodoTableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        let saveButton = UIButton()
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        
        view.needsUpdateConstraints()
    }
    @objc func save() {
        viewModel.saveSchedule(completion: { val in
            if val {
                let alert = UIAlertController.alertControllerWithTitle(title: "Success", message: "Your To Do task has saved.")
                self.present(alert, animated: true, completion: nil);
            } else {
                let alert = UIAlertController.alertControllerWithTitle(title: "Error", message: "Your To Do task did not saved.")
                self.present(alert, animated: true, completion: nil);
            }
        })
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
extension DetailsTodoListViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = viewModel.detailRows[indexPath.row]
        
        if data.title == "Notes" {
            let noteController = NotesViewController()
            noteController.delegate = self
            self.present(noteController, animated: true, completion: nil)
        } else if data.alertOptions.count != 0 {
            self.sheetPressed(data: data)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DetailsTodoTableViewCell
        let data = viewModel.detailRows[indexPath.row]
        cell.leftIcon = data.icon
        cell.title = data.title
        
        if data.title == "Subject" {
            cell.labelTitle.isEnabled = true
            cell.nextIcon.isHidden = true
            cell.subjectCallback = { val in
                print(val)
                self.viewModel.addNoteModel?.addNote_subject = val
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.detailRows.count
    }
}

extension DetailsTodoListViewController:UIActionSheetDelegate {
    func sheetPressed(data:AddTodoViewObject){
        let actionSheet = UIAlertController(title: "Choose options", message: "Please select \(data.title)", preferredStyle: .actionSheet)
        
        for title in data.alertOptions {
            let action = UIAlertAction(title: title, style: .default) { (action:UIAlertAction) in
                if data.title == "Alert date time" {
                    self.viewModel.addNoteModel?.addNote_alertDateTime = title
                } else if data.title == "Task type" {
                    self.viewModel.addNoteModel?.addNote_taskType = title
                }
            }
            actionSheet.addAction(action)
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
}



