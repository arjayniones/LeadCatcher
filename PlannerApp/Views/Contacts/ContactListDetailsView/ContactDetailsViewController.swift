//
//  ContactDetailsViewController.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 18/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit

class ContactDetailsViewController: ViewControllerProtocol,LargeNativeNavbar {
    
    var selectedDate = Date()
    //user date variables
    var contactName = String()
    var dateOfBirth: Date = Date()
    var location = String()
    var phoneNum = String()
    var emailAdd = String()
    var leadScoring = String()
    var remarks = String()
    var status = String()
    var isControllerEditing:Bool = false
    
    let tableView = UITableView()
    
    fileprivate let viewModel: ContactDetailsViewModel
    
    var setupModel: AddContactModel? {
        didSet {
            viewModel.addContactModel = setupModel
        }
    }
    
    required init() {
        viewModel = ContactDetailsViewModel()
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Contact Details"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(ContactDetailTableViewCell.self, forCellReuseIdentifier: "contactDetailCell")
        view.addSubview(tableView)
        
        let saveButton = UIButton()
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.font = UIFont.ofSize(fontSize: 17, withType: .bold)
        saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        saveButton.sizeToFit()
        saveButton.frame = CGRect(x: 0, y: -2, width: saveButton.width, height: saveButton.height)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        
        if !isControllerEditing {
            let clearButton = UIButton()
            clearButton.setTitle("Clear", for: .normal)
            clearButton.titleLabel?.font = UIFont.ofSize(fontSize: 17, withType: .bold)
            clearButton.addTarget(self, action: #selector(clear), for: .touchUpInside)
            clearButton.sizeToFit()
            clearButton.frame = CGRect(x: 0, y: -2, width: clearButton.width, height: clearButton.height)
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: clearButton)
        }
        
        view.needsUpdateConstraints()
        view.updateConstraintsIfNeeded()
    }
    
    @objc func save() {
        viewModel.saveContact(completion: { val in
            if val {
                let alert = UIAlertController(title: "Success,New Contact has been saved.", message: "Clear the fields?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "No", style:.cancel, handler: nil));
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                    self.viewModel.addContactModel = AddContactModel()
                    self.tableView.reloadData()
                }))
                self.present(alert, animated: true, completion:nil);
            } else {
                let alert = UIAlertController.alertControllerWithTitle(title: "Error", message: "Contacts not saved.")
                self.present(alert, animated: true, completion: nil);
            }
        })
    }
    
    @objc func clear() {
        let controller = UIAlertController(title: "Info", message: "Clear the fields?", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Cancel", style:.cancel, handler: nil));
        controller.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            self.viewModel.addContactModel = AddContactModel()
            self.tableView.reloadData()
        }))

        self.present(controller, animated: true, completion: nil);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateNavbarAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let indexPathRow1:Int = 1
        let indexPosition1 = IndexPath(row: indexPathRow1, section: 0)
        self.tableView.reloadRows(at: [indexPosition1], with: .none)
     
        
        let indexPathRow6:Int = 6
        let indexPosition6 = IndexPath(row: indexPathRow6, section: 0)
        self.tableView.reloadRows(at: [indexPosition6], with: .none)
        
      
        
        //tableView.reloadData()
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
        
        //add rows details here
        
        if indexPath.row == 1{
            self.showDateTimePicker()
        
        }else  if indexPath.row == 5 {
            //scoring here
             self.sheetPressedScoring(data: data)
        } else  if indexPath.row == 6 {
           self.openRemarksController()
        } else  if indexPath.row == 7 {
           // status alert view
            self.sheetPressedStatus(data: data)
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactDetailCell", for: indexPath) as! ContactDetailTableViewCell
        let data = viewModel.detailRows[indexPath.row]
        cell.leftIcon = data.icon
        self.populateData(cell: cell, index: indexPath, data:data)
        
        cell.selectionStyle = .none
        
        if indexPath.row == 0 {
            cell.labelTitle.isEnabled = true
            cell.nextIcon.isHidden = true
            cell.textFieldsCallback = { val in
                self.viewModel.addContactModel?.addContact_contactName = val
            }
        } else if indexPath.row == 2 {
            cell.labelTitle.isEnabled = true
            cell.nextIcon.isHidden = true
            cell.textFieldsCallback = { val in
                self.viewModel.addContactModel?.addContact_address = val
            }
        } else if indexPath.row == 3 {
            cell.labelTitle.isEnabled = true
            cell.nextIcon.isHidden = true
            cell.textFieldsCallback = { val in
                self.viewModel.addContactModel?.addContact_phoneNum = val
            }
        } else if indexPath.row == 4 {
            cell.labelTitle.isEnabled = true
            cell.nextIcon.isHidden = true
            cell.textFieldsCallback = { val in
                self.viewModel.addContactModel?.addContact_email = val
            }
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.detailRows.count
    }
    
    func populateData(cell:ContactDetailTableViewCell,index:IndexPath,data:AddContactViewObject) {
        
        if let viewmod = viewModel.addContactModel {
            switch index.row {
            case 0:
                cell.title = viewmod.addContact_contactName == "" ? data.title :
                viewmod.addContact_contactName
            case 1:
                cell.title = viewmod.addContact_dateOfBirth == nil ? data.title:
                convertDateTimeToString(date: viewmod.addContact_dateOfBirth!)
            case 2:
                cell.title = viewmod.addContact_address == "" ? data.title: viewmod.addContact_address
            case 3:
                cell.title = viewmod.addContact_phoneNum == "" ? data.title: viewmod.addContact_phoneNum
            case 4:
                cell.title = viewmod.addContact_email == "" ? data.title: viewmod.addContact_email
            case 5:
                let x:Int = viewmod.addContact_leadScore
                print("Lead Score ----->\(x)")
                
                cell.title = viewmod.addContact_leadScore == 0 ? data.title: "\(x)"
                
            case 6:
                cell.title = viewmod.addContact_remarks == "" ? data.title:
                viewmod.addContact_remarks
            case 7:
                cell.title = viewmod.addContact_status == "" ? data.title:
                    viewmod.addContact_status
                print("Status -----> \(viewmod.addContact_status)")
                
                
            default:
                break
            }
        } else {
            cell.title = data.title
        }
    }

    
}

extension ContactDetailsViewController:UIActionSheetDelegate {
    
    func sheetPressedScoring(data:AddContactViewObject){
        let actionSheet = UIAlertController(title: "Choose options", message: "How will you rate your lead? 5 - highest and 1 - lowest.", preferredStyle: .actionSheet)
        
        for title in data.alertOptions {
            let action = UIAlertAction(title: title, style: .default) { (action:UIAlertAction) in
                if data.title == "Lead Scoring" {
                    self.viewModel.addContactModel?.addContact_leadScore = Int(title)!
                    
                }
                //self.tableView.reloadData()
                let indexPathRow:Int = 5
                let indexPosition = IndexPath(row: indexPathRow, section: 0)
                self.tableView.reloadRows(at: [indexPosition], with: .none)
            }
            actionSheet.addAction(action)
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func sheetPressedStatus(data:AddContactViewObject){
        let actionSheet = UIAlertController(title: "Status", message: "Choose the status of this lead.", preferredStyle: .actionSheet)
        
        for title in data.alertOptions {
            let action = UIAlertAction(title: title, style: .default) { (action:UIAlertAction) in
                if data.title == "Status" {
                    self.viewModel.addContactModel?.addContact_status = title
                    
                    
                }
                
               // self.tableView.reloadData()
                let indexPathRow:Int = 7
                let indexPosition = IndexPath(row: indexPathRow, section: 0)
                self.tableView.reloadRows(at: [indexPosition], with: .none)
            }
            actionSheet.addAction(action)
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
}


extension ContactDetailsViewController:NotesViewControllerDelegate {
    func notesControllerDidExit(notes: String) {
        viewModel.addContactModel?.addContact_remarks = notes
    }
    
    func openRemarksController() {
        let noteController = NotesViewController()
        if let notes = viewModel.addContactModel?.addContact_remarks {
            noteController.textNotes = notes
        }
        noteController.delegate = self
        self.present(noteController, animated: true, completion: nil)
    }

   
}

extension ContactDetailsViewController:DateAndTimePickerViewControllerDelegate {
    
    func pickerControllerDidExit() {
        viewModel.addContactModel?.addContact_dateOfBirth = dateOfBirth
    }
    
    func showDateTimePicker() {
        let datePickerController = DateAndTimePickerViewController()
        datePickerController.delegate = self
        self.present(datePickerController, animated: true, completion: nil)
    }
}

//extension ContactDetailsViewController: PlaceViewControllerDelegate {
//    func notesControllerDidExit(customerPlace: LocationModel) {
//        viewModel.addNoteModel?.addNote_location = customerPlace
//    }
//
//}

