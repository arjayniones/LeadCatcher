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

import RealmSwift
import MessageUI


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
    var isControllerEditing:Bool = false
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(ContactDetailsViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ContactDetailsViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
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
        let name = viewModel.addContactModel?.addContact_contactName
        nameLabel.text = name == "" ? "No Name" : name
        nameLabel.textAlignment = .center
        
        
        companyLabel.text = viewModel.addContactModel?.addContact_address
        companyLabel.textAlignment = .center
        companyLabel.adjustsFontSizeToFitWidth = true 
        
        let score = viewModel.addContactModel?.addContact_leadScore
        scoreLabel.textColor = .orange
        
        if score == 0 {
              scoreLabel.text = "No Ratings"
        } else if score == 1 {
              scoreLabel.text = "★✩✩✩✩"
        } else if score == 2 {
            scoreLabel.text = "★★✩✩✩"
        } else if score == 3 {
            scoreLabel.text = "★★★✩✩"
        } else if score == 4 {
            scoreLabel.text = "★★★★✩"
        }  else if score == 5 {
            scoreLabel.text = "★★★★★"
        }
        
        let status = viewModel.addContactModel?.addContact_status
        statusLabel.text = status == "" ? "No Meeting Yet" : status 
        
        view.addSubview(nameLabel)
        view.addSubview(companyLabel)
        view.addSubview(scoreLabel)
        view.addSubview(statusLabel)
//        view.addSubview(callButton)
//        view.addSubview(smsButton)
//        view.addSubview(emailButton)

        
        let imageCall = UIImage(named: "phone-icon")
        callButton.setImage(imageCall, for: .normal)
        callButton.isSelected = true
        callButton.backgroundColor = .white
        callButton.addTarget(self, action: #selector(actionCall), for: .touchUpInside)
        
        let imageSMS = UIImage(named: "message-template-icon")
        smsButton.setImage(imageSMS, for: .normal)
        smsButton.isSelected = true
        smsButton.backgroundColor = .white
        smsButton.addTarget(self, action: #selector(actionSMS), for: .touchUpInside)
        
        let imageEmail = UIImage(named: "email-icon")
        emailButton.setImage(imageEmail, for: .normal)
        emailButton.isSelected = true
        emailButton.backgroundColor = .white
        emailButton.addTarget(self, action: #selector(actionEmail), for: .touchUpInside)
        
        
        
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.addArrangedSubview(callButton)
        buttonStackView.addArrangedSubview(smsButton)
        buttonStackView.addArrangedSubview(emailButton)
        view.addSubview(buttonStackView)
        
        logButton.setTitle("Logs", for: .normal)
        logButton.setTitleColor(.white, for: .normal)
        logButton.setTitleColor(.black, for: .selected)
        logButton.titleLabel?.font =  .systemFont(ofSize: 11)
        logButton.isSelected = true
        logButton.backgroundColor = .white
        logButton.addTarget(self, action: #selector(filterPressed(sender:)), for: .touchUpInside)
        
        todoButton.setTitle("To Do", for: .normal)
        todoButton.setTitleColor(.white, for: .normal)
        todoButton.setTitleColor(.black, for: .selected)
        todoButton.titleLabel?.font =  .systemFont(ofSize: 11)
        todoButton.isSelected = true
        todoButton.backgroundColor = .white
        todoButton.addTarget(self, action: #selector(filterPressed(sender:)), for: .touchUpInside)
        
        socialButton.setTitle("Socials", for: .normal)
        socialButton.setTitleColor(.white, for: .normal)
        socialButton.setTitleColor(.black, for: .selected)
        socialButton.titleLabel?.font =  .systemFont(ofSize: 11)
        socialButton.isSelected = true
        socialButton.backgroundColor = .white
        socialButton.addTarget(self, action: #selector(filterPressed(sender:)), for: .touchUpInside)
        
        filesButton.setTitle("Files", for: .normal)
        filesButton.setTitleColor(.white, for: .normal)
        filesButton.setTitleColor(.black, for: .selected)
        filesButton.titleLabel?.font =  .systemFont(ofSize: 11)
        filesButton.isSelected = true
        filesButton.backgroundColor = .white
        filesButton.addTarget(self, action: #selector(filterPressed(sender:)), for: .touchUpInside)
        
        infoButton.setTitle("Info", for: .normal)
        infoButton.setTitleColor(.white, for: .normal)
        infoButton.setTitleColor(.black, for: .selected)
        infoButton.titleLabel?.font =  .systemFont(ofSize: 11)
        infoButton.isSelected = true
        infoButton.backgroundColor = .white
        infoButton.addTarget(self, action: #selector(filterPressed(sender:)), for: .touchUpInside)
        
        
        topStackView.axis = .horizontal
        topStackView.distribution = .fillEqually
        topStackView.addArrangedSubview(logButton)
        topStackView.addArrangedSubview(todoButton)
        topStackView.addArrangedSubview(socialButton)
        topStackView.addArrangedSubview(filesButton)
        topStackView.addArrangedSubview(infoButton)
        view.addSubview(topStackView)
        
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
    
    //keyboard
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
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
    
    @objc func editProfileImage() {
        self.present(imagePickerController, animated: true, completion: nil)
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
                let alert = UIAlertController.alertControllerWithTitle(title: "Error", message: "Contacts not saved. Please check all the empty fields. ")
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
            scoreLabel.snp.makeConstraints{ make in
                make.top.equalTo(view).inset(10)
                make.right.equalTo(view).inset(10)
                make.size.equalTo(CGSize(width: 120, height: 30))
            }
            
            statusLabel.snp.makeConstraints{ make in
                make.top.equalTo(scoreLabel.snp.bottom).offset(5)
                make.right.equalTo(view).inset(10)
                make.size.equalTo(CGSize(width: 120, height: 30))
            }
            
            buttonStackView.snp.makeConstraints{ make in
                make.top.equalTo(view).offset(20)
                make.left.equalTo(view).inset(10)
                make.size.equalTo(CGSize(width: 100, height: 50))
            }
            
            nameLabel.snp.makeConstraints{ make in
                make.top.equalTo(profileImageView.snp.bottom).offset(5)
                 make.centerX.equalTo(view.snp.centerX)
                make.size.equalTo(CGSize(width: 300, height: 50))
            }
            
            companyLabel.snp.makeConstraints{ make in
                make.top.equalTo(nameLabel.snp.bottom).offset(5)
                make.centerX.equalTo(view.snp.centerX)
                make.size.equalTo(CGSize(width: 300, height: 30))
            }
            
            topStackView.snp.makeConstraints{ make in
                make.top.equalTo(companyLabel.snp.bottom).offset(5)
                make.left.right.equalTo(view)
                make.height.equalTo(50)
            }
            
            
            tableView.snp.makeConstraints { make in
                make.top.equalTo(topStackView.snp.bottom).offset(10)
                make.left.right.equalTo(view)
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
    
    
    @objc func filterPressed(sender:UIButton) {
        
        switch sender {
            
        case  logButton :
            
                    logButton.isSelected = true
                    todoButton.isSelected = false
                    socialButton.isSelected = false
                    filesButton.isSelected = false
                    infoButton.isSelected = false
                    selectedTab = "log"
                    logButton.backgroundColor = .white
                    todoButton.backgroundColor = CommonColor.naviBarBlackColor
                    socialButton.backgroundColor = CommonColor.naviBarBlackColor
                    filesButton.backgroundColor = CommonColor.naviBarBlackColor
                    infoButton.backgroundColor = CommonColor.naviBarBlackColor
            //viewModel.filterContact(isPotential: false, isCustomer: false, isDisqualified: false)
            
                   
                    
            break
        case todoButton:
                    logButton.isSelected = false
                    todoButton.isSelected = true
                    socialButton.isSelected = false
                    filesButton.isSelected = false
                    infoButton.isSelected = false
                    selectedTab = "todo"
                    logButton.backgroundColor = CommonColor.naviBarBlackColor
                    todoButton.backgroundColor = .white
                    socialButton.backgroundColor = CommonColor.naviBarBlackColor
                    filesButton.backgroundColor = CommonColor.naviBarBlackColor
                    infoButton.backgroundColor = CommonColor.naviBarBlackColor
            break
            
        case socialButton :
                    logButton.isSelected = false
                    todoButton.isSelected = false
                    socialButton.isSelected = true
                    filesButton.isSelected = false
                    infoButton.isSelected = false
                    selectedTab = "social"
                    logButton.backgroundColor = CommonColor.naviBarBlackColor
                    todoButton.backgroundColor = CommonColor.naviBarBlackColor
                    socialButton.backgroundColor = .white
                    filesButton.backgroundColor = CommonColor.naviBarBlackColor
                    infoButton.backgroundColor = CommonColor.naviBarBlackColor
            break
            
        case filesButton :
                    logButton.isSelected = false
                    todoButton.isSelected = false
                    socialButton.isSelected = false
                    filesButton.isSelected = true
                    infoButton.isSelected = false
                    selectedTab = "files"
                    logButton.backgroundColor = CommonColor.naviBarBlackColor
                    todoButton.backgroundColor = CommonColor.naviBarBlackColor
                    socialButton.backgroundColor = CommonColor.naviBarBlackColor
                    filesButton.backgroundColor = .white
                    infoButton.backgroundColor = CommonColor.naviBarBlackColor
                    
            break
            
        case infoButton :
                    logButton.isSelected = false
                    todoButton.isSelected = false
                    socialButton.isSelected = false
                    filesButton.isSelected = false
                    infoButton.isSelected = true
                    selectedTab = "info"
                    logButton.backgroundColor = CommonColor.naviBarBlackColor
                    todoButton.backgroundColor = CommonColor.naviBarBlackColor
                    socialButton.backgroundColor = CommonColor.naviBarBlackColor
                    filesButton.backgroundColor = CommonColor.naviBarBlackColor
                    infoButton.backgroundColor = .white
            
            
        default :
                    logButton.isSelected = true
                    todoButton.isSelected = false
                    socialButton.isSelected = false
                    filesButton.isSelected = false
                    infoButton.isSelected = false
                    selectedTab = "log"
                    logButton.backgroundColor = .white
                    todoButton.backgroundColor = CommonColor.naviBarBlackColor
                    socialButton.backgroundColor = CommonColor.naviBarBlackColor
                    filesButton.backgroundColor = CommonColor.naviBarBlackColor
                    infoButton.backgroundColor = CommonColor.naviBarBlackColor
        }
        
        tableView.reloadData()
    }
    
    
    @objc func actionCall() {
        
        //trigger button call
        let contactNum = viewModel.addContactModel?.addContact_phoneNum
        
        print(contactNum!)
        let url:URL = URL(string: "tel://\(contactNum!)")!
        UIApplication.shared.open(url, options: [:], completionHandler: { val in
            
        })
    }
    
    @objc func actionSMS() {
        
        //trigger button sms
        let contactNum = viewModel.addContactModel?.addContact_phoneNum
        let contactName = viewModel.addContactModel?.addContact_contactName
        
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
        
        if MFMailComposeViewController.canSendMail() {
            
            
            let emailTitle = "Hello"
            let messageBody = "Hello \(customerName),"
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
}



extension ContactDetailsViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = viewModel.detailRows[indexPath.row]
        
        //add rows details here
        
        if indexPath.row == 1{
            //self.showDateTimePicker()
            
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
       
        
        //selection of tabs
        //add plus button to add check list
        //add check box at the accessory if task are finish it can be checked
        
        
        switch selectedTab {
            
            
            
        case "log":
            let cell = tableView.dequeueReusableCell(withIdentifier: "contactDetailCell", for: indexPath) as! ContactDetailTableViewCell
            let data = viewModel.detailRows[indexPath.row]
            //cell.leftIcon = data.icon
            cell.leftIcon = "message-icon"
            self.populateData(cell: cell, index: indexPath, data:data)
            
            cell.selectionStyle = .none
            
           //populate logs here using the customer logs info from database
            
            cell.labelTitle.text = "Call log \(indexPath.row)"
            
            return cell
           
            
        case "todo":
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "contactDetailCell", for: indexPath) as! ContactDetailTableViewCell
            let data = viewModel.detailRows[indexPath.row]
            //cell.leftIcon = data.icon
            cell.leftIcon = "meeting-icon"
            self.populateData(cell: cell, index: indexPath, data:data)
            
            cell.selectionStyle = .none
            
            if indexPath.row == 0 {
                cell.labelTitle.isEnabled = true
                cell.nextIcon.isHidden = true
//                cell.textFieldsCallback = { val in
//                    self.viewModel.addContactModel?.addContact_contactName = val
//                }
                
                cell.labelTitle.text = "Introduce you self"
                
            } else if indexPath.row == 1 {
                cell.labelTitle.isEnabled = true
                cell.nextIcon.isHidden = true
//                cell.textFieldsCallback = { val in
//                    self.viewModel.addContactModel?.addContact_address = val
//                }
                
                 cell.labelTitle.text = "Present the Company"
            } else if indexPath.row == 2 {
                cell.labelTitle.isEnabled = true
                cell.nextIcon.isHidden = true
//                cell.textFieldsCallback = { val in
//                    self.viewModel.addContactModel?.addContact_phoneNum = val
//                }
                 cell.labelTitle.text = "Share Success Stories"
            } else if indexPath.row == 3 {
                cell.labelTitle.isEnabled = true
                cell.nextIcon.isHidden = true
//                cell.textFieldsCallback = { val in
//                    self.viewModel.addContactModel?.addContact_email = val
//                }
                 cell.labelTitle.text = "Ask if intereseted or not"
            }
            
            
            return cell
            
        case "social":
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "contactDetailCell", for: indexPath) as! ContactDetailTableViewCell
            let data = viewModel.detailRows[indexPath.row]
            //cell.leftIcon = data.icon
            cell.leftIcon = "message-template-icon"
            self.populateData(cell: cell, index: indexPath, data:data)
            
            cell.selectionStyle = .none
            
            if indexPath.row == 0 {
                cell.labelTitle.isEnabled = true
                cell.nextIcon.isHidden = true
//                cell.textFieldsCallback = { val in
//                    self.viewModel.addContactModel?.addContact_contactName = val
//                }
                
                cell.labelTitle.text = "Facebook: "
            } else if indexPath.row == 1 {
                cell.labelTitle.isEnabled = true
                cell.nextIcon.isHidden = true
//                cell.textFieldsCallback = { val in
//                    self.viewModel.addContactModel?.addContact_address = val
//                }
                
                cell.labelTitle.text = "Whatsapp: "
            } else if indexPath.row == 2 {
                cell.labelTitle.isEnabled = true
                cell.nextIcon.isHidden = true
//                cell.textFieldsCallback = { val in
//                    self.viewModel.addContactModel?.addContact_phoneNum = val
//                }
                
                cell.labelTitle.text = "Twitter: "
            } else if indexPath.row == 3 {
                cell.labelTitle.isEnabled = true
                cell.nextIcon.isHidden = true
//                cell.textFieldsCallback = { val in
//                    self.viewModel.addContactModel?.addContact_email = val
//                }
                
                cell.labelTitle.text = "Linkedin: "
            }
            
            
            return cell
        
        case "files":
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "contactDetailCell", for: indexPath) as! ContactDetailTableViewCell
            let data = viewModel.detailRows[indexPath.row]
            //cell.leftIcon = data.icon
            cell.leftIcon = "archive-icon"
            self.populateData(cell: cell, index: indexPath, data:data)
            
            cell.selectionStyle = .none
            
            cell.labelTitle.text = "File \(indexPath.row)"
            
            
            return cell
            
            
        case "info":
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
            
        default:
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
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if selectedTab == "log"{
            return viewModel.logDetails.count
        }
        else if selectedTab == "todo" {
        return 4
        } else if selectedTab == "social" {
            return 4
        } else if selectedTab == "files" {
            return 4
        } else {
        
        return viewModel.detailRows.count
        }
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

extension ContactDetailsViewController : MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate{
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true)
    }
    
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    
}
