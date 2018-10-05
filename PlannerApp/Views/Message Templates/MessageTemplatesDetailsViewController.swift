//
//  MessageTemplatesDetailsViewController.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 04/10/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import MessageUI

class MessageTemplatesDetailsViewController: ViewControllerProtocol, LargeNativeNavbar {

    let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.5
        //view.layer.shadowColor = UIColor.black as! CGColor
        
        
        return view
    }()
    
    let titleLabel : UILabel = {
        let namLbl = UILabel()
        namLbl.text = "Birthday Greetings"
        namLbl.textColor = .black
        return namLbl
    }()
    
    let instructionLabel : UILabel = {
        let instructLbl = UILabel()
        instructLbl.text = "Copy this message to you Email or SMS. "
        instructLbl.textColor = .darkGray
        instructLbl.font = UIFont.ofSize(fontSize: 14, withType: .regular)
        
        return instructLbl
    }()
    
    let copyButton: UIButton = {
        let copyBtn = UIButton()
        copyBtn.setTitle("Send", for: UIControlState.normal)
        copyBtn.titleLabel?.textColor = .white
        copyBtn.tintColor = .white
        copyBtn.backgroundColor = .black
        copyBtn.layer.cornerRadius = 5
        copyBtn.addTarget(self, action: #selector(pressButton(_:)), for: .touchUpInside)
        
        return copyBtn
    }()
    
    let messageTextField : UITextView = {
        let nametxt = UITextView()
        nametxt.text = "Happy Birthday! \nEvery day is an opportunity for a fresh new start. \nMake this one counted. Take care!\n\nI send this birthday wishes earlier before you inbox get crowded,\nFirst of all, I would like to say thank you and good luck to the new chapter of your life.\n\nHappy birthday my friend!"
        nametxt.font = UIFont.ofSize(fontSize: 20, withType: .regular)
        return nametxt
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Message Templates"
        
        view.addSubview(mainView)
        mainView.addSubview(titleLabel)
        mainView.addSubview(messageTextField)
        mainView.addSubview(instructionLabel)
        mainView.addSubview(copyButton)
      
        
        view.setNeedsUpdateConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func updateViewConstraints() {
        
        if !didSetupConstraints {
            
            mainView.snp.makeConstraints { make in
                make.top.left.right.equalTo(view).inset(10)
                make.bottom.equalTo(view).inset(60)
            }
            titleLabel.snp.makeConstraints {  make in
                make.top.left.equalTo(mainView).offset(10)
                make.height.equalTo(50);
                // make.bottom.equalTo(view).offset(20)
            }
            messageTextField.snp.makeConstraints {  make in
                make.top.equalTo(titleLabel.snp.bottom).offset(5)
                make.left.right.equalTo(mainView).inset(10)
                make.height.equalTo(300);
                
            }
            
            instructionLabel.snp.makeConstraints { make in
                make.top.equalTo(messageTextField.snp.bottom).offset(5)
                make.left.equalTo(mainView).inset(10)
                make.width.equalTo(300)
                make.height.equalTo(30)
            }
            
            copyButton.snp.makeConstraints { make in
                make.top.equalTo(messageTextField.snp.bottom).offset(5)
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
                //self.sendEmail()
                UIApplication.shared.open(URL(string: "mailto:")!, options: [:], completionHandler: nil)
            }
            let smsAction = UIAlertAction(title: "SMS", style: .default) { (action:UIAlertAction) in
            UIApplication.shared.open(URL(string: "sms:")!, options: [:], completionHandler: nil)
            }
            actionSheet.addAction(emailAction)
            actionSheet.addAction(smsAction)
        
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    
    @objc func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
//            let mail = MFMailComposeViewController()
//            mail.mailComposeDelegate = self
//            //mail.setToRecipients(["ved.ios@yopmail.com"])
//            mail.setMessageBody(messageTextField.text, isHTML: true)
//
//            present(mail, animated: true)
            
            let emailTitle = titleLabel.text
            let messageBody = messageTextField.text
            let toRecipents = ["arjayniones@gmail.com"]
            let mc: MFMailComposeViewController = MFMailComposeViewController()
            mc.mailComposeDelegate = self
            mc.setSubject(emailTitle!)
            mc.setMessageBody(messageBody!, isHTML: false)
            mc.setToRecipients(toRecipents)
            
            self.present(mc, animated: true, completion: nil)
        } else {
            // show failure alert
        }
    }
}

extension MessageTemplatesDetailsViewController : MFMailComposeViewControllerDelegate{
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
   
}
