//
//  DetailsTodoListViewController.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 18/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import CoreLocation
import RealmSwift

class DetailsTodoListViewController: ViewControllerProtocol,LargeNativeNavbar {
    
    var textFieldRealYPosition: CGFloat = 0.0
    var selectedDate: Date = Date()
    var clearStatus:Bool = false;
    var checkListStartCount:Int = 20;
    var isCellEditing:Bool = false;
    let tableView = UITableView()
    
    // for date picker
    let datePickerView = UIDatePicker();
    let bottomView = UIView();
    let buttonLeft = UIButton();
    let buttonRight = UIButton();
    
    fileprivate var viewModel:DetailsTodoListViewModel
    
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
        

         view.backgroundColor = .clear

        NotificationCenter.default.addObserver(self, selector: #selector(DetailsTodoListViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DetailsTodoListViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
    
        title = isControllerEditing ? "edit_to_do_task".localized :"new_to_do_task".localized
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(DetailsTodoTableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        // for datepicker
        bottomView.backgroundColor = UIColor.white;
        buttonLeft.setTitle("Cancel", for: .normal);
        buttonRight.setTitle("Done", for: .normal);
        buttonLeft.setTitleColor(self.view.tintColor, for: .normal);
        buttonRight.setTitleColor(self.view.tintColor, for: .normal);
        datePickerView.datePickerMode = .dateAndTime;
        datePickerView.timeZone = NSTimeZone.local;
        buttonRight.addTarget(self, action: #selector(doneButtonClick), for: .touchUpInside);
        buttonLeft.addTarget(self, action: #selector(cancelButtonClick), for: .touchUpInside);
        self.view.addSubview(bottomView);
        self.bottomView.addSubview(datePickerView);
        self.bottomView.addSubview(buttonLeft);
        self.bottomView.addSubview(buttonRight);
        self.bottomView.isHidden = true;
        
        let saveButton = UIButton()
        if isControllerEditing
        {
            isCellEditing = false;
            saveButton.setTitle("Edit".localized, for: .normal)
            saveButton.addTarget(self, action: #selector(changeRightNavigatorButtonName), for: .touchUpInside)
            //navigationItem.rightBarButtonItem = self.editButtonItem;
        }
        else
        {
            isCellEditing = true;
            saveButton.setTitle("save".localized, for: .normal)
            saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        }
        
        //saveButton.setTitleColor(UIColor.init(red: 0, green: 122, blue: 255), for: .normal);
        saveButton.setTitleColor(.white, for: .normal);
        
        saveButton.titleLabel?.font = UIFont.ofSize(fontSize: 17, withType: .bold)
        
        saveButton.sizeToFit()
        saveButton.frame = CGRect(x: 0, y: -2, width: saveButton.frame.width, height: saveButton.frame.height)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        
        if !isControllerEditing {
            let clearButton = UIButton()
            clearButton.setTitle("clear".localized, for: .normal)
            clearButton.titleLabel?.font = UIFont.ofSize(fontSize: 17, withType: .bold)
            clearButton.addTarget(self, action: #selector(clear), for: .touchUpInside)
            clearButton.sizeToFit()
            clearButton.frame = CGRect(x: 0, y: -2, width: clearButton.frame.width, height: clearButton.frame.height)
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: clearButton)
        }
        
        view.needsUpdateConstraints()
        view.updateConstraintsIfNeeded()
    }
    
    func refreshData() {
        viewModel = DetailsTodoListViewModel()
    }
    
    //datepicker
    @objc func cancelButtonClick()
    {
        self.bottomView.isHidden = true;
    }
    

    @objc func doneButtonClick() {
        viewModel.addNoteModel?.addNote_alertDateTime = self.datePickerView.date
//        convertDateTimeToString(date: self.datePickerView.date);
//        self.textView.text = convertDateToString();
        self.bottomView.isHidden = true;
        self.tableView.reloadData();
    }
    
    //keyboard
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let distanceBetweenTextfielAndKeyboard = self.view.frame.height - textFieldRealYPosition - keyboardSize.height
            if distanceBetweenTextfielAndKeyboard < 0 {
                UIView.animate(withDuration: 0.4) {
                    self.view.transform = CGAffineTransform(translationX: 0.0, y: distanceBetweenTextfielAndKeyboard)
                }
            }
        }
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.4) {
            self.view.transform = .identity
        }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldRealYPosition = textField.frame.origin.y + textField.frame.height
        //take in account all superviews from textfield and potential contentOffset if you are using tableview to calculate the real position
    }
    
    /*
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing
        {
            print("change to save")
        }
        else
        {
            save();
        }
    }
    */
    
    @objc func changeRightNavigatorButtonName()
    {
        isCellEditing = true;
        let saveButton = UIButton()
        
        saveButton.setTitle("save".localized, for: .normal)
        saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        saveButton.setTitleColor(.white, for: .normal);
        //saveButton.setTitleColor(UIColor.init(red: 0, green: 122, blue: 255), for: .normal);
        
        saveButton.titleLabel?.font = UIFont.ofSize(fontSize: 17, withType: .bold)
        
        saveButton.sizeToFit()
        saveButton.frame = CGRect(x: 0, y: -2, width: saveButton.frame.width, height: saveButton.frame.height)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        self.tableView.reloadData();
    }
    
    @objc func save() {
        
        //self.viewModel.updateDetailToDo(id:(self.viewModel.addNoteModel?.addNote_ID)!);
        view.endEditing(true)
    
        if !isControllerEditing
        {
            saveData();
        }
        else
        {
            
            self.viewModel.updateDetailToDo(id: (self.viewModel.addNoteModel?.addNote_ID)!);
            //self.viewModel.updateDetailToDo(id: (self.viewModel.addNoteModel?.addNote_ID)!);
            self.navigationController?.popViewController(animated: false);
            //saveData();
            
        }
        
        
    }
    
    @objc func saveData()
    {
        self.viewModel.saveSchedule(completion: { val in
            if val {
                //
                let alert = UIAlertController(title: "add_task_success".localized, message: "clear_the_fields".localized, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "no".localized, style:.cancel, handler: nil));
                alert.addAction(UIAlertAction(title: "yes".localized, style: .default, handler: { action in
                    self.viewModel.addNoteModel = AddNoteModel()
                    self.refreshData()
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
            let indexPath = IndexPath(item: 0, section: 0)
            self.tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: false);
        }))
        
        self.present(controller, animated: true, completion: nil);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(DetailsTodoListViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DetailsTodoListViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        updateNavbarAppear()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func updateViewConstraints() {
        
        if !didSetupConstraints {
            tableView.snp.makeConstraints { make in

                make.top.equalTo(view.safeArea.top)
                make.left.right.equalTo(view)
                make.bottom.equalTo(view).inset(50)
            }
            
            bottomView.snp.makeConstraints { (make) in
                make.left.right.equalTo(self.view).inset(0);
                make.bottom.equalTo(self.view).inset(50);
                make.height.equalTo(210)
            }
            
            buttonLeft.snp.makeConstraints { (make) in
                make.left.equalTo(0);
                make.top.equalTo(self.bottomView).inset(10);
                make.width.equalTo(70);
                make.height.equalTo(36);
            }
            
            buttonRight.snp.makeConstraints { (make) in
                make.right.equalTo(0);
                make.top.equalTo(self.bottomView).inset(10);
                make.width.equalTo(70);
                make.height.equalTo(36);
            }
            
            datePickerView.snp.makeConstraints { (make) in
                make.left.right.equalTo(self.bottomView).inset(0);
                make.bottom.equalTo(self.view).inset(50);
                make.top.equalTo(self.buttonRight.snp.bottom).offset(5);
                make.height.equalTo(162);

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
        if indexPath.section == 0
        {
            if data.title == "notes".localized {
                self.openNoteController()
            } else if data.alertOptions.count != 0 {
                self.sheetPressed(data: data)
            } else if data.title == "start_date_time".localized {
                self.showDateTimePicker()
            } else if data.title == "customer".localized {
                self.openContactListViewController()
            } else if data.title == "location".localized {
                self.openMapView()
            }
        }
        
    }
    
    func populateData(cell:DetailsTodoTableViewCell,index:IndexPath,data:AddTodoViewObject) {
        
        if let viewmod = viewModel.addNoteModel {
            switch index.row {
            case 0:
                cell.title = viewmod.addNote_alertDateTime == nil ? data.title : convertDateTimeToString(date: viewmod.addNote_alertDateTime!)
                break;
            case 1:
                cell.title = viewmod.addNote_repeat == "" ? data.title: viewmod.addNote_repeat
                break;
            case 2:
                if viewmod.addNote_subject == "" // if addnote_subject is empty then set placeholder only
                {
                    cell.title = data.title;
                }
                else
                {
                    // else set placeholder and data
                    cell.title = data.title;
                    cell.labelTitle.text = viewmod.addNote_subject;
                }
                //cell.title = viewmod.addNote_subject == "" ? data.title: viewmod.addNote_subject
                break;
            case 3:
                cell.title = viewmod.addNote_customer?.C_Name == "" ? data.title: viewmod.addNote_customer?.C_Name ?? data.title
                break;
            case 4:
                cell.title = viewmod.addNote_taskType == "" ? data.title: viewmod.addNote_taskType
                break;
            case 5:
                cell.title = viewmod.addNote_notes == "" ? data.title: viewmod.addNote_notes
                break;
            case 6:
                cell.title = viewmod.addNote_location == nil ? data.title:"\(viewmod.addNote_location?.name ?? data.title)"
                break;
            case 7:
                cell.title = "Checklist"
                clearStatus = false; // used at tableview cellforrow to prevent callback overwrite structure value (subject field)
                break;
            default:
                break;
            }
        } else {
            cell.title = data.title
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.detailRows.count
        }
        
        return viewModel.addNoteModel?.addNote_checkList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DetailsTodoTableViewCell
        
        if !isCellEditing {
            cell.contentView.alpha = 0.5;
            cell.isUserInteractionEnabled = false;
        }
        else {
            cell.contentView.alpha = 1.0;
            cell.isUserInteractionEnabled = true;
        }
        
        if indexPath.section == 0 {
            let data = viewModel.detailRows[indexPath.row]
            cell.leftIcon = data.icon
            cell.labelTitle.tag = 0; //  used to diff section 0 or section 1
            cell.iconImage2.isHidden = true
            cell.iconImage.isHidden = false
            cell.addIcon.isHidden = true
            cell.labelTitle.isEnabled = false
            cell.labelTitle.text = "";
            self.populateData(cell: cell, index: indexPath, data:data)
            
            cell.selectionStyle = .none
            
            if data.title == "subject".localized {
                cell.labelTitle.isEnabled = true
                cell.nextIcon.isHidden = true
                cell.subjectCallback = { val in
                    if !self.clearStatus {
                        self.viewModel.addNoteModel?.addNote_subject = val
                    }
                    
                }
            } else if data.title == "Checklist" {
                cell.addIcon.isHidden = false
                cell.nextIcon.isHidden = true
                cell.checkListCallback = {
                    self.addCell(tableView: tableView)
                }
            }
        }
        
        if indexPath.section == 1 {
            cell.labelTitle.isEnabled = true
            cell.labelTitle.tag = indexPath.row+1; // used to diff section 0 or section 1, +1 bcos textfield inside section0 all is 0 so in this section tag must +1
            cell.nextIcon.isHidden = true
            cell.iconImage.isHidden = true
            cell.addIcon.isHidden = true
            cell.tag = indexPath.row
            cell.iconImage2.isHidden = false
            cell.title = "";
            cell.labelTitle.text = self.viewModel.addNoteModel!.addNote_checkList[indexPath.row].title;
            cell.subjectCallback2 = { val, index in
                if let checkData = self.viewModel.addNoteModel?.addNote_checkList[index]{
                    checkData.title = val
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 1
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        if indexPath.section == 1 {
            let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete".localized) { (deleteAction, indexPath) -> Void in
                if let _ = self.viewModel.addNoteModel?.addNote_checkList {
                    self.viewModel.addNoteModel?.addNote_checkList.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
            return [deleteAction]
        } else {
            return nil
        }
    }
    
    func addCell(tableView: UITableView) {
        
        let checkList = ChecklistTemp()
        let indexBefore = viewModel.addNoteModel?.addNote_checkList.count ?? 0
        
        viewModel.addNoteModel?.addNote_checkList.append(checkList)
        
        let indexPath = IndexPath(item: indexBefore, section: 1)
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true);
    }
}

extension DetailsTodoListViewController:UIActionSheetDelegate {

    func sheetPressed(data:AddTodoViewObject){
        let actionSheet = UIAlertController(title: "choose_options".localized, message: "please_select".localized + " \(data.title)", preferredStyle: .actionSheet)

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
    
    func sheetPressed2(){
        let actionSheet = UIAlertController(title: "choose_options".localized, message: "please_select", preferredStyle: .actionSheet)
        
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
        /*
        let datePickerController = DateAndTimePickerViewController()
        datePickerController.delegate = self
        self.present(datePickerController, animated: true, completion: nil)
         */
        self.bottomView.isHidden = false;
        
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

