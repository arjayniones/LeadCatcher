//
//  AboutViewController.swift
//  PlannerApp
//
//  Created by Lim Ai Zhi on 27/12/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import Foundation
import UIKit
import SwiftyUserDefaults
import Contacts
import Kingfisher
import MessageUI

class AboutViewController: ViewControllerProtocol,NativeNavbar {
    let data = AboutViewModel()
    let companyLogo:UIImageView = {
        let imV = UIImageView()
        imV.image = UIImage(named: "SI-Logo")
        imV.contentMode = .scaleToFill
        imV.layer.masksToBounds  = true
        return imV;
    }()
    
    let labelCompanyName:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = CommonColor.darkGrayColor
        label.font = UIFont.ofSize(fontSize: 16, withType: .bold)
        return label
    }()
    
    let labelCompanyAddr:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.textColor = CommonColor.darkGrayColor
        //label.font = UIFont.ofSize(fontSize: 18, withType: .bold)
        return label
    }()
    
    let labelCompanyWebsite:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = CommonColor.darkGrayColor
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    let labelCompanyEmail:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = CommonColor.darkGrayColor
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    let bgView:UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    
    let stackView:UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        //stackView.setContentCompressionResistancePriority(UILayoutPriority.required, for: .vertical)
        return stackView
    }()
    
    override func viewDidLoad() {
        self.title = "About"
        
        self.view.addSubview(bgView)
        bgView.addSubview(companyLogo)
        
        labelWithDiffFont()
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openSafari))
        labelCompanyWebsite.isUserInteractionEnabled = true
        tapGesture.numberOfTapsRequired = 1
        labelCompanyWebsite.addGestureRecognizer(tapGesture)
        
        let tapGesture2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openMailApp))
        labelCompanyEmail.isUserInteractionEnabled = true
        tapGesture2.numberOfTapsRequired = 1
        labelCompanyEmail.addGestureRecognizer(tapGesture2)
        
        labelCompanyName.text = data.companyName
        labelCompanyAddr.text = data.companyAddr
        
        stackView.addArrangedSubview(labelCompanyName)
        stackView.addArrangedSubview(labelCompanyAddr)
        stackView.addArrangedSubview(labelCompanyWebsite)
        stackView.addArrangedSubview(labelCompanyEmail)
        bgView.addSubview(stackView)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dismissView))
        
        view.setNeedsUpdateConstraints();
    }
    
    @objc func dismissView()
    {
        navigationController?.popViewController(animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateNavbarAppear()
    }
    
    func labelWithDiffFont()
    {
        let attrs1 = [NSAttributedString.Key.font : UIFont.italicSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor : CommonColor.darkGrayColor]
        let attrs2 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor : CommonColor.systemBlueColor]
        let attributedString1 = NSMutableAttributedString(string:"Visit us at \n", attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string:data.companyWebsite, attributes:attrs2)
        
        attributedString1.append(attributedString2)
        self.labelCompanyWebsite.attributedText = attributedString1
        
        let attrs3 = [NSAttributedString.Key.font : UIFont.italicSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor : CommonColor.darkGrayColor]
        let attrs4 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor : CommonColor.systemBlueColor]
        let attributedString3 = NSMutableAttributedString(string:"Have enquiry? just email us at \n", attributes:attrs3)
        let attributedString4 = NSMutableAttributedString(string:data.companyEmail, attributes:attrs4)
        
        attributedString3.append(attributedString4)
        self.labelCompanyEmail.attributedText = attributedString3
        
    }
    
    @objc func openSafari()
    {
        if let url = URL(string: "http://www.sicmsb.com") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @objc func openMailApp()
    {
        if MFMailComposeViewController.canSendMail() {
            
            let emailTitle = ""
            let messageBody = ""
            let toRecipents = "enquiry@sicmsb.com"
            let mc: MFMailComposeViewController = MFMailComposeViewController()
            mc.mailComposeDelegate = self
            mc.setSubject(emailTitle)
            mc.setMessageBody(messageBody, isHTML: false)
            mc.setToRecipients([toRecipents])
            
            UIApplication.shared.keyWindow?.rootViewController?.present(mc, animated: true, completion: nil)
        } else {
            // show failure alert
            print("Can't send messages.")
        }
    }
    
    override func updateViewConstraints() {
        if !didSetupConstraints
        {
            
            bgView.snp.makeConstraints { (make) in
                make.top.equalTo(self.view).inset(65)
                make.left.right.bottom.equalTo(self.view).inset(0)
            }
            
            companyLogo.snp.makeConstraints { (make) in
                make.top.equalTo(bgView).inset(40)
                make.height.equalTo(180)
                make.width.equalTo(180)
                make.centerX.equalTo(bgView.snp.centerX)
            }
            
            stackView.snp.makeConstraints { (make) in
                make.top.equalTo(companyLogo.snp.bottom).offset(20)
                make.left.right.equalTo(bgView).inset(20)
                //make.bottom.equalTo(bgView).inset(0)
            }
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
}

extension NSMutableAttributedString{
    func setColorForText(textAttribute:String, color:UIColor)
    {
        let range:NSRange = self.mutableString.range(of: textAttribute, options:.caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        
    }
    
    func setFontForString(textAttribute:String)
    {
        let range:NSRange = self.mutableString.range(of: textAttribute, options:.caseInsensitive)
        self.addAttribute(NSAttributedString.Key.font, value: UIFont.italicSystemFont(ofSize: 13), range: range)
        
    }
}

extension AboutViewController:MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate
{
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result {
        case .sent:
            break;
        default:
            print("Send SMS fail");
        }
        controller.dismiss(animated: true)
    }
    
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .sent:
            break;
        default:
            print("Send Email fail");
        }
        controller.dismiss(animated: true)
    }
}
