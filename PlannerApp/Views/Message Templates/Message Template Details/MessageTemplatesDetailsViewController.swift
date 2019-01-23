//
//  MessageTemplatesDetailsViewController.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 04/10/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import MessageUI

class MessageTemplatesDetailsViewController: ViewControllerProtocol, NativeNavbar {

    fileprivate let viewModel: MessageTemplateDetailsViewModel
    var isControllerEditing:Bool = false
    var isCellEditing:Bool = false;
    var msgUDID:String = "";
    private let realmStore = RealmStore<MessageTemplatesModel>()
    
    
    var setupModel: AddMessageTemplateModel? {
        didSet {
            viewModel.addMessageTemplateModel = setupModel
        }
    }
    
    required init() {
        viewModel = MessageTemplateDetailsViewModel()
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let mainView: UIView = {
        let view = UIView()
        view.frame = UIApplication.shared.keyWindow!.frame
        UIApplication.shared.keyWindow!.addSubview(view)
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 0.2
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.5
       // view.layer.shadowColor = UIColor.black as! CGColor
        return view
    }()
    
    let titleLabel : UILabel = {
        let titleLbl = UILabel()
        titleLbl.text = "Title:"
        titleLbl.textColor = .black
        return titleLbl
    }()
    
    let titleTextView : UITextField = {
        let titleTxt = UITextField()
        titleTxt.placeholder = "Enter message title"
        titleTxt.font = UIFont.ofSize(fontSize: 20, withType: .regular)
        
        return titleTxt
    }()
    
    let instructionLabel : UILabel = {
        let instructLbl = UILabel()
        instructLbl.text = "Copy this message or tap send button. "
        instructLbl.textColor = .darkGray
        instructLbl.font = UIFont.ofSize(fontSize: 12, withType: .regular)
        
        return instructLbl
    }()
    
    let copyButton: UIButton = {
        let copyBtn = UIButton()
        copyBtn.setTitle("Send", for: UIControl.State.normal)
        copyBtn.titleLabel?.textColor = .white
        copyBtn.tintColor = .white
        copyBtn.backgroundColor = .black
        copyBtn.layer.cornerRadius = 5
        copyBtn.addTarget(self, action: #selector(pressButton(_:)), for: .touchUpInside)
        
        return copyBtn
    }()
    
    let bodyLabel : UILabel = {
        let bodyLbl = UILabel()
        bodyLbl.text = "Message:"
        bodyLbl.textColor = .black
        
        return bodyLbl
    }()
    
    let messageTextField : UITextView = {
        let nametxt = UITextView()
        nametxt.text = "Happy Birthday! \nEvery day is an opportunity for a fresh new start. \nMake this one counted. Take care!\n\nI send this birthday wishes earlier before you inbox get crowded,\nFirst of all, I would like to say thank you and good luck to the new chapter of your life.\n\nHappy birthday my friend!"
        nametxt.font = UIFont.ofSize(fontSize: 20, withType: .regular)
        nametxt.textColor = .black
        nametxt.backgroundColor = .lightGray
        return nametxt
    }()
    
    
    @objc func changeRightNavigatorButtonName()
    {
        //updateTextFieldStatus();
        updateTextFieldStatus(status: "Save")
        isCellEditing = true;
        let saveButton = UIButton()
        
        saveButton.setTitle("save".localized, for: .normal)
        saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        saveButton.setTitleColor(CommonColor.systemBlueColor, for: .normal);
        //saveButton.setTitleColor(UIColor.init(red: 0, green: 122, blue: 255), for: .normal);
        
        saveButton.titleLabel?.font = UIFont.ofSize(fontSize: 17, withType: .regular)
        
        saveButton.sizeToFit()
        saveButton.frame = CGRect(x: 0, y: -2, width: saveButton.frame.width, height: saveButton.frame.height)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        
    }
    
    @objc func save(){
        
        
        self.viewModel.addMessageTemplateModel?.addMsgTemp_title = self.titleTextView.text!
        self.viewModel.addMessageTemplateModel?.addMsgTemp_body = self.messageTextField.text!
        
        if !isControllerEditing
        {
            saveData();
        }
        else
        {
            self.viewModel.updateData(id: msgUDID, title: self.titleTextView.text!, body: self.messageTextField.text!)
            self.navigationController?.popViewController(animated: true)
        }
        
        
    }
    
    func saveData()
    {
        self.viewModel.savePanel(completion: { val in
            if val {
                let alert = UIAlertController(title: "Success,New Template has been saved.", message: "Info", preferredStyle: .alert)
                //alert.addAction(UIAlertAction(title: "No", style:.cancel, handler: nil));
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    self.viewModel.addMessageTemplateModel = AddMessageTemplateModel()
                    self.navigationController?.popViewController(animated: true)
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
            self.viewModel.addMessageTemplateModel = AddMessageTemplateModel()
            ///self.tableView.reloadData()
        }))
        
        self.present(controller, animated: true, completion: nil);
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //updateNavbarAppear()
        updateBlackNavBarAppear()
    }
    
    @objc func loadMessages(){
        self.titleTextView.text = self.viewModel.addMessageTemplateModel?.addMsgTemp_title
        
        self.messageTextField.text = self.viewModel.addMessageTemplateModel?.addMsgTemp_body
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Msg Templates"
        view.backgroundColor = .clear
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dismissView))
        view.addSubview(mainView)
        mainView.addSubview(titleLabel)
        mainView.addSubview(titleTextView)
        mainView.addSubview(bodyLabel)
        mainView.addSubview(messageTextField)
        mainView.addSubview(instructionLabel)
        mainView.addSubview(copyButton)
      
        let saveButton = UIButton()
        if isControllerEditing
        {
            updateTextFieldStatus(status: "Edit")
            isCellEditing = false;
            saveButton.setTitleColor(CommonColor.systemBlueColor, for: .normal);
            saveButton.setTitle("Edit", for: .normal)
            saveButton.titleLabel?.font = UIFont.ofSize(fontSize: 17, withType: .regular)
            saveButton.addTarget(self, action: #selector(changeRightNavigatorButtonName), for: .touchUpInside)
            //navigationItem.rightBarButtonItem = self.editButtonItem;
        }
        else
        {
            updateTextFieldStatus(status: "Save")
            isCellEditing = true;
            saveButton.setTitleColor(CommonColor.systemBlueColor, for: .normal);
            saveButton.setTitle("Save", for: .normal)
            saveButton.titleLabel?.font = UIFont.ofSize(fontSize: 17, withType: .regular)
            saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        }
        
        
        
        saveButton.sizeToFit()
        saveButton.frame = CGRect(x: 0, y: -2, width: saveButton.frame.width, height: saveButton.frame.height)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        
        
        
        self.loadMessages()
        
        view.setNeedsUpdateConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func dismissView()
    {
        navigationController?.popViewController(animated: false)
    }
    

    override func updateViewConstraints() {
        
        if !didSetupConstraints {
            
            mainView.snp.makeConstraints { make in
                make.top.equalTo(view.safeArea.top).inset(10)
                make.left.right.equalTo(view).inset(20)
                make.bottom.equalTo(view).inset(80)
            }
            titleLabel.snp.makeConstraints {  make in
                make.top.left.equalTo(mainView).offset(10)
                make.height.equalTo(50)
                make.width.equalTo(100)
                // make.bottom.equalTo(view).offset(20)
            }
            titleTextView.snp.makeConstraints {  make in
                make.top.right.equalTo(mainView).inset(10)
                make.left.equalTo(titleLabel.snp.right).offset(10)
                make.height.equalTo(50)
                // make.bottom.equalTo(view).offset(20)
            }
            
            bodyLabel.snp.makeConstraints {  make in
                make.top.equalTo(titleLabel.snp.bottom).offset(10)
                make.left.right.equalTo(mainView).offset(10)
                make.height.equalTo(50)
                make.width.equalTo(100)
                // make.bottom.equalTo(view).offset(20)
            }
            
            
            messageTextField.snp.makeConstraints {  make in
                make.top.equalTo(bodyLabel.snp.bottom).offset(10)
                make.left.right.equalTo(mainView).inset(10)
                make.height.equalTo(200)
                
            }
            
            instructionLabel.snp.makeConstraints { make in
                make.top.equalTo(messageTextField.snp.bottom).offset(5)
                make.left.equalTo(mainView).inset(10)
                make.width.equalTo(300)
                make.height.equalTo(30)
            }
            
            copyButton.snp.makeConstraints { make in
                make.top.equalTo(instructionLabel.snp.bottom).offset(5)
                make.right.equalTo(mainView).inset(10)
                make.width.equalTo(70)
                make.height.equalTo(40)
                
            }
          
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
    @objc func pressButton(_ sender: UIButton){ //<- needs `@objc`
        print("\(sender)")
        
        //UIPasteboard.general.string = self.messageTextField.text
        //copyButton.setTitle("Copied", for: .normal)
        
        let actionSheet = UIAlertController(title: "Choose options", message: "Send greetings to your lead.", preferredStyle: .actionSheet)
        
        
            let emailAction = UIAlertAction(title: "Email", style: .default) { (action:UIAlertAction) in
                self.sendEmail()
                //UIApplication.shared.open(URL(string: "mailto:")!, options: [:], completionHandler: nil)
            }
            let smsAction = UIAlertAction(title: "SMS", style: .default) { (action:UIAlertAction) in
            //UIApplication.shared.open(URL(string: "sms:")!, options: [:], completionHandler: nil)
                self.sendSMS()
            }
        let whatsappAction = UIAlertAction(title: "Whatsapp", style: .default) { (action:UIAlertAction) in
                self.sendWhatsapp()
        }
            actionSheet.addAction(emailAction)
            actionSheet.addAction(smsAction)
            actionSheet.addAction(whatsappAction)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    
    @objc func sendEmail() {
        if MFMailComposeViewController.canSendMail() {


            let emailTitle = titleLabel.text
            let messageBody = messageTextField.text
            //let toRecipents = ["arjayniones@gmail.com"]
            let mc: MFMailComposeViewController = MFMailComposeViewController()
            mc.mailComposeDelegate = self
            mc.setSubject(emailTitle!)
            mc.setMessageBody(messageBody!, isHTML: false)
            //mc.setToRecipients(toRecipents)

            UIApplication.shared.keyWindow?.rootViewController?.present(mc, animated: true, completion: nil)
        } else {
            // show failure alert
             print("Can't send messages.")
        }

    }
    
    @objc func sendSMS(){
        
        
         let mc: MFMessageComposeViewController = MFMessageComposeViewController()
        //let composeVC = MFMessageComposeViewController()
        mc.messageComposeDelegate = self
        
        // Configure the fields of the interface.
        //mc.recipients = ["+60164925940"]
        mc.body = self.messageTextField.text
        
        if MFMessageComposeViewController.canSendText() {
//             UIApplication.shared.keyWindow?.rootViewController?.present(mc, animated: true, completion: nil)
            self.present(mc, animated: true, completion: nil)
        } else {
            print("Can't send messages.")
        }
    }
    
    @objc func sendWhatsapp(){
        let urlString = self.messageTextField.text
        let urlStringEncoded = urlString?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
//        let urlStringEncoded = urlString.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
//
        let url  = NSURL(string: "whatsapp://send?text=\(urlStringEncoded!)")
        
        if UIApplication.shared.canOpenURL(url! as URL) {
            //UIApplication.shared.openURL(url! as URL)
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
        } else {
            
            //let errorAlert = UIAlertView(title: "Cannot Send Message", message: "Your device is not able to send WhatsApp messages.", delegate: self, cancelButtonTitle: "OK")
            let errorAlert = UIAlertController(title: "Cannot Send Message", message: "Your device is not able to send WhatsApp messages.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            errorAlert.addAction(okAction)
            self.present(errorAlert, animated: false, completion: nil)
            //errorAlert.show()
        }
    }
    
    func updateTextFieldStatus(status:String)
    {
        if status == "Edit"
        {
            self.titleTextView.isEnabled = false;
            self.messageTextField.isEditable = false;
            self.titleTextView.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            self.messageTextField.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
        else
        {
            self.titleTextView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.messageTextField.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.titleTextView.isEnabled = true;
            self.messageTextField.isEditable = true;
        }
    }
    
}

extension MessageTemplatesDetailsViewController : MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate{
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true)
    }
    
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
   
}
