//
//  ChangePasscodeViewController.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 07/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import LocalAuthentication

class ChangePasscodeViewController: UIViewController {

    let oldPassCodeField = UITextField()
    let newPassCodeField = UITextField()
    
    let updateButton = UIButton()
    
    let bottomBorderOldPass = UIView();
    let bottomBorderNewPass = UIView();
    
    var didSetupConstraints = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        oldPassCodeField.placeholder = "Old Passcode";
        oldPassCodeField.font = UIFont(name: "SFTextPro-Regular", size: 17)
        oldPassCodeField.textAlignment = NSTextAlignment.left
        view.addSubview(oldPassCodeField)
        
        newPassCodeField.placeholder = "New Passcode";
        newPassCodeField.font = UIFont(name: "SFTextPro-Regular", size: 17)
        newPassCodeField.textAlignment = NSTextAlignment.left
        view.addSubview(newPassCodeField)
        
        updateButton.setTitle("Update", for: .normal)
        updateButton.titleLabel?.font = UIFont(name: "SFProText-Bold", size: 17)
        updateButton.setTitleColor(.white, for: .normal)
        updateButton.layer.borderWidth   =    1
        updateButton.backgroundColor = CommonColor.buttonBlackColor;
        updateButton.addTarget(self, action: #selector(updateButtonTouched), for: .touchUpInside)
        view.addSubview(updateButton)
        
        bottomBorderOldPass.backgroundColor = UIColor.lightGray;
        bottomBorderNewPass.backgroundColor = UIColor.lightGray;
        oldPassCodeField.addSubview(bottomBorderOldPass);
        newPassCodeField.addSubview(bottomBorderNewPass);
        
        view.setNeedsUpdateConstraints()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func updateButtonTouched() {
        self.present(BaseViewController(), animated: true, completion: nil)
        
        //change passcode to new and go back/dismiss
    }
    
    
    override func updateViewConstraints() {
        
        if !didSetupConstraints {
            oldPassCodeField.snp.makeConstraints { make in
                
                make.top.equalTo(view).inset(150)
                make.left.right.equalTo(view).inset(10)
                make.height.equalTo(40)
            }
            
            bottomBorderOldPass.snp.makeConstraints{
                make in
                make.top.equalTo(oldPassCodeField.snp.bottom);
                make.height.equalTo(1);
                make.left.right.equalTo(oldPassCodeField).inset(0)
            }
            
            newPassCodeField.snp.makeConstraints { make in
                
                make.top.equalTo(oldPassCodeField.snp.bottom).offset(30)
                make.left.right.equalTo(view).inset(10)
                make.height.equalTo(40)
            }
            
            bottomBorderNewPass.snp.makeConstraints{
                make in
                make.top.equalTo(newPassCodeField.snp.bottom);
                make.height.equalTo(1);
                make.left.right.equalTo(newPassCodeField).inset(0)
            }
            
            updateButton.snp.makeConstraints { make in
                
                make.top.equalTo(newPassCodeField.snp.bottom).offset(30)
                make.width.equalTo(view.snp.width).multipliedBy(0.3)
                make.height.equalTo(40)
                make.centerX.equalTo(newPassCodeField.snp.centerX)
            }
           
            
            didSetupConstraints = true
            
           
        }
        
        
        super.updateViewConstraints()
    }
    

}
