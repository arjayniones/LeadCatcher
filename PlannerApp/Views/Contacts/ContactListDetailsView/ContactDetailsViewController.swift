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

import RealmSwift
import MessageUI
import QuickLook


class ContactDetailsViewController: ViewControllerProtocol,LargeNativeNavbar{
    
    var textFieldRealYPosition: CGFloat = 0.0
    var selectedDate = Date()
    var contactName = String()
    var dateOfBirth: Date = Date()
    var location = String()
    var phoneNum = String()
    var emailAdd = String()
    var leadScoring = String()
    var remarks = String()
    var status = String()
    let datePicker = UIDatePicker()
    let logButton = ActionButton()
    let todoButton = ActionButton()
    let socialButton = ActionButton()
    let filesButton = ActionButton()
    let infoButton = ActionButton()
    let topStackView = UIStackView()
    let buttonStackView = UIStackView()
    let nameLabel = UILabel()
    let companyLabel = UILabel()
    let scoreLabel = UILabel()
    let statusLabel = UILabel()
    let callButton = ActionButton()
    let emailButton = ActionButton()
    let smsButton = ActionButton()
    let realmStoreContact = RealmStore<ContactModel>()
    var selectedTab = String()
    var previewItem = NSURL()
    let topView = UIView()
    
    // for date picker
    let datePickerView = UIDatePicker();
    let bottomView = UIView();
    let buttonLeft = UIButton();
    let buttonRight = UIButton();
    
    // azlim
    var resultHistoryList:Results<ContactHistory>!;
    var resultSocialList:Results<ContactSocial>!;
    var contactSocialList:[SocialClass] = [];
    var addNoteList:Results<AddNote>!;
    var editData_YN:Bool = true; // false : mean new entry, true : mean update entry
    var isCellEditing_YN = false;
    let todoModel = TodoListViewModel();
    
    
    fileprivate let profileImageView = UIImageView()
    
    let tableView = UITableView()
    
    fileprivate let viewModel: ContactDetailsViewModel
    
    var setupModel: AddContactModel? {
        didSet {
            viewModel.addContactModel = setupModel
        }
    }
    
    fileprivate let customnNavView = UIView()
    fileprivate let clearButton = UIButton()
    fileprivate let saveButton = UIButton()
    
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

        view.backgroundColor = .clear

        title = "Contact Details"
        selectedTab = "info"
        imagePickerController.delegate = self
        
        view.addSubview(topView)
        topView.backgroundColor = .clear
        
        profileImageView.layer.cornerRadius = 45
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.borderWidth = 2
        profileImageView.isUserInteractionEnabled = true
        profileImageView.image = UIImage(named:"user-circle-big-icon")
        profileImageView.layer.masksToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
       
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editProfileImage)))
        
        topView.addSubview(profileImageView)
        let name = viewModel.addContactModel?.addContact_contactName
        nameLabel.text = name == "" ? "No Name" : name
        nameLabel.textAlignment = .center
        nameLabel.textColor = .white
        nameLabel.font = nameLabel.font.withSize(25)
        
        companyLabel.text = viewModel.addContactModel?.addContact_address
        companyLabel.textAlignment = .center
        companyLabel.adjustsFontSizeToFitWidth = true
        companyLabel.textColor = .white
        companyLabel.font = companyLabel.font.withSize(20)
        
        let score = viewModel.addContactModel?.addContact_leadScore

        scoreLabel.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        //scoreLabel.textColor = CommonColor.yellowColor
        scoreLabel.font = scoreLabel.font.withSize(22)
        if score == 0 {
              scoreLabel.text = "✩ ✩ ✩ ✩ ✩"
        } else if score == 1 {
              scoreLabel.text = "★ ✩ ✩ ✩ ✩"
        } else if score == 2 {
            scoreLabel.text = "★ ★ ✩ ✩ ✩"
        } else if score == 3 {
            scoreLabel.text = "★ ★ ★ ✩ ✩"
        } else if score == 4 {
            scoreLabel.text = "★ ★ ★ ★ ✩"
        }  else if score == 5 {
            scoreLabel.text = "★ ★ ★ ★ ★"
        }
        
        
        let status = viewModel.addContactModel?.addContact_status
        //statusLabel.textColor = #colorLiteral(red: 0.3084815145, green: 0.3084815145, blue: 0.3084815145, alpha: 1);
        statusLabel.textColor = .white
        
        if status == "Potential" {

            //statusLabel.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.3529411765, blue: 0.1411764706, alpha: 1)
            statusLabel.backgroundColor = CommonColor.turquoiseColor

            statusLabel.text = status
        } else if status == "Others" {
            statusLabel.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.1058823529, blue: 0.2980392157, alpha: 1)
            statusLabel.text = status
        } else if status == "Customer" {
            
            //statusLabel.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            statusLabel.backgroundColor = CommonColor.purpleColor
            statusLabel.text = status
        }else {
            statusLabel.text = status == "" ? "No Meeting Yet" : status
            statusLabel.backgroundColor = .white
            statusLabel.textColor = .gray
        }
        
        statusLabel.font = statusLabel.font.withSize(15)
        //statusLabel.textColor = .black
        statusLabel.textAlignment = .center
        statusLabel.roundBottomRight()
        

        topView.addSubview(nameLabel)
        topView.addSubview(companyLabel)
        topView.addSubview(scoreLabel)
        topView.addSubview(statusLabel)

        
        
        let imageCall = UIImage(named: "phone-gray")
        callButton.setImage(imageCall, for: .normal)
        callButton.isSelected = true
        callButton.backgroundColor = .white
        callButton.layer.cornerRadius = 10
        callButton.addTarget(self, action: #selector(actionCall), for: .touchUpInside)
        
        let imageSMS = UIImage(named: "chat-icon")
        smsButton.setImage(imageSMS, for: .normal)
        smsButton.isSelected = true
        smsButton.backgroundColor = .white
        smsButton.layer.cornerRadius = 10
        smsButton.addTarget(self, action: #selector(actionSMS), for: .touchUpInside)
        
        let imageEmail = UIImage(named: "mail-icon")
        emailButton.setImage(imageEmail, for: .normal)
        emailButton.isSelected = true
        emailButton.backgroundColor = .white
        emailButton.layer.cornerRadius = 10
        emailButton.addTarget(self, action: #selector(actionEmail), for: .touchUpInside)
        
        buttonStackView.axis = .vertical
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 10
        buttonStackView.addArrangedSubview(callButton)
        buttonStackView.addArrangedSubview(smsButton)
        buttonStackView.addArrangedSubview(emailButton)
        topView.addSubview(buttonStackView)
        
        logButton.setTitle("Logs", for: .normal)
        logButton.setTitleColor(#colorLiteral(red: 0.3254901961, green: 0.3607843137, blue: 0.4078431373, alpha: 1), for: .normal)
        logButton.setTitleColor(.black, for: .selected)
        logButton.titleLabel?.font =  .systemFont(ofSize: 11)
        logButton.isSelected = true
        logButton.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1)
        logButton.layer.borderColor = UIColor.gray.cgColor
        logButton.layer.borderWidth = 0.2
        logButton.roundTop()
        logButton.addTarget(self, action: #selector(filterPressed(sender:)), for: .touchUpInside)
        
        todoButton.setTitle("To Do", for: .normal)
        todoButton.setTitleColor(#colorLiteral(red: 0.3254901961, green: 0.3607843137, blue: 0.4078431373, alpha: 1), for: .normal)
        todoButton.setTitleColor(.black, for: .selected)
        todoButton.titleLabel?.font =  .systemFont(ofSize: 11)
        todoButton.isSelected = true
        todoButton.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1)
        todoButton.layer.borderColor = UIColor.gray.cgColor
        todoButton.layer.borderWidth = 0.2
        todoButton.roundTop()
        todoButton.addTarget(self, action: #selector(filterPressed(sender:)), for: .touchUpInside)
        
        socialButton.setTitle("Socials", for: .normal)
        socialButton.setTitleColor(#colorLiteral(red: 0.3254901961, green: 0.3607843137, blue: 0.4078431373, alpha: 1), for: .normal)
        socialButton.setTitleColor(.black, for: .selected)
        socialButton.titleLabel?.font =  .systemFont(ofSize: 11)
        socialButton.isSelected = true
        socialButton.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1)
        socialButton.layer.borderColor = UIColor.gray.cgColor
        socialButton.layer.borderWidth = 0.2
        socialButton.roundTop()
        socialButton.addTarget(self, action: #selector(filterPressed(sender:)), for: .touchUpInside)
        
//        filesButton.setTitle("Files", for: .normal)
//        filesButton.setTitleColor(.white, for: .normal)
//        filesButton.setTitleColor(.black, for: .selected)
//        filesButton.titleLabel?.font =  .systemFont(ofSize: 11)
//        filesButton.isSelected = true
//        filesButton.backgroundColor = .lightGray
//        filesButton.layer.borderColor = UIColor.gray.cgColor
//        filesButton.layer.borderWidth = 0.2
//        filesButton.roundTop()
//        filesButton.addTarget(self, action: #selector(filterPressed(sender:)), for: .touchUpInside)
//

        infoButton.setTitle("Info", for: .normal)
        infoButton.setTitleColor(#colorLiteral(red: 0.3254901961, green: 0.3607843137, blue: 0.4078431373, alpha: 1), for: .normal)
        infoButton.setTitleColor(.black, for: .selected)
        infoButton.titleLabel?.font =  .systemFont(ofSize: 11)
        infoButton.isSelected = true
        infoButton.backgroundColor = .white
        infoButton.layer.borderColor = UIColor.gray.cgColor
        infoButton.layer.borderWidth = 0.2
        infoButton.roundTop()
        infoButton.addTarget(self, action: #selector(filterPressed(sender:)), for: .touchUpInside)
        
        
        topStackView.axis = .horizontal
        topStackView.distribution = .fillEqually
        topStackView.addArrangedSubview(logButton)
        topStackView.addArrangedSubview(todoButton)
        topStackView.addArrangedSubview(socialButton)
//        topStackView.addArrangedSubview(filesButton)
        topStackView.addArrangedSubview(infoButton)
        topView.addSubview(topStackView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(ContactDetailTableViewCell.self, forCellReuseIdentifier: "contactDetailCell")
        tableView.register(LogsTableViewCell.self, forCellReuseIdentifier: "cellLog")
        
        topView.addSubview(tableView)
        // for datepicker
        bottomView.backgroundColor = UIColor.white;
        buttonLeft.setTitle("Cancel", for: .normal);
        buttonRight.setTitle("Done", for: .normal);
        buttonLeft.setTitleColor(self.view.tintColor, for: .normal);
        buttonRight.setTitleColor(self.view.tintColor, for: .normal);
        datePickerView.datePickerMode = .date;
        datePickerView.timeZone = NSTimeZone.local;
        buttonRight.addTarget(self, action: #selector(doneButtonClick), for: .touchUpInside);
        buttonLeft.addTarget(self, action: #selector(cancelButtonClick), for: .touchUpInside);
        self.view.addSubview(bottomView);
        self.bottomView.addSubview(datePickerView);
        self.bottomView.addSubview(buttonLeft);
        self.bottomView.addSubview(buttonRight);
        self.bottomView.isHidden = true;
        
        saveButton.setTitle("Edit", for: .normal)
        saveButton.setTitle("Save", for: .selected)
        saveButton.titleLabel?.font = UIFont.ofSize(fontSize: 17, withType: .bold)
        saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        customnNavView.addSubview(saveButton)
        
        clearButton.setTitle("Close", for: .normal)
        clearButton.setTitle("Clear", for: .selected)
        clearButton.titleLabel?.font = UIFont.ofSize(fontSize: 17, withType: .bold)
        clearButton.addTarget(self, action: #selector(clear), for: .touchUpInside)
        clearButton.frame = CGRect(x: 0, y: -2, width: clearButton.frame.width, height: clearButton.frame.height)
        customnNavView.addSubview(clearButton)
        
        if !self.editData_YN {
            isCellEditing_YN = true;
            saveButton.isSelected = true
        }
        else
        {
            isCellEditing_YN = false;
        }
        
        view.addSubview(customnNavView)
        
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
    
    @objc func cancelButtonClick()
    {
        self.bottomView.isHidden = true;
    }
    
    @objc func doneButtonClick()
    {
        viewModel.addContactModel?.addContact_dateOfBirth = self.datePickerView.date
        //convertDateTimeToString(date: self.datePickerView.date);
        //self.textView.text = convertDateToString();
        self.bottomView.isHidden = true;
        self.tableView.reloadData();
    }
    
    @objc func editProfileImage() {
        
        if saveButton.isSelected {
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    @objc func save() {
        
        saveButton.isSelected = !saveButton.isSelected
        clearButton.isSelected = saveButton.isSelected
        
        if !saveButton.isSelected {
            view.endEditing(true);
            if self.editData_YN
            {
                viewModel.updateContactList(id: (viewModel.addContactModel?.addContact_id)!)
                self.navigationController?.popViewController(animated: false);
            }
            else
            {
                dismissKeyboard();
                viewModel.saveContact(completion: { val in
                    if val {
                        let alert = UIAlertController(title: "Success,New Contact has been saved.", message: "Add new contact again?", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "No", style:.cancel, handler:{ action in
                            self.navigationController?.popViewController(animated: false);
                        }))
                        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                            self.viewModel.addContactModel = AddContactModel()
                            self.saveButton.isSelected = true
                            self.tableView.reloadData()
                        }))
                        self.present(alert, animated: true, completion:nil);
                        
                    } else {
                        let alert = UIAlertController.alertControllerWithTitle(title: "Error", message: "Contacts not saved. Please check all the empty fields. ")
                        
                        self.saveButton.isSelected = !self.saveButton.isSelected
                        self.present(alert, animated: true, completion: nil);
                    }
                })
            }
        } else {
            isCellEditing_YN = true;
            self.tableView.reloadData();
        }
    }
    
    @objc func clear() {
        if !clearButton.isSelected {
            self.dismiss(animated: true, completion: nil)
            self.clearButton.isSelected = true
            return
        }
        
        let controller = UIAlertController(title: "Info", message: "Clear the fields?", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Cancel", style:.cancel, handler: { _ in
            self.clearButton.isSelected = false
        }));
        controller.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.viewModel.addContactModel = AddContactModel()
            self.clearButton.isSelected = false
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
            
            customnNavView.snp.makeConstraints{ make in
                make.top.equalTo(view.safeArea.top)
                make.left.right.equalToSuperview()
            }
            
            saveButton.snp.makeConstraints { make in
                make.size.equalTo(CGSize(width: 70, height: 40))
                make.right.top.bottom.equalToSuperview().inset(10)
            }
            
            clearButton.snp.makeConstraints { make in
                make.size.equalTo(CGSize(width: 100, height: 40))
                make.left.top.bottom.equalToSuperview().inset(10)
            }
            
            topView.snp.makeConstraints{ make in
                make.top.equalTo(customnNavView.snp.bottom)
                make.left.right.equalTo(view)
                make.bottom.equalTo(tableView.snp.bottom)
            }
            
            profileImageView.snp.makeConstraints { make in
                make.top.equalTo(topView).inset(10)
                make.size.equalTo(CGSize(width: 90, height: 90))
                make.centerX.equalTo(topView.snp.centerX)
            }
            scoreLabel.snp.makeConstraints{ make in
                make.top.equalTo(topView).inset(10)
                make.right.equalTo(topView).inset(5)
                make.size.equalTo(CGSize(width: 120, height: 30))
            }
            
            statusLabel.snp.makeConstraints{ make in
                make.top.equalTo(scoreLabel.snp.bottom).offset(5)
                make.right.equalTo(topView)
                make.size.equalTo(CGSize(width: 130, height: 30))
            }
            
            buttonStackView.snp.makeConstraints{ make in
                make.top.equalTo(topView).offset(20)
                make.left.equalTo(topView).inset(20)
                make.size.equalTo(CGSize(width: 40, height: 130))
            }
            
            nameLabel.snp.makeConstraints{ make in
                make.top.equalTo(profileImageView.snp.bottom).offset(5)
                 make.centerX.equalTo(topView.snp.centerX)
                make.size.equalTo(CGSize(width: 300, height: 50))
            }
            
            companyLabel.snp.makeConstraints{ make in
                make.top.equalTo(nameLabel.snp.bottom).offset(5)
                make.centerX.equalTo(topView.snp.centerX)
                make.size.equalTo(CGSize(width: 300, height: 30))
            }
            
            topStackView.snp.makeConstraints{ make in
                make.top.equalTo(companyLabel.snp.bottom).offset(10)
                make.bottom.equalTo(tableView.snp.top)
                make.left.equalTo(topView).offset(20)
                make.right.equalTo(topView).inset(20)
                make.height.equalTo(40)
            }
            
            
            tableView.snp.makeConstraints { make in
                make.top.equalTo(topStackView.snp.bottom).offset(10)
                make.left.right.equalTo(view)
                make.bottom.equalTo(view).inset(0)
            }
            
            bottomView.snp.makeConstraints { (make) in
                make.left.right.bottom.equalTo(self.view).inset(0);
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
                make.bottom.equalTo(self.view).inset(0);
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
    
    
    @objc func filterPressed(sender:UIButton) {
        //self.tableView .setContentOffset(.zero, animated: false)
        switch sender {
            
        case  logButton :
            
                    logButton.isSelected = true
                    todoButton.isSelected = false
                    socialButton.isSelected = false
                    filesButton.isSelected = false
                    infoButton.isSelected = false
                    selectedTab = "log"
                    logButton.backgroundColor = .white
                    todoButton.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1)
                    socialButton.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1)
                    filesButton.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1)
                    infoButton.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1)
                    resultHistoryList = ContactViewModel.queryContactHistoryTable(id: Defaults[.ContactID]!);
                    print(Defaults[.ContactID]!)
                    print(resultHistoryList);
                    self.tableView.reloadData();
            //viewModel.filterContact(isPotential: false, isCustomer: false, isDisqualified: false)
            
                   
                    
            break
        case todoButton:
            addNoteList = todoModel.getToDoListByContactID(test: (self.viewModel.addContactModel?.addContact_id)!);
                    logButton.isSelected = false
                    todoButton.isSelected = true
                    socialButton.isSelected = false
                    filesButton.isSelected = false
                    infoButton.isSelected = false
                    selectedTab = "todo"
                    logButton.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1)
                    todoButton.backgroundColor = .white
                    socialButton.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1)
                    filesButton.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1)
                    infoButton.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1)
            self.tableView.reloadData();
            break
            
        case socialButton :
                    logButton.isSelected = false
                    todoButton.isSelected = false
                    socialButton.isSelected = true
                    filesButton.isSelected = false
                    infoButton.isSelected = false
                    selectedTab = "social"
                    logButton.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1)
                    todoButton.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1)
                    socialButton.backgroundColor = .white
                    filesButton.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1)
                    infoButton.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1)
                    resultSocialList = ContactViewModel.queryContactSocialTable(id: Defaults[.ContactID]!);
            break
            
/*
        case filesButton :
                    logButton.isSelected = false
                    todoButton.isSelected = false
                    socialButton.isSelected = false
                    filesButton.isSelected = true
                    infoButton.isSelected = false
                    selectedTab = "files"
                    logButton.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1)
                    todoButton.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1)
                    socialButton.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1)
                    filesButton.backgroundColor = .white
                    infoButton.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1)
                    
            break
*/

            
        case infoButton :
                    logButton.isSelected = false
                    todoButton.isSelected = false
                    socialButton.isSelected = false
                    filesButton.isSelected = false
                    infoButton.isSelected = true
                    selectedTab = "info"
                    logButton.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1)
                    todoButton.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1)
                    socialButton.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1)
                    filesButton.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1)
                    infoButton.backgroundColor = .white
            
            
        default :
                    logButton.isSelected = false
                    todoButton.isSelected = false
                    socialButton.isSelected = false
                    filesButton.isSelected = false
                    infoButton.isSelected = true
                    selectedTab = "info"
                    logButton.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1)
                    todoButton.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1)
                    socialButton.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1)
                    filesButton.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1)
                    infoButton.backgroundColor = .white
        }
        
        tableView.reloadData()
        scrollToFirstRow()
    }
    
    func scrollToFirstRow() {
        let indexPath = NSIndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: false)
    }
    
    
    @objc func actionCall() {
        
        //trigger button call
        Defaults[.ContactID] = viewModel.addContactModel?.addContact_id;
        let contactNum = viewModel.addContactModel?.addContact_phoneNum.replacingOccurrences(of: " ", with: "")
        print(contactNum!);
        
        //        let url: NSURL = URL(string: "TEL://60127466766")! as NSURL
        //        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        let url:NSURL = URL(string: "tel://\(contactNum!)")! as NSURL
        UIApplication.shared.open(url as URL, options: [:], completionHandler: { val in
            
        })
    }
    
    @objc func actionSMS() {
        
        //trigger button sms
        let contactNum = viewModel.addContactModel?.addContact_phoneNum
        let contactName = viewModel.addContactModel?.addContact_contactName
        Defaults[.ContactID] = viewModel.addContactModel?.addContact_id;
        let actionSheet = UIAlertController(title: "Choose options", message: "Send SMS greetings to your lead.", preferredStyle: .actionSheet)
        
        
        let smsAction = UIAlertAction(title: "SMS", style: .default) { (action:UIAlertAction) in
            //UIApplication.shared.open(URL(string: "sms:")!, options: [:], completionHandler: nil)
            self.sendSMS(num: contactNum!, name: contactName!)
        }
        let whatsappAction = UIAlertAction(title: "Whatsapp", style: .default) { (action:UIAlertAction) in
            self.sendWhatsapp(num: contactNum!, name: contactName!)
        }
        
        actionSheet.addAction(smsAction)
        actionSheet.addAction(whatsappAction)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @objc func actionEmail() {
        
        //trigger button email
        let emailAddress = viewModel.addContactModel?.addContact_email
        let customerName = viewModel.addContactModel?.addContact_contactName
        Defaults[.ContactID] = viewModel.addContactModel?.addContact_id;
        if MFMailComposeViewController.canSendMail() {
            
            
            let emailTitle = "Hello"
            let messageBody = "Hello \(customerName ?? ""),"
            let toRecipents = [emailAddress]
            let mc: MFMailComposeViewController = MFMailComposeViewController()
            mc.mailComposeDelegate = self
            mc.setSubject(emailTitle)
            mc.setMessageBody(messageBody, isHTML: false)
            mc.setToRecipients(toRecipents as! [String])
            
            UIApplication.shared.keyWindow?.rootViewController?.present(mc, animated: true, completion: nil)
        } else {
            // show failure alert
            print("Can't send messages.")
        }
    }
    
    @objc func sendSMS(num: String, name:String){
        
        
        let mc: MFMessageComposeViewController = MFMessageComposeViewController()
        //let composeVC = MFMessageComposeViewController()
        mc.messageComposeDelegate = self
        
        // Configure the fields of the interface.
        mc.recipients = [num]
        mc.body = "Hello \(name)"
        
        if MFMessageComposeViewController.canSendText() {
            //             UIApplication.shared.keyWindow?.rootViewController?.present(mc, animated: true, completion: nil)
            self.present(mc, animated: true, completion: nil)
        } else {
            print("Can't send messages.")
        }
    }
    
    @objc func sendWhatsapp(num: String, name: String){
        
        let url  = "whatsapp://send?phone=\(num)&text=Hello \(name)\nFirst Whatsapp Share"
        
        var characterSet = CharacterSet.urlQueryAllowed
        characterSet.insert(charactersIn: "?&")
        if let escapedString = url.addingPercentEncoding(withAllowedCharacters: characterSet) {
            
            if let whatsappURL = NSURL(string: escapedString) {
                if UIApplication.shared.canOpenURL(whatsappURL as URL){
                    UIApplication.shared.open(whatsappURL as URL)
                }
                else {
                    let errorAlert = UIAlertView(title: "Cannot Send Message", message: "Your device is not able to send WhatsApp messages. Please install Whatsapp in your phone", delegate: self, cancelButtonTitle: "OK")
                    errorAlert.show()
                    
                }
            }
        }
        
    }
    
    override func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}

//MARK:- QLPreviewController Datasource
extension ContactDetailsViewController: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        
        return self.previewItem as QLPreviewItem
    }
}

extension ContactDetailsViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

//        switch selectedTab {
//            case "files":
//                // Setup QuickLook view controller
//                // QuickPreviewDelegate at the extension part
//                let previewController = QLPreviewController()
//
//                // "Exports" is the folder to keep csv file
//                previewItem = ContactDetailsViewModel.getDirectoryInNSURL(fileName: "Exports/ToDoInfo.csv")
//                previewController.dataSource = self
//                // open csv/excel file
//                self.present(previewController, animated: true, completion: nil)
//
//                break;
//            default:
//                print("select nothing");
//
//        }

        switch selectedTab {
            case "files":
                // Setup QuickLook view controller
                // QuickPreviewDelegate at the extension part
                let previewController = QLPreviewController()
                
                // "Exports" is the folder to keep csv file
                previewItem = ContactDetailsViewModel.getDirectoryInNSURL(fileName: "Exports/ToDoInfo.csv")
                previewController.dataSource = self
                // open csv/excel file
                self.present(previewController, animated: true, completion: nil)
                
                break;
            
            case "social":
                
                let getUserFB: String? =  self.viewModel.addContactModel?.addContact_Facebook
                let getUserWhatsapp: String? =  self.viewModel.addContactModel?.addContact_Whatsapp
                let getUserTwitter: String? =  self.viewModel.addContactModel?.addContact_Twitter
                let getUserLinkedin: String? =  self.viewModel.addContactModel?.addContact_Linkedin
                
                let FBAppLink = "fb://profile/\(getUserFB ?? "Check the username")"
                let FBWebLink = "http://www.facebook.com/\(getUserFB ?? "Check the username")"
                
                let WhatsappAppLink = "whatsapp://send?phone=\( getUserWhatsapp ?? "Check the username")&text=Hello"
                let WhatsappWebLink = "whatsapp://send?phone=\( getUserWhatsapp ?? "Check the username")&text=Hello"
                
                let TwitterAppLink = "twitter://user?screen_name=\(getUserTwitter ?? "Check the username")"
                let TwitterWebLink = "https://twitter.com/\(getUserTwitter ?? "Check the username")"
               
                let LinkedInAppLink = "linkedin://profile/\(getUserLinkedin ?? "Check the username")"
                let LinkedInWebLink = "https://www.linkedin.com/in/\(getUserLinkedin ?? "Check the username")/"
             
                            if indexPath.row == 0 { //facebook selected
                                
                                if getUserFB != "" {
                                let appURL = NSURL(string: FBAppLink)!
                                let webURL = NSURL(string: FBWebLink)!
                                
                                if UIApplication.shared.canOpenURL(appURL as URL) {
                                    if #available(iOS 10.0, *) {
                                        UIApplication.shared.open(appURL as URL, options: [:], completionHandler: nil)
                                        
                                     
                                    } else {
                                        UIApplication.shared.openURL(appURL as URL)
                                    }
                                } else {
                                    //redirect to safari because the user doesn't have Instagram
                                    if #available(iOS 10.0, *) {
                                        UIApplication.shared.open(webURL as URL, options: [:], completionHandler: nil)
                                    } else {
                                        UIApplication.shared.openURL(webURL as URL)
                                    }
                                    }
                                } else {
                                    
                                    let alert = UIAlertController(title: "Check Facebook username.", message: "Please fill up contact's Facebook username on Info tab. Click edit button and type in username on the text field.", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style:.cancel, handler: nil))
                                   
                                    self.present(alert, animated: true, completion:nil);
                                }
                                
                            } else if indexPath.row == 1 { //whatsapp selected
                                
                                
                              if getUserWhatsapp != "" {
                                let appURL = NSURL(string: WhatsappAppLink)!
                                let webURL = NSURL(string: WhatsappWebLink)!
                                
                                if UIApplication.shared.canOpenURL(appURL as URL) {
                                    if #available(iOS 10.0, *) {
                                        UIApplication.shared.open(appURL as URL, options: [:], completionHandler: nil)
                                        
                                        
                                    } else {
                                        UIApplication.shared.openURL(appURL as URL)
                                    }
                                } else {
                                    //redirect to safari because the user doesn't have Instagram
                                    if #available(iOS 10.0, *) {
                                        UIApplication.shared.open(webURL as URL, options: [:], completionHandler: nil)
                                    } else {
                                        UIApplication.shared.openURL(webURL as URL)
                                    }
                                }
                              } else {
                                
                                let alert = UIAlertController(title: "Check Whatsapp number.", message: "Please fill up contact's registered Whatsapp number on Info tab. Click edit button and type in number on the text field.", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style:.cancel, handler: nil))
                                
                                self.present(alert, animated: true, completion:nil);
                                }
                            } else if indexPath.row == 2 { //twitter selected
                               
                                if getUserTwitter != "" {
                                let appURL = NSURL(string: TwitterAppLink)!
                                let webURL = NSURL(string: TwitterWebLink)!
                                
                                if UIApplication.shared.canOpenURL(appURL as URL) {
                                    if #available(iOS 10.0, *) {
                                        UIApplication.shared.open(appURL as URL, options: [:], completionHandler: nil)
                                        
                                        
                                    } else {
                                        UIApplication.shared.openURL(appURL as URL)
                                    }
                                } else {
                                    //redirect to safari because the user doesn't have Instagram
                                    if #available(iOS 10.0, *) {
                                        UIApplication.shared.open(webURL as URL, options: [:], completionHandler: nil)
                                    } else {
                                        UIApplication.shared.openURL(webURL as URL)
                                    }
                                }
                                } else {
                                    
                                    let alert = UIAlertController(title: "Check Twitter username.", message: "Please fill up contact's Twitter username on Info tab. Click edit button and type in username on the text field.", preferredStyle: .alert)
                                     alert.addAction(UIAlertAction(title: "OK", style:.cancel, handler: nil))
                                    
                                    self.present(alert, animated: true, completion:nil);
                                }
                            } else if indexPath.row == 3 { //linkedin selected
                                
                                if getUserLinkedin != "" {
                                let appURL = NSURL(string: LinkedInAppLink)!
                                let webURL = NSURL(string: LinkedInWebLink)!
                                
                                if UIApplication.shared.canOpenURL(appURL as URL) {
                                    if #available(iOS 10.0, *) {
                                        UIApplication.shared.open(appURL as URL, options: [:], completionHandler: nil)
                                        
                                        
                                    } else {
                                        UIApplication.shared.openURL(appURL as URL)
                                    }
                                } else {
                                    //redirect to safari because the user doesn't have Instagram
                                    if #available(iOS 10.0, *) {
                                        UIApplication.shared.open(webURL as URL, options: [:], completionHandler: nil)
                                    } else {
                                        UIApplication.shared.openURL(webURL as URL)
                                    }
                                }
                                
                            } else {
                                    
                                    let alert = UIAlertController(title: "Check Linkedin username.", message: "Please fill up contact's Linkedin username on Info tab. Click edit button and type in username on the text field.", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style:.cancel, handler: nil))
                                    
                                    self.present(alert, animated: true, completion:nil);
                                }
                          }
                            break;
            
            
                            default:
                            print("select nothing");
        }
        
        let data = viewModel.detailRows[indexPath.row]
        
        //add rows details here
        
        if selectedTab == "info" {
            
            if saveButton.isSelected {
                if indexPath.row == 1{
                    self.showDateTimePicker()
                    view.endEditing(true)
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

        }
        else if selectedTab == "todo"
        {
            let detailController = DetailsTodoListViewController()
            detailController.isControllerEditing = true
            
            let todoModel = AddNoteModel()
            todoModel.addNote_ID = addNoteList[indexPath.row].id
            todoModel.addNote_alertDateTime = addNoteList[indexPath.row].addNote_alertDateTime
            todoModel.addNote_repeat = addNoteList[indexPath.row].addNote_repeat
            todoModel.addNote_subject = addNoteList[indexPath.row].addNote_subject
            
            if let customerModel = RealmStore<ContactModel>().models(query: "id == '\(addNoteList[indexPath.row].addNote_customerId!)'")?.first {
                todoModel.addNote_customer = customerModel
            }
            
            todoModel.addNote_taskType = addNoteList[indexPath.row].addNote_taskType
            todoModel.addNote_notes = addNoteList[indexPath.row].addNote_notes
            todoModel.addNote_location = addNoteList[indexPath.row].addNote_location
            var checklist:[ChecklistTemp] = []
            
            for x in addNoteList[indexPath.row].addNote_checklist {
                let checklisttemp = ChecklistTemp()
                checklisttemp.id = x.id
                checklisttemp.title = x.title
                checklisttemp.status = x.status
                checklist.append(checklisttemp)
            }
            
            todoModel.addNote_checkList = checklist
            
            detailController.setupModel = todoModel
            detailController.naviFlag = "Contact";
            //self.navigationController?.pushViewController(detailController, animated: false)
            self.present(detailController, animated: false, completion: nil)
            
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
        switch selectedTab {
         
        case "log":
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellLog", for: indexPath) as! LogsTableViewCell
            cell.nextIcon.isHidden = true
            if resultHistoryList[indexPath.row].CH_HistoryType == "Call" {
            cell.leftIcon = "phone-circle"
            } else if resultHistoryList[indexPath.row].CH_HistoryType == "SMS" {
                cell.leftIcon = "message-circle"
            } else if resultHistoryList[indexPath.row].CH_HistoryType == "Email" {
                cell.leftIcon = "mail-circle"
            } else {
                
                
            }
            cell.selectionStyle = .none
            cell.iconImage.backgroundColor = CommonColor.systemWhiteColor
           //populate logs here using the customer logs info from database
            cell.labelTitle.text = resultHistoryList[indexPath.row].CH_HistoryType; //"Call log \(indexPath.row)"
            cell.labelDesc.text = ""
            cell.labelDate.text = convertDateTimeToString(date: resultHistoryList[indexPath.row].CH_CallingDate!, dateFormat: "dd-MMM-yyyy HH:mm:ss") ;
            return cell
           
            
        case "todo":
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellLog", for: indexPath) as! LogsTableViewCell
            //let data = viewModel.detailRows[indexPath.row]
           
            
            if  addNoteList[indexPath.row].addNote_taskType == "Appointment"{
                cell.leftIcon = "taskIcon"
                
                if addNoteList[indexPath.row].status == "Follow Up"
                {
                    cell.leftIcon = "taskIcon"
                    cell.iconImage.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                }
                else if addNoteList[indexPath.row].status == "Discontinue"
                {
                    cell.leftIcon = "taskIcon"
                    cell.iconImage.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
                }
                else if addNoteList[indexPath.row].status == "Completed"
                {
                    cell.leftIcon = "taskIcon"
                    cell.iconImage.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                }
                else
                {
                    cell.iconImage.backgroundColor = CommonColor.turquoiseColor
                }
                
            } else if addNoteList[indexPath.row].addNote_taskType == "Customer Birthday"{
                cell.leftIcon = "cakeIcon"
                cell.iconImage.backgroundColor = CommonColor.redColor
            } else {
                
                cell.leftIcon = "taskIcon"
                cell.iconImage.backgroundColor = CommonColor.turquoiseColor
            }
            
            //cell.selectionStyle = .none
            cell.labelTitle.isEnabled = false
            cell.nextIcon.isHidden = false
            cell.labelTitle.text = addNoteList[indexPath.row].addNote_subject;
            cell.labelDate.text = convertDateTimeToString(date: addNoteList[indexPath.row].addNote_alertDateTime!)
            /*
            if indexPath.row == 0 {
                cell.labelTitle.isEnabled = true
                cell.nextIcon.isHidden = true
                
                cell.labelTitle.text = "Introduce you self"
                
            } else if indexPath.row == 1 {
                cell.labelTitle.isEnabled = true
                cell.nextIcon.isHidden = true
                 cell.labelTitle.text = "Present the Company"
            } else if indexPath.row == 2 {
                cell.labelTitle.isEnabled = true
                cell.nextIcon.isHidden = true
                 cell.labelTitle.text = "Share Success Stories"
            } else if indexPath.row == 3 {
                cell.labelTitle.isEnabled = true
                cell.nextIcon.isHidden = true
                 cell.labelTitle.text = "Ask if intereseted or not"
            }
 
            cell.labelTitle.isEnabled = false
 */

            return cell
            
        case "social":
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "contactDetailCell", for: indexPath) as! ContactDetailTableViewCell
            let data = viewModel.detailRows[indexPath.row]
            //cell.leftIcon = data.icon
            self.populateSocialData(cell: cell, index: indexPath, data: data)
            //self.populateInfoData(cell: cell, index: indexPath, data:data)
            cell.isUserInteractionEnabled = true
            //let socialList = SocialClass()
            cell.selectionStyle = .none
            var socialUrl:String = "";
            if resultSocialList.count > 0
            {
                socialUrl = resultSocialList[indexPath.row].CS_SocialUrl;
            }
            
            
                    cell.isEditing = false
                    if indexPath.row == 0 {
                        cell.labelTitle.isEnabled = false
                        cell.nextIcon.isHidden = true
                        cell.leftIcon = "facebook-icon"
                        cell.title = "facebook"
                        cell.textFieldsCallback = { val in
                            self.viewModel.addContactModel?.addContact_Facebook = val
                            //cell.labelTitle.text = "Facebook: \(self.viewModel.addContactModel?.addContact_Facebook ?? "") "
                        }
                        //cell.labelTitle.text = "Facebook:"
                        
                    } else if indexPath.row == 1 {
                        cell.labelTitle.isEnabled = false
                        cell.nextIcon.isHidden = true
                        cell.leftIcon = "whatsapp-icon"
                        cell.title = "whatsapp"
                        cell.textFieldsCallback = { val in
                            self.viewModel.addContactModel?.addContact_Whatsapp = val
                            //cell.labelTitle.text = "Whatsapp: \(self.viewModel.addContactModel?.addContact_Whatsapp ?? "") "
                        }
                        
                       
                    } else if indexPath.row == 2 {
                        cell.labelTitle.isEnabled = false
                        cell.nextIcon.isHidden = true
                        cell.leftIcon = "twitter-icon"
                        cell.title = "twitter";
                        cell.textFieldsCallback = { val in
                            self.viewModel.addContactModel?.addContact_Twitter = val
                            //cell.labelTitle.text = "Twitter: \(self.viewModel.addContactModel?.addContact_Twitter ?? "")"
                        }
                        
                
                        
                    } else if indexPath.row == 3 {
                        cell.labelTitle.isEnabled = false
                        cell.nextIcon.isHidden = true
                        cell.leftIcon = "linkedin-icon"
                        cell.title = "linkedin";
                        cell.textFieldsCallback = { val in
                            self.viewModel.addContactModel?.addContact_Linkedin = val
                            //cell.labelTitle.text = "Linkedin: \(self.viewModel.addContactModel?.addContact_Linkedin ?? "")"
                        }
                        
                        
                    }
        
            
            
            return cell
        
        case "files":
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "contactDetailCell", for: indexPath) as! ContactDetailTableViewCell
            let data = viewModel.detailRows[indexPath.row]
            cell.leftIcon = "archive-icon"
           
            cell.selectionStyle = .none
            
            cell.labelTitle.text = "File \(indexPath.row)"
            
            
            return cell
            
            
        case "info":
            let cell = tableView.dequeueReusableCell(withIdentifier: "contactDetailCell", for: indexPath) as! ContactDetailTableViewCell
            
            if !isCellEditing_YN {
                cell.contentView.alpha = 0.5;
                cell.isUserInteractionEnabled = false;
            }
            else
            {
                cell.contentView.alpha = 1.0;
                cell.isUserInteractionEnabled = true;
            }
            
            let data = viewModel.detailRows[indexPath.row]
            cell.leftIcon = data.icon
            cell.labelTitle.text = "";
            self.populateInfoData(cell: cell, index: indexPath, data:data)
            
            let customSelectionView = UIView();
            customSelectionView.backgroundColor = UIColor.clear
            cell.selectedBackgroundView = customSelectionView
            
            if saveButton.isSelected {
                cell.isEditing = true
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
                    cell.labelTitle.keyboardType = .numberPad
                    cell.labelTitle.isEnabled = true
                    cell.nextIcon.isHidden = true
                    cell.textFieldsCallback = { val in
                        self.viewModel.addContactModel?.addContact_phoneNum = val
                    }
                } else if indexPath.row == 4 {
                    cell.labelTitle.keyboardType = .emailAddress
                    cell.labelTitle.isEnabled = true
                    cell.nextIcon.isHidden = true
                    cell.textFieldsCallback = { val in
                        self.viewModel.addContactModel?.addContact_email = val
                    }
                }  else if indexPath.row == 8 {
                    cell.labelTitle.isEnabled = true
                    cell.nextIcon.isHidden = true
                    cell.textFieldsCallback = { val in
                        self.viewModel.addContactModel?.addContact_Facebook = val
                    }
                }  else if indexPath.row == 9 {
                    cell.labelTitle.isEnabled = true
                    cell.nextIcon.isHidden = true
                    cell.textFieldsCallback = { val in
                        self.viewModel.addContactModel?.addContact_Whatsapp = val
                    }
                }  else if indexPath.row == 10 {
                    cell.labelTitle.isEnabled = true
                    cell.nextIcon.isHidden = true
                    cell.textFieldsCallback = { val in
                        self.viewModel.addContactModel?.addContact_Twitter = val
                    }
                }  else if indexPath.row == 11 {
                    cell.labelTitle.isEnabled = true
                    cell.nextIcon.isHidden = true
                    cell.textFieldsCallback = { val in
                        self.viewModel.addContactModel?.addContact_Linkedin = val
                    }
                } else
                {
                    cell.labelTitle.isEnabled = false;
                    cell.nextIcon.isHidden = false;
                }
            } else {
                cell.isEditing = false
                if indexPath.row == 0 {
                    cell.labelTitle.isEnabled = false
                    cell.nextIcon.isHidden = true
                    cell.textFieldsCallback = { val in
                        self.viewModel.addContactModel?.addContact_contactName = val
                    }
                } else if indexPath.row == 2 {
                    cell.labelTitle.isEnabled = false
                    cell.nextIcon.isHidden = true
                    cell.textFieldsCallback = { val in
                        self.viewModel.addContactModel?.addContact_address = val
                    }
                } else if indexPath.row == 3 {
                    cell.labelTitle.isEnabled = false
                    cell.nextIcon.isHidden = true
                    cell.textFieldsCallback = { val in
                        self.viewModel.addContactModel?.addContact_phoneNum = val
                    }
                } else if indexPath.row == 4 {
                    cell.labelTitle.isEnabled = false
                    cell.nextIcon.isHidden = true
                    cell.textFieldsCallback = { val in
                        self.viewModel.addContactModel?.addContact_email = val
                    }
                } else if indexPath.row == 8 {
                    cell.labelTitle.isEnabled = false
                    cell.nextIcon.isHidden = true
                    cell.textFieldsCallback = { val in
                        self.viewModel.addContactModel?.addContact_Facebook = val
                    }
                }  else if indexPath.row == 9 {
                    cell.labelTitle.isEnabled = false
                    cell.nextIcon.isHidden = true
                    cell.textFieldsCallback = { val in
                        self.viewModel.addContactModel?.addContact_Whatsapp = val
                    }
                }  else if indexPath.row == 10 {
                    cell.labelTitle.isEnabled = false
                    cell.nextIcon.isHidden = true
                    cell.textFieldsCallback = { val in
                        self.viewModel.addContactModel?.addContact_Twitter = val
                    }
                }  else if indexPath.row == 11 {
                    cell.labelTitle.isEnabled = false
                    cell.nextIcon.isHidden = true
                    cell.textFieldsCallback = { val in
                        self.viewModel.addContactModel?.addContact_Linkedin = val
                    }
                } else {
                    
                    cell.labelTitle.isEnabled = false;
                    cell.nextIcon.isHidden = false;
                }
            }
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "contactDetailCell", for: indexPath) as! ContactDetailTableViewCell
            let data = viewModel.detailRows[indexPath.row]
            cell.leftIcon = data.icon
            cell.labelTitle.text = "";
            self.populateInfoData(cell: cell, index: indexPath, data:data)
            

            //cell.selectionStyle = .none

            let customSelectionView = UIView();
            customSelectionView.backgroundColor = UIColor.clear
            cell.selectedBackgroundView = customSelectionView
            
            if saveButton.isSelected {
                cell.isEditing = true
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
                }  else if indexPath.row == 8 {
                    cell.labelTitle.isEnabled = true
                    cell.nextIcon.isHidden = true
                    cell.textFieldsCallback = { val in
                        self.viewModel.addContactModel?.addContact_Facebook = val
                    }
                }  else if indexPath.row == 9 {
                    cell.labelTitle.isEnabled = true
                    cell.nextIcon.isHidden = true
                    cell.textFieldsCallback = { val in
                        self.viewModel.addContactModel?.addContact_Whatsapp = val
                    }
                }  else if indexPath.row == 10 {
                    cell.labelTitle.isEnabled = true
                    cell.nextIcon.isHidden = true
                    cell.textFieldsCallback = { val in
                        self.viewModel.addContactModel?.addContact_Twitter = val
                    }
                }  else if indexPath.row == 11 {
                    cell.labelTitle.isEnabled = true
                    cell.nextIcon.isHidden = true
                    cell.textFieldsCallback = { val in
                        self.viewModel.addContactModel?.addContact_Linkedin = val
                    }
                } else
                {
                    cell.labelTitle.isEnabled = false;
                    cell.nextIcon.isHidden = false;
                }
            } else {
                cell.isEditing = false
                if indexPath.row == 0 {
                    cell.labelTitle.isEnabled = false
                    cell.nextIcon.isHidden = true
                    cell.textFieldsCallback = { val in
                        self.viewModel.addContactModel?.addContact_contactName = val
                    }
                } else if indexPath.row == 2 {
                    cell.labelTitle.isEnabled = false
                    cell.nextIcon.isHidden = true
                    cell.textFieldsCallback = { val in
                        self.viewModel.addContactModel?.addContact_address = val
                    }
                } else if indexPath.row == 3 {
                    cell.labelTitle.isEnabled = false
                    cell.nextIcon.isHidden = true
                    cell.textFieldsCallback = { val in
                        self.viewModel.addContactModel?.addContact_phoneNum = val
                    }
                } else if indexPath.row == 4 {
                    cell.labelTitle.isEnabled = false
                    cell.nextIcon.isHidden = true
                    cell.textFieldsCallback = { val in
                        self.viewModel.addContactModel?.addContact_email = val
                    }
                } else if indexPath.row == 8 {
                    cell.labelTitle.isEnabled = false
                    cell.nextIcon.isHidden = true
                    cell.textFieldsCallback = { val in
                        self.viewModel.addContactModel?.addContact_Facebook = val
                    }
                }  else if indexPath.row == 9 {
                    cell.labelTitle.isEnabled = false
                    cell.nextIcon.isHidden = true
                    cell.textFieldsCallback = { val in
                        self.viewModel.addContactModel?.addContact_Whatsapp = val
                    }
                }  else if indexPath.row == 10 {
                    cell.labelTitle.isEnabled = false
                    cell.nextIcon.isHidden = true
                    cell.textFieldsCallback = { val in
                        self.viewModel.addContactModel?.addContact_Twitter = val
                    }
                }  else if indexPath.row == 11 {
                    cell.labelTitle.isEnabled = false
                    cell.nextIcon.isHidden = true
                    cell.textFieldsCallback = { val in
                        self.viewModel.addContactModel?.addContact_Linkedin = val
                    }
                } else {
                    
                    cell.labelTitle.isEnabled = false;
                    cell.nextIcon.isHidden = false;
                }
            }
            
            return cell
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if selectedTab == "log"{
            return resultHistoryList.count;
        }
        else if selectedTab == "todo" {
            return addNoteList.count;
        } else if selectedTab == "social" {
            return 4
        } else if selectedTab == "files" {
            return 4
        } else {
        
        return viewModel.detailRows.count
        }
    }
    
    func populateInfoData(cell:ContactDetailTableViewCell,index:IndexPath,data:AddContactViewObject) {
        
        if let viewmod = viewModel.addContactModel {
            switch index.row {
            case 0:
//                cell.title = viewmod.addContact_contactName == "" ? data.title :
//                viewmod.addContact_contactName
                cell.title = data.title;
                cell.labelTitle.text = viewmod.addContact_contactName;
                Defaults[.ContactID] = viewmod.addContact_id;
            case 1:
//                cell.title = viewmod.addContact_dateOfBirth == nil ? data.title:
//                convertDateTimeToString(date: viewmod.addContact_dateOfBirth!)
                if viewmod.addContact_dateOfBirth == nil
                {
                    cell.title = data.title;
                }
                else
                {
                    cell.labelTitle.text = convertDateTimeToString(date: viewmod.addContact_dateOfBirth!);
                }
                
                //cell.labelTitle.text = convertDateTimeToString(date: viewmod.addContact_dateOfBirth!);
            case 2:
                //cell.title = viewmod.addContact_address == "" ? data.title: viewmod.addContact_address
                cell.title = data.title;
                cell.labelTitle.text = viewmod.addContact_address;
            case 3:
                //cell.title = viewmod.addContact_phoneNum == "" ? data.title: viewmod.addContact_phoneNum
                cell.title = data.title;
                cell.labelTitle.text = viewmod.addContact_phoneNum;
            case 4:
//                cell.title = viewmod.addContact_email == "" ? data.title: viewmod.addContact_email
                cell.title = data.title;
                cell.labelTitle.text = viewmod.addContact_email;
            case 5:
                let x:Int = viewmod.addContact_leadScore
                //print("Lead Score ----->\(x)")
                //cell.title = viewmod.addContact_leadScore == 0 ? data.title: "\(x)"
                if viewmod.addContact_leadScore == 0
                {
                    cell.title = data.title;
                }
                else
                {
                    cell.labelTitle.text = "\(x)";
                }
                
                
            case 6:
//                cell.title = viewmod.addContact_remarks == "" ? data.title:
//                viewmod.addContact_remarks
                cell.title = data.title;
                cell.labelTitle.text = viewmod.addContact_remarks;
            case 7:
                //cell.title = viewmod.addContact_status == "" ? data.title:
                    //viewmod.addContact_status
                //print("Status -----> \(viewmod.addContact_status)")
                cell.title = data.title;
                cell.labelTitle.text = viewmod.addContact_status;
                
            case 8:
                
                cell.title = data.title;
                cell.labelTitle.text = viewmod.addContact_Facebook;
                
            case 9:
                
                cell.title = data.title;
                cell.labelTitle.text = viewmod.addContact_Whatsapp;
                
            case 10:
                
                cell.title = data.title;
                cell.labelTitle.text = viewmod.addContact_Twitter;
                
            case 11:
                
                cell.title = data.title;
                cell.labelTitle.text = viewmod.addContact_Linkedin;
                
            default:
                break
            }
        } else {
            print("Something wrong here");
            cell.title = data.title
            cell.labelTitle.text = "Error come";
        }
    }
    
    func populateLogData(cell:LogsTableViewCell,index:IndexPath,data:AddContactViewObject) {
        
        if let viewmod = viewModel.addLogDetails {
            
            cell.title = viewmod.log_task
            cell.date = "\(viewmod.log_date)"
            cell.desc = viewmod.log_details

        } else {
            cell.title = data.title
        }
    }
    
    func populateSocialData(cell:ContactDetailTableViewCell,index:IndexPath,data:AddContactViewObject) {
        
        if let viewmod = viewModel.addContactModel {
            print(viewmod.addContact_Facebook);
            switch index.row {
                
            case 0:
                cell.title = "facebook";
                cell.labelTitle.text = viewmod.addContact_Facebook;
//                cell.title = viewmod.addContact_Facebook == "" ? data.title :
//                viewmod.addContact_Facebook
                
            case 1:
                cell.title = "whatsapp";
                cell.labelTitle.text = viewmod.addContact_Whatsapp;
//                cell.title = viewmod.addContact_Whatsapp == "" ? data.title :
//                viewmod.addContact_Whatsapp
                
            case 2:
                cell.title = "twitter";
                cell.labelTitle.text = viewmod.addContact_Twitter;
//                cell.title = viewmod.addContact_Twitter == "" ? data.title :
//                viewmod.addContact_Twitter
                
            case 3:
                cell.title = "linkedin";
                cell.labelTitle.text = viewmod.addContact_Linkedin;
//                cell.title = viewmod.addContact_Linkedin == "" ? data.title :
//                viewmod.addContact_Linkedin
            default:
                cell.title = ""
            }
        }
    }
    
//    //Date Picker
//    func showDatePicker(){
//        //Formate Date
//        datePicker.datePickerMode = .date
//
//        //ToolBar
//        let toolbar = UIToolbar();
//        toolbar.sizeToFit()
//        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
//        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
//        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
//
//        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
//
//        txtDatePicker.inputAccessoryView = toolbar
//        txtDatePicker.inputView = datePicker
//
//    }
//
//    @objc func donedatePicker(){
//
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd/MM/yyyy"
//        txtDatePicker.text = formatter.string(from: datePicker.date)
//        self.view.endEditing(true)
//    }
//
//    @objc func cancelDatePicker(){
//        self.view.endEditing(true)
//    }

    
}

extension ContactDetailsViewController:UIActionSheetDelegate {
    
    func sheetPressedScoring(data:AddContactViewObject){
        let actionSheet = UIAlertController(title: "Choose options", message: "How will you rate your lead? 5 - highest and 1 - lowest.", preferredStyle: .actionSheet)
        
        for title in data.alertOptions {
            let action = UIAlertAction(title: title, style: .default) { (action:UIAlertAction) in
                //if data.title == "Lead Scoring" {
                    self.viewModel.addContactModel?.addContact_leadScore = Int(title)!
                    
                //}
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
//        let datePickerController = DateAndTimePickerViewController()
//        datePickerController.delegate = self
//        self.present(datePickerController, animated: true, completion: nil)
        
         self.bottomView.isHidden = false;
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


extension ContactDetailsViewController : MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate{
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result {
        case .sent:
            print("azlim : " + Defaults[.ContactID]!);
            if !ContactViewModel.insertDataContactHistoryModel(cID: Defaults[.ContactID]!, cHistoryType: "SMS")
            {
                print("Something wrong");
            }
            break;
        default:
            print("Send SMS fail");
        }
        controller.dismiss(animated: true)
    }
    
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .sent:
            if !ContactViewModel.insertDataContactHistoryModel(cID: Defaults[.ContactID]!, cHistoryType: "Email")
            {
                print("Something wrong");
            }
            break;
        default:
            print("Send SMS fail");
        }
        controller.dismiss(animated: true)
    }
    
    
}


extension UIView {
    
    func roundTop(radius:CGFloat = 10){
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
    }
    
    func roundBottomRight(radius:CGFloat = 20){
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = [.layerMinXMaxYCorner]
        } else {
            // Fallback on earlier versions
        }
    }
    
//    func addBackground() {
//        let width = UIScreen.main.bounds.size.width
//        let height = UIScreen.main.bounds.size.height
//
//        let imageViewBackground = UIImageView(frame: CGRect(x:0, y:0, width: width, height: height))
//        imageViewBackground.image = UIImage(named: "contact-details-gradiant-bg")
//
//        // you can change the content mode:
//        imageViewBackground.contentMode = UIView.ContentMode.scaleAspectFill
//
//        self.addSubview(imageViewBackground)
//        self.sendSubviewToBack(imageViewBackground)
//    }
}


//For Social Link
extension UIApplication {
    class func tryURL(urls: [String]) {
        let application = UIApplication.shared
        for url in urls {
            if application.canOpenURL(URL(string: url)!) {
                //application.openURL(URL(string: url)!)
                application.open(URL(string: url)!, options: [:], completionHandler: nil)
                return
            }
        }
    }
}
