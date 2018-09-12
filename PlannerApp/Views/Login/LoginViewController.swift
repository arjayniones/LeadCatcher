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

class LoginViewController: UIViewController {

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
    
    var didSetupConstraints = false;
    var resultUserList:Results<UserModel>!;
    let localAuthenticationContext = LAContext();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        edgesForExtendedLayout=[];
        view.backgroundColor = .white
//        let realm = try! Realm()
//        print(realm.configuration.fileURL!);
        
        loginUsernameField.placeholder = "Login ID";
        loginUsernameField.font = CommonFontType.sfProTextRegular;
        loginUsernameField.autocorrectionType = UITextAutocorrectionType.no;
        loginUsernameField.textAlignment = NSTextAlignment.left;
        view.addSubview(loginUsernameField)
        
        passwordField.placeholder = "Passcode";
        passwordField.font = CommonFontType.sfProTextRegular;
        passwordField.textAlignment = NSTextAlignment.left
        passwordField.isSecureTextEntry = true;
        passwordField.keyboardType = UIKeyboardType.numberPad;
        view.addSubview(passwordField)
        
        loginButton.setTitle("Login", for: .normal)
        loginButton.titleLabel?.font = CommonFontType.sfProTextBold;
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
        signUpButton.titleLabel?.font = CommonFontType.sfProTextBold;
        signUpButton.backgroundColor = CommonColor.buttonBlackColor;
        signUpButton.addTarget(self, action: #selector(signUpButtonTap(_:)), for: .touchUpInside);
        view.addSubview(signUpButton);
        
        view.setNeedsUpdateConstraints();
        self.queryUserTable(checkType: "ViewLoad");
        
        if let wow = RealmStore.model(type: SampleModel.self, query: "id = '6f08a081-dbdb-41ad-b61a-3c51e6859a4c'") {
            print(wow)
            RealmStore.delete(model: wow)
        }
        
    }
    
    @objc func loginButtonTouched() {
        //Defaults[.SessionIsLoggedIn] = false
        
        let result = self.checkEmptyText();
        
        if result == "Success"
        {
            self.queryUserTable(checkType: "LoginClick");
        }
        else
        {
            let controller = UIAlertController.alertControllerWithTitle(title: "Warning", message: result);
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
        
        let realm = try! Realm();
        if checkType == "ViewLoad" {
            resultUserList = realm.objects(UserModel.self);
            print(resultUserList);
        }
        else
        {
            resultUserList = realm.objects(UserModel.self).filter("U_Username = %@ AND U_Password = %@",self.loginUsernameField.text!, self.passwordField.text!);
        }
        
        if resultUserList.count > 0
        {
            self.loginButton.isEnabled = true;
            self.signUpButton.isHidden = true;
            
            if resultUserList[0].U_EnableTouchID == true
            {
                authenticationWithTouchID();
            }
            
            if checkType == "LoginClick"
            {
                self.present(BaseViewController(), animated: true, completion: nil);
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
                self.loginButton.isEnabled = false;
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
    
    func checkEmptyText()->String
    {
        if self.loginUsernameField.text?.count == 0
        {
            return "Login ID cannot empty";
        }
        else if self.passwordField.text?.count == 0
        {
            return "Passcode cannot empty";
        }
        else
        {
            return "Success";
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LoginViewController{
    func authenticationWithTouchID() {
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "Use Passcode"
        
        var authError: NSError?
        let reasonString = "To access the secure data"
        
        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            
            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString) { success, evaluateError in
                
                if success {
                    //TODO: User authenticated successfully, take appropriate action
                    let vc = RegisterViewController();
                    self.present(vc, animated: true, completion: nil);
                } else {
                    //TODO: User did not authenticate successfully, look at error and take appropriate action
                    guard let error = evaluateError else {
                        return
                    }
                    
                    print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code))
                    
                    //TODO: If you have choosen the 'Fallback authentication mechanism selected' (LAError.userFallback). Handle gracefully
                    
                }
            }
        } else {
            
            guard let error = authError else {
                return
            }
            //TODO: Show appropriate alert if biometry/TouchID/FaceID is lockout or not enrolled
            print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error.code))
        }
    }
    
    func evaluatePolicyFailErrorMessageForLA(errorCode: Int) -> String {
        var message = ""
        if #available(iOS 11.0, macOS 10.13, *) {
            switch errorCode {
            case LAError.biometryNotAvailable.rawValue:
                message = "Authentication could not start because the device does not support biometric authentication."
                
            case LAError.biometryLockout.rawValue:
                message = "Authentication could not continue because the user has been locked out of biometric authentication, due to failing authentication too many times."
                
            case LAError.biometryNotEnrolled.rawValue:
                message = "Authentication could not start because the user has not enrolled in biometric authentication."
                
            default:
                message = "Did not find error code on LAError object"
            }
        } else {
            switch errorCode {
            case LAError.touchIDLockout.rawValue:
                message = "Too many failed attempts."
                
            case LAError.touchIDNotAvailable.rawValue:
                message = "TouchID is not available on the device"
                
            case LAError.touchIDNotEnrolled.rawValue:
                message = "TouchID is not enrolled on the device"
                
            default:
                message = "Did not find error code on LAError object"
            }
        }
        
        return message;
    }
    
    func evaluateAuthenticationPolicyMessageForLA(errorCode: Int) -> String {
        
        var message = ""
        
        switch errorCode {
            
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.notInteractive.rawValue:
            message = "Not interactive"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = evaluatePolicyFailErrorMessageForLA(errorCode: errorCode)
        }
        
        return message
    }
}
