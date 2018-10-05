//
//  DetailsTodoListViewController.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 18/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import CoreLocation

class DetailsTodoListViewController: ViewControllerProtocol,LargeNativeNavbar {
    
    var selectedDate: Date = Date()
    
    let tableView = UITableView()
    
    fileprivate let viewModel:DetailsTodoListViewModel
    
    var isControllerEditing:Bool = false
    
    var setupModel: AddNoteModel? {
        didSet {
            viewModel.addNoteModel = setupModel
        }
    }
    
    required init() {
        viewModel = DetailsTodoListViewModel()
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = isControllerEditing ? "edit_to_do_task".localized :"new_to_do_task".localized
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(DetailsTodoTableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        let saveButton = UIButton()
        saveButton.setTitle("save".localized, for: .normal)
        saveButton.titleLabel?.font = UIFont.ofSize(fontSize: 17, withType: .bold)
        saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        saveButton.sizeToFit()
        saveButton.frame = CGRect(x: 0, y: -2, width: saveButton.width, height: saveButton.height)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        
        if !isControllerEditing {
            let clearButton = UIButton()
            clearButton.setTitle("clear".localized, for: .normal)
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
        viewModel.saveSchedule(completion: { val in
            if val {
                let alert = UIAlertController(title: "add_task_success".localized, message: "clear_the_fields".localized, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "no".localized, style:.cancel, handler: nil));
                alert.addAction(UIAlertAction(title: "yes".localized, style: .default, handler: { action in
                    self.viewModel.addNoteModel = AddNoteModel()
                    self.tableView.reloadData()
                }))
                self.present(alert, animated: true, completion:nil);
            } else {
                let alert = UIAlertController.alertControllerWithTitle(title: "error".localized, message: "add_task_failed".localized)
                self.present(alert, animated: true, completion: nil);
            }
        })
    }
    
    @objc func clear() {
        let controller = UIAlertController(title: "Info", message: "clear_the_fields".localized, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Cancel", style:.cancel, handler: nil));
        controller.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            self.viewModel.addNoteModel = AddNoteModel()
            self.tableView.reloadData()
        }))
        
        self.present(controller, animated: true, completion: nil);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateNavbarAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension DetailsTodoListViewController:ContactListViewControllerDelegate {
    func didSelectCustomer(user: ContactModel) {
        viewModel.addNoteModel?.addNote_customer = user
    }
    
    func openContactListViewController() {
        let controller = ContactListViewController()
        controller.delegate = self
        controller.userInContactsSelection = true
        self.navigationController?.pushViewController(controller, animated: true)
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
        } else if data.title == "Customer" {
            self.openContactListViewController()
        } else if data.title == "Location" {
            self.openMapView()
        }
        
    }
    
    func populateData(cell:DetailsTodoTableViewCell,index:IndexPath,data:AddTodoViewObject) {
        
        if let viewmod = viewModel.addNoteModel {
            switch index.row {
            case 0:
                cell.title = viewmod.addNote_alertDateTime == nil ? data.title : convertDateTimeToString(date: viewmod.addNote_alertDateTime!)
            case 1:
                cell.title = viewmod.addNote_repeat == "" ? data.title: viewmod.addNote_repeat
            case 2:
                cell.title = viewmod.addNote_subject == "" ? data.title: viewmod.addNote_subject
            case 3:
                cell.title = viewmod.addNote_customer?.C_Name == "" ? data.title: viewmod.addNote_customer?.C_Name ?? data.title
            case 4:
                cell.title = viewmod.addNote_taskType == "" ? data.title: viewmod.addNote_taskType
            case 5:
                cell.title = viewmod.addNote_notes == "" ? data.title: viewmod.addNote_notes
            case 6:
                cell.title = viewmod.addNote_location == nil ? data.title:"\(viewmod.addNote_location?.name ?? data.title)"
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
        let actionSheet = UIAlertController(title: "choose_options", message: "please_select".localized + " \(data.title)", preferredStyle: .actionSheet)
        
        for title in data.alertOptions {
            let action = UIAlertAction(title: title, style: .default) { (action:UIAlertAction) in
                if data.title == "alert".localized {
                    self.viewModel.addNoteModel?.addNote_repeat = title
                } else if data.title == "task_type".localized {
                    self.viewModel.addNoteModel?.addNote_taskType = title
                }
                self.tableView.reloadData()
            }
            actionSheet.addAction(action)
        }
        
        actionSheet.addAction(UIAlertAction(title: "cancel".localized, style: .cancel))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
}

extension DetailsTodoListViewController:NotesViewControllerDelegate {
    func notesControllerDidExit(notes: String) {
        viewModel.addNoteModel?.addNote_notes = notes
    }
    
    func openNoteController() {
        let noteController = NotesViewController()
        if let notes = viewModel.addNoteModel?.addNote_notes {
            noteController.textNotes = notes
        }
        noteController.delegate = self
        self.present(noteController, animated: true, completion: nil)
    }
    
    
}

extension DetailsTodoListViewController:DateAndTimePickerViewControllerDelegate {
    func pickerControllerDidExit() {
        viewModel.addNoteModel?.addNote_alertDateTime = selectedDate
    }
    
    func showDateTimePicker() {
        let datePickerController = DateAndTimePickerViewController()
        datePickerController.delegate = self
        self.present(datePickerController, animated: true, completion: nil)
    }
}

extension DetailsTodoListViewController: MapViewControllerDelegate {
    func controllerDidExit(customerPlace: LocationModel) {
        viewModel.addNoteModel?.addNote_location = customerPlace
    }
    func openMapView() {
        if let location = viewModel.addNoteModel?.addNote_location {
            let locationCoordinate = CLLocationCoordinate2D(latitude: location.lat, longitude: location.long)
            let mapController = MapViewController(coordinates:[locationCoordinate])
            mapController.delegate = self
            self.navigationController?.pushViewController(mapController, animated: true)
        } else {
            let mapController = MapViewController(coordinates:nil)
            mapController.delegate = self
            self.navigationController?.pushViewController(mapController, animated: true)
        }
    }
}



