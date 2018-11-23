//
//  ChangePasscodeViewController.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 07/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import LocalAuthentication
import SwiftyUserDefaults

class ChangePasscodeViewController: ViewControllerProtocol,LargeNativeNavbar {

    let newPassCodeField = UITextField()
    let confirmPassCodeField = UITextField()
    
    let updateButton = UIButton()
    
    let bottomBorderOldPass = UIView();
    let bottomBorderNewPass = UIView();
    
    var passcodeModel = ChangePasscodeViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

         title = "Change Passcode"
        newPassCodeField.placeholder = "New Passcode";
        newPassCodeField.font = UIFont(name: "SFTextPro-Regular", size: 17)
        newPassCodeField.textAlignment = NSTextAlignment.left
        newPassCodeField.isSecureTextEntry = true
        newPassCodeField.keyboardType = UIKeyboardType.numberPad;
        
        view.addSubview(newPassCodeField)
        
        confirmPassCodeField.placeholder = "Confirm Passcode";
        confirmPassCodeField.font = UIFont(name: "SFTextPro-Regular", size: 17)
        confirmPassCodeField.textAlignment = NSTextAlignment.left
        confirmPassCodeField.isSecureTextEntry = true
        confirmPassCodeField.keyboardType = UIKeyboardType.numberPad;
       
        view.addSubview(confirmPassCodeField)
        
        updateButton.setTitle("Update", for: .normal)
        updateButton.titleLabel?.font = UIFont(name: "SFProText-Bold", size: 17)
        updateButton.setTitleColor(.white, for: .normal)
        updateButton.layer.borderWidth   =    1
        updateButton.backgroundColor = CommonColor.buttonBlackColor;
        updateButton.addTarget(self, action: #selector(updateButtonTouched), for: .touchUpInside)
        view.addSubview(updateButton)
        
        bottomBorderOldPass.backgroundColor = UIColor.lightGray;
        bottomBorderNewPass.backgroundColor = UIColor.lightGray;
        newPassCodeField.addSubview(bottomBorderOldPass);
        confirmPassCodeField.addSubview(bottomBorderNewPass);
        
        view.setNeedsUpdateConstraints()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateNavbarAppear()
        newPassCodeField.text = ""
        confirmPassCodeField.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func updateButtonTouched() {
        //self.present(BaseViewController(), animated: true, completion: nil)
        
        //change passcode to new and go back/dismiss
        guard let newPass = newPassCodeField.text else {
            //put validation
            
            return
        }
        
        if newPass == confirmPassCodeField.text {
            //show pop up changed successfully
            if passcodeModel.changePasscode(passcode: newPass) {
                self.popUpSuccess(title: "Changed Successfully", message: "The passcode has updated successfully")
            }
            
        }
        else{
            //message not matched pop up here
            popUpNotMatched(title: "Not Matched", message: "The passcode you enter did not match. Please try again.")
        }
    }
    
    
    override func updateViewConstraints() {
        
        if !didSetupConstraints {
            newPassCodeField.snp.makeConstraints { make in
                
                make.top.equalTo(view).inset(150)
                make.left.right.equalTo(view).inset(10)
                make.height.equalTo(40)
            }
            
            bottomBorderOldPass.snp.makeConstraints{
                make in
                make.top.equalTo(newPassCodeField.snp.bottom);
                make.height.equalTo(1);
                make.left.right.equalTo(newPassCodeField).inset(0)
            }
            
            confirmPassCodeField.snp.makeConstraints { make in
                
                make.top.equalTo(newPassCodeField.snp.bottom).offset(30)
                make.left.right.equalTo(view).inset(10)
                make.height.equalTo(40)
            }
            
            bottomBorderNewPass.snp.makeConstraints{
                make in
                make.top.equalTo(confirmPassCodeField.snp.bottom);
                make.height.equalTo(1);
                make.left.right.equalTo(confirmPassCodeField).inset(0)
            }
            
            updateButton.snp.makeConstraints { make in
                
                make.top.equalTo(confirmPassCodeField.snp.bottom).offset(30)
                make.width.equalTo(view.snp.width).multipliedBy(0.3)
                make.height.equalTo(40)
                make.centerX.equalTo(confirmPassCodeField.snp.centerX)
            }
           
            
            didSetupConstraints = true
            
           
        }
        
        super.updateViewConstraints()
    }
    
    func popUpSuccess(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: { val in
            SessionService.logout()
        }))
        self.present(alert, animated: true, completion: nil)
        
 
        
    }
    
    func popUpNotMatched(title: String, message: String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
        
        //self.newPassCodeField.text = ""
        self.confirmPassCodeField.text = ""
        self.present(alertController, animated: true, completion: nil)
    }
    

}

class ChangePasscodeViewModel {
    
    fileprivate let realmStore = RealmStore<UserModel>()
    
    func changePasscode(passcode:String) -> Bool {
        
        if let userModel = realmStore.models(query: "id = '\(Defaults[.SessionUserId]!)'")?.first {
            userModel.U_Password = passcode
            return true
        }
        return false
        
    }
}


