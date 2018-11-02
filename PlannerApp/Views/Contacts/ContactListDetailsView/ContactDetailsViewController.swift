//
//  ContactDetailsViewController.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 18/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import ImagePicker
import Kingfisher
import SwiftyUserDefaults
import CallKit

class ContactDetailsViewController: ViewControllerProtocol,LargeNativeNavbar{
    
    var selectedDate = Date()
    var contactName = String()
    var dateOfBirth: Date = Date()
    var location = String()
    var phoneNum = String()
    var emailAdd = String()
    var leadScoring = String()
    var remarks = String()
    var status = String()
    var isControllerEditing:Bool = false
    var callObServer:CXCallObserver!
    
    fileprivate let profileImageView = UIImageView()
    
    let tableView = UITableView()
    
    fileprivate let viewModel: ContactDetailsViewModel
    
    var setupModel: AddContactModel? {
        didSet {
            viewModel.addContactModel = setupModel
        }
    }
    
    let imagePickerController:ImagePickerController = {
        let configuration = Configuration()
        configuration.doneButtonTitle = "Finish"
        configuration.noImagesTitle = "Sorry! There are no images here!"
        configuration.recordLocation = false
        
        let imagePicker = ImagePickerController(configuration: configuration)
        imagePicker.imageLimit = 1
        return imagePicker
    }()
    
    required init() {
        viewModel = ContactDetailsViewModel()
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callObServer = CXCallObserver();
        callObServer.setDelegate(self, queue: DispatchQueue.main);
        
        view.backgroundColor = .white
        title = "Contact Details"
        
        imagePickerController.delegate = self
        
        profileImageView.layer.cornerRadius = 45
        profileImageView.layer.borderColor = UIColor.black.cgColor
        profileImageView.layer.borderWidth = 2
        profileImageView.isUserInteractionEnabled = true
        profileImageView.image = UIImage(named:"profile-icon")
        profileImageView.layer.masksToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editProfileImage)))
        view.addSubview(profileImageView)
        
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
        
        if let id = viewModel.addContactModel?.addContact_id {
            ImageCache.default.retrieveImage(forKey: "profile_"+id, options: nil) {
                image, cacheType in
                if let image = image {
                    self.profileImageView.image = image
                } else {
                    print("Not exist in cache.")
                }
            }
        }
        
        view.needsUpdateConstraints()
        view.updateConstraintsIfNeeded()
    }
    
    @objc func editProfileImage() {
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func save() {
//        let url: NSURL = URL(string: "TEL://60127466766")! as NSURL
//        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        
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
            
            profileImageView.snp.makeConstraints { make in
                make.top.equalTo(view).inset(10)
                make.size.equalTo(CGSize(width: 90, height: 90))
                make.centerX.equalTo(view.snp.centerX)
            }
            
            tableView.snp.makeConstraints { make in
                make.top.equalTo(profileImageView.snp.bottom).offset(10)
                make.left.right.bottom.equalTo(view)
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
                Defaults[.ContactID] = viewmod.addContact_id;
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
extension ContactDetailsViewController: ImagePickerDelegate {
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        if images.count > 0 {
            profileImageView.image = images[0]
            viewModel.profileImage = images[0]
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        if images.count > 0 {
            profileImageView.image = images[0]
            viewModel.profileImage = images[0]
        }

        self.dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}


extension ContactDetailsViewController:CXCallObserverDelegate
{
    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        if call.hasEnded == true {
            // user hang up the phone
            print("Disconnected")
            if (ContactViewModel.insertDataContactHistoryModel(cID: Defaults[.ContactID]!, cHistoryType: "Call"))
            {
                self.tableView.reloadData();
            }
            
        }
        if call.isOutgoing == true && call.hasConnected == false {
            print("azlim Dialing")
        }
        if call.isOutgoing == false && call.hasConnected == false && call.hasEnded == false {
            print("azlim Incoming")
        }
        
        if call.hasConnected == true && call.hasEnded == false {
            // user pick up phone call
            print("azlim Connected")
        }
    }
}

