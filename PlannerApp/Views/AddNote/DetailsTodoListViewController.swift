//
//  DetailsTodoListViewController.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 18/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit

class DetailsTodoListViewController: ViewControllerProtocol,LargeNativeNavbar {
    
    var userNotes: String = ""
    var selectedDate: Date = Date()
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("reloading")
        tableView.reloadData()
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
            self.openNoteController()
        } else if data.alertOptions.count != 0 {
            self.sheetPressed(data: data)
        } else if data.title == "Start Date Time" {
            self.showDateTimePicker()
        }
    }
    
    func populateData(cell:DetailsTodoTableViewCell,index:IndexPath,data:AddTodoViewObject) {
        
        if let viewmod = viewModel.addNoteModel {
            switch index.row {
            case 0:
                cell.title = viewmod.addNote_alertDateTime == nil ? data.title : (viewmod.addNote_alertDateTime?.toRFC3339String())!
            case 1:
                cell.title = viewmod.addNote_repeat == "" ? data.title: viewmod.addNote_repeat
            case 2:
                cell.title = viewmod.addNote_subject == "" ? data.title: viewmod.addNote_subject
            case 3:
                cell.title = viewmod.addNote_customerId == "" ? data.title: viewmod.addNote_customerId
            case 4:
                cell.title = viewmod.addNote_taskType == "" ? data.title: viewmod.addNote_taskType
            case 5:
                cell.title = viewmod.addNote_notes == "" ? data.title: viewmod.addNote_notes
            case 6:
                cell.title = viewmod.addNote_location == nil ? data.title:"\(String(describing: viewmod.addNote_location))"
            default:
                break
            }
        } else {
            cell.title = data.title
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DetailsTodoTableViewCell
        let data = viewModel.detailRows[indexPath.row]
        cell.leftIcon = data.icon
        self.populateData(cell: cell, index: indexPath, data:data)
        cell.selectionStyle = .none
        
        if data.title == "Subject" {
            cell.labelTitle.isEnabled = true
            cell.nextIcon.isHidden = true
            cell.subjectCallback = { val in
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
                if data.title == "Alert" {
                    self.viewModel.addNoteModel?.addNote_repeat = title
                } else if data.title == "Task type" {
                    self.viewModel.addNoteModel?.addNote_taskType = title
                }
                self.tableView.reloadData()
            }
            actionSheet.addAction(action)
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
}

extension DetailsTodoListViewController:NotesViewControllerDelegate {
    func openNoteController() {
        let noteController = NotesViewController()
        noteController.delegate = self
        self.present(noteController, animated: true, completion: nil)
    }
    
    func notesControllerDidExit() {
        viewModel.addNoteModel?.addNote_notes = userNotes
        print(userNotes)
    }
}

extension DetailsTodoListViewController:DateAndTimePickerViewControllerDelegate {
    func pickerControllerDidExit() {
        viewModel.addNoteModel?.addNote_alertDateTime = selectedDate
        print(selectedDate.toRFC3339String())
    }
    
    func showDateTimePicker() {
        let datePickerController = DateAndTimePickerViewController()
        datePickerController.delegate = self
        self.present(datePickerController, animated: true, completion: nil)
    }
}



