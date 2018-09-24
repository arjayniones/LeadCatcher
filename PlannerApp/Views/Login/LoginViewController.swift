//
//  LoginViewController.swift
//  PlannerApp
//
//  Created by Lim Ai Zhi on 06/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import RealmSwift
import LocalAuthentication

class LoginViewController: ViewControllerProtocol {

    let loginUsernameField = UITextField()
    let passwordField = UITextField()
    
    let loginButton = UIButton()
    let signUpButton = UIButton()
    
    let labelBottomRight = UILabel();
    let labelBottomLeft = UILabel();
    let viewTest = UIView();
    let bottomBorderLoginID = UIView();
    let bottomBorderPassword = UIView();
    let hideSignUpBtn:Bool = false;
    
    var resultUserList:Results<UserModel>!;
    let localAuthenticationContext = LAContext();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        edgesForExtendedLayout=[];
        self.hideKeyboardWhenTappedAround();
        view.backgroundColor = .white
        
        loginUsernameField.placeholder = "Login ID";
        loginUsernameField.font = UIFont.ofSize(fontSize: 17, withType: .regular);
        loginUsernameField.autocorrectionType = UITextAutocorrectionType.no;
        loginUsernameField.textAlignment = NSTextAlignment.left;
        loginUsernameField.tag = 0;
        view.addSubview(loginUsernameField)
        
        passwordField.placeholder = "Passcode";
        passwordField.font = UIFont.ofSize(fontSize: 17, withType: .bold);
        passwordField.textAlignment = NSTextAlignment.left
        passwordField.isSecureTextEntry = true;
        passwordField.tag = 1;
        passwordField.keyboardType = UIKeyboardType.numberPad;
        view.addSubview(passwordField)
        
        loginButton.setTitle("Login", for: .normal)
        loginButton.titleLabel?.font = UIFont.ofSize(fontSize: 17, withType: .bold);
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.borderWidth   =    1
        loginButton.backgroundColor = CommonColor.buttonBlackColor;
        loginButton.addTarget(self, action: #selector(loginButtonTouched), for: .touchUpInside)
        view.addSubview(loginButton)
        
        bottomBorderLoginID.backgroundColor = UIColor.lightGray;
        bottomBorderPassword.backgroundColor = UIColor.lightGray;
        
        loginUsernameField.addSubview(bottomBorderLoginID);
        passwordField.addSubview(bottomBorderPassword);
        
        signUpButton.setTitle("Sign Up", for: .normal);
        signUpButton.setTitleColor(.white, for: .normal);
        signUpButton.titleLabel?.font = UIFont.ofSize(fontSize: 17, withType: .bold);
        signUpButton.backgroundColor = CommonColor.buttonBlackColor;
        signUpButton.addTarget(self, action: #selector(signUpButtonTap(_:)), for: .touchUpInside);
        view.addSubview(signUpButton);
        
        view.setNeedsUpdateConstraints();
        self.queryUserTable(checkType: "ViewLoad");
        
    }
    
    @objc func loginButtonTouched() {
        
        //Defaults[.isLoggedIn] = false
        
        if resultUserList.count == 0
        {
            let controller = UIAlertController.alertControllerWithTitle(title: "Warning", message: "No user found. Please proceed to sign up");
            present(controller, animated: true, completion: nil);
        }
        
        // return alert msg if textfield is empty
        // return "" if textfield is filled
        let loginTextCheck = UserViewModel.textFieldIsEmpty(text: self.loginUsernameField.text!, textTag: self.loginUsernameField.tag);
        let passcodeTextCheck = UserViewModel.textFieldIsEmpty(text: self.passwordField.text!, textTag: self.passwordField.tag);
        
        if loginTextCheck == "" && passcodeTextCheck == ""
        {
            // loginTextCheck and passCodeTextCheck = "" mean both textfield is not empty
            // if one of them is != "" then mean one of the textfield is empty.
            self.queryUserTable(checkType: "LoginClick");
        }
        else
        {
            var msg = "";
            if loginTextCheck.count > 0
            {
                msg = loginTextCheck;
            }
            else
            {
                msg = passcodeTextCheck;
            }
            
            let controller = UIAlertController.alertControllerWithTitle(title: "Warning", message: msg);
            present(controller, animated: true, completion: nil);
        }
 
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        let navHeight = navigationController?.navigationBar.height
//
//        loginUsernameField.anchorToEdge(.top, padding: navHeight! + 60, width: view.width-40, height: 40)
//
//    }
//
    override func updateViewConstraints() {
        
        if !didSetupConstraints {
            loginUsernameField.snp.makeConstraints { make in
                
                make.top.equalTo(view).inset(150)
                make.left.right.equalTo(view).inset(10)
                make.height.equalTo(40)
            }
            
            bottomBorderLoginID.snp.makeConstraints{
                make in
                make.top.equalTo(loginUsernameField.snp.bottom);
                make.height.equalTo(1);
                make.left.right.equalTo(loginUsernameField).inset(0)
            }
            
            passwordField.snp.makeConstraints { make in
                
                make.top.equalTo(loginUsernameField.snp.bottom).offset(30)
                make.left.right.equalTo(view).inset(10)
                make.height.equalTo(40)
            }
            
            bottomBorderPassword.snp.makeConstraints{
                make in
                make.top.equalTo(passwordField.snp.bottom);
                make.height.equalTo(1);
                make.left.right.equalTo(passwordField).inset(0)
            }
            
            loginButton.snp.makeConstraints { make in
                
                make.top.equalTo(passwordField.snp.bottom).offset(30)
                make.width.equalTo(view.snp.width).multipliedBy(0.3)
                make.height.equalTo(40)
                make.centerX.equalTo(passwordField.snp.centerX)
            }
            
            signUpButton.snp.makeConstraints{
                make in
                make.top.equalTo(loginButton.snp.bottom).offset(30);
                make.width.equalTo(view.snp.width).multipliedBy(0.3);
                make.height.equalTo(40);
                make.centerX.equalTo(passwordField.snp.centerX);
            }
            
            didSetupConstraints = true
        }
        
        
        super.updateViewConstraints()
    }
    
    @objc func signUpButtonTap(_ sender : UIButton)
    {
        let vc = RegisterViewController();
        self.present(vc, animated: true, completion: nil);
        //self.queryUserTable(checkType: "LoginClick");
    }
    
    // MARK: - Query Realm
    func queryUserTable(checkType:String)
    {
        // checkType is used for diff viewload or user click login button
        // if viewdidload then checktype will be "ViewLoad"
        // if click login button then checktype will be "LoginClick"
        resultUserList = UserViewModel.queryUserTable(checkType: checkType, loginID: self.loginUsernameField.text!, passcode: self.passwordField.text!);
        print(resultUserList)
        
        if resultUserList.count > 0
        {
            self.loginButton.isEnabled = true;
            self.signUpButton.isHidden = true;
            
            if resultUserList[0].U_EnableTouchID == true && checkType == "ViewLoad"
            {
                // call out touch id verification
                authenticationWithTouchID(id: "", completion: {
                    result in
                    if result == "Success"
                    {
                        DispatchQueue.main.async {
                            self.dismiss(animated: false, completion: nil)
                        }
//                        self.present(BaseViewController(), animated: true, completion: nil);
                        
//                        self.dismiss(animated: true, completion: nil)
                    }
                    
                })
            }
            
            if checkType == "LoginClick"
            {
                Defaults[.SessionUserId] = resultUserList[0].id;
//                self.present(BaseViewController(), animated: true, completion: nil);
                self.dismiss(animated: true, completion: nil)
            }
            else
            {
                // do nothing
            }
            
        }
        else
        {
            if checkType == "ViewLoad"
            {
                self.signUpButton.isHidden = false;
            }
            else
            {
                // do nothing
                let controller = UIAlertController.alertControllerWithTitle(title: "Warning", message: "Invalid username or password");
                present(controller, animated: false, completion: nil);
            }
            
        }
        
    }

}





