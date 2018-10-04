//
//  MessageTemplatesDetailsViewController.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 04/10/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit

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
    
    let messageTextField : UITextView = {
        let nametxt = UITextView()
        nametxt.text = "Happy Birthday! \nEvery day is an opportunity for a fresh new start. \nMake this one counted. Take care!\n\n I send this birthday wishes earlier before you inbox get crowded,\nFirst of all, I would like to say thank you and good luck to the new chapter of your life.\n\nHappy birthday my friend!"
        
        return nametxt
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Panel List Details"
        
        view.addSubview(mainView)
        mainView.addSubview(titleLabel)
        mainView.addSubview(messageTextField)
        
      
        
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
                make.top.left.equalTo(mainView).offset(5)
                make.height.equalTo(50);
                // make.bottom.equalTo(view).offset(20)
            }
            messageTextField.snp.makeConstraints {  make in
                make.top.equalTo(titleLabel.snp.bottom)
                make.left.right.equalTo(mainView).inset(10)
                make.height.equalTo(300);
                //make.bottom.equalTo(view).offset(20)
            }
          
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
}
